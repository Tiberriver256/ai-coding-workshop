from html.parser import HTMLParser
from pathlib import Path
import re

from behave import given, when, then

REPO_ROOT = Path(__file__).resolve().parents[3]


class SelectOptionParser(HTMLParser):
    def __init__(self, target_id):
        super().__init__()
        self.target_id = target_id
        self.in_target = False
        self._current = None
        self._buffer = []
        self.options = []

    def handle_starttag(self, tag, attrs):
        attributes = dict(attrs)
        if tag == "select" and attributes.get("id") == self.target_id:
            self.in_target = True
            return
        if tag == "option" and self.in_target:
            self._current = {
                "value": attributes.get("value"),
                "disabled": "disabled" in attributes or attributes.get("disabled") is not None,
            }
            self._buffer = []

    def handle_data(self, data):
        if self._current is None:
            return
        self._buffer.append(data)

    def handle_endtag(self, tag):
        if tag == "option" and self._current is not None:
            label = "".join(self._buffer).strip()
            self._current["label"] = label
            self.options.append(self._current)
            self._current = None
            self._buffer = []
            return
        if tag == "select" and self.in_target:
            self.in_target = False


def load_html():
    html_path = REPO_ROOT / "app" / "index.html"
    return html_path.read_text(encoding="utf-8")


def load_js():
    js_path = REPO_ROOT / "app" / "app.js"
    return js_path.read_text(encoding="utf-8")


def has_id(html, element_id):
    return f'id="{element_id}"' in html


def parse_select_options(html, select_id):
    parser = SelectOptionParser(select_id)
    parser.feed(html)
    return parser.options


def find_option(options, value):
    for option in options:
        if option.get("value") == value:
            return option
    return None


def has_function(js_source, function_name):
    return bool(re.search(rf"function\s+{re.escape(function_name)}\s*\(", js_source))


def extract_function_body(js_source, function_name):
    match = re.search(rf"function\s+{re.escape(function_name)}\s*\([^)]*\)\s*\{{", js_source)
    if not match:
        return ""
    start = match.end()
    brace_depth = 1
    index = start
    while index < len(js_source):
        char = js_source[index]
        if char == "{":
            brace_depth += 1
        elif char == "}":
            brace_depth -= 1
            if brace_depth == 0:
                return js_source[start:index]
        index += 1
    return ""


def has_event_handler(js_source, element_name, event_name):
    pattern = rf"{re.escape(element_name)}\.addEventListener\(\s*['\"]{re.escape(event_name)}['\"]"
    return bool(re.search(pattern, js_source))


def copilot_defaults_ready(js_source):
    match = re.search(r"defaultCopilotSettings\s*=\s*\{(?P<body>[\s\S]*?)\}", js_source)
    if not match:
        return False
    body = match.group("body")
    return "installed: true" in body and "authenticated: true" in body


def js_enables_copilot_option(js_source):
    body = extract_function_body(js_source, "updateAssistantProviderAvailability")
    if not body:
        return False
    return "copilot-cli" in body and "disabled" in body and "copilotSettings" in body


def js_tracks_assistant_provider(js_source):
    return has_function(js_source, "setAssistantProvider") and "assistantProvider" in js_source


def js_requests_use_provider(js_source):
    body = extract_function_body(js_source, "requestAssistantSuggestions")
    if not body:
        return False
    return "assistantProvider" in body


def extract_copilot_suggestions(js_source):
    match = re.search(
        r"copilotSuggestionTemplates\s*=\s*\[(?P<body>[\s\S]*?)\];",
        js_source,
    )
    if not match:
        return []
    body = match.group("body")
    return [item for item in re.findall(r"['\"]([^'\"]+)['\"]", body) if item.strip()]


def js_requests_copilot_suggestions(js_source):
    body = extract_function_body(js_source, "requestAssistantSuggestions")
    if not body:
        return False
    return "assistantProvider === 'copilot-cli'" in body and "copilotSuggestionTemplates" in body


def js_sets_copilot_install_instructions(js_source):
    body = extract_function_body(js_source, "updateCopilotStatusUI")
    if not body:
        return False
    return "setCopilotInstructions" in body and "installed" in body and "Install Copilot CLI" in body


def js_sets_copilot_auth_instructions(js_source):
    body = extract_function_body(js_source, "updateCopilotStatusUI")
    if not body:
        return False
    return "setCopilotInstructions" in body and "authenticated" in body and "Authenticate Copilot CLI" in body


def js_blocks_copilot_enable_when_not_ready(js_source):
    body = extract_function_body(js_source, "setCopilotEnabled")
    if not body:
        return False
    return "isCopilotReady" in body and "nextEnabled" in body and "ready &&" in body


def js_inserts_suggestion(js_source):
    body = extract_function_body(js_source, "insertSuggestion")
    if not body:
        return False
    return "descriptionInput.value" in body


@given("I am signed in to the product")
def step_signed_in(context):
    html = load_html()
    assert "Local Task Board" in html, "Expected the signed-in board to load"
    context.copilot_state = {"html": html, "js": load_js(), "signed_in": True}


@given("Copilot CLI is installed and authenticated")
def step_copilot_ready(context):
    js_source = context.copilot_state["js"]
    assert copilot_defaults_ready(js_source), "Copilot defaults do not indicate installed/authenticated"
    context.copilot_state["installed"] = True
    context.copilot_state["authenticated"] = True


@when("I enable Copilot CLI in Settings")
def step_enable_copilot(context):
    html = context.copilot_state["html"]
    assert has_id(html, "settings-panel"), "Settings panel missing"
    assert has_id(html, "copilot-toggle"), "Copilot toggle missing"
    assert has_id(html, "copilot-status"), "Copilot status element missing"

    js_source = context.copilot_state["js"]
    assert has_event_handler(js_source, "copilotToggle", "change"), "Copilot toggle is not wired"
    assert has_function(js_source, "setCopilotEnabled"), "Copilot enable handler missing"

    installed = context.copilot_state.get("installed", True)
    authenticated = context.copilot_state.get("authenticated", True)
    context.copilot_state["enabled"] = installed and authenticated


@then("Copilot CLI is available as an assistant")
def step_copilot_available(context):
    assert context.copilot_state.get("enabled"), "Copilot CLI was not enabled"
    html = context.copilot_state["html"]
    assert has_id(html, "assistant-provider"), "Assistant provider selector missing"
    options = parse_select_options(html, "assistant-provider")
    copilot_option = find_option(options, "copilot-cli")
    assert copilot_option, "Copilot CLI option missing from assistant selector"
    js_source = context.copilot_state["js"]
    assert js_enables_copilot_option(js_source), "Copilot option is not toggled by settings"


@then("I can select it for task prompt autocomplete")
def step_select_copilot_for_autocomplete(context):
    js_source = context.copilot_state["js"]
    assert has_event_handler(js_source, "assistantProviderSelect", "change"), (
        "Assistant provider selector is not wired"
    )
    assert js_tracks_assistant_provider(js_source), "Assistant provider state is not tracked"
    assert js_requests_use_provider(js_source), "Autocomplete does not use selected assistant"


@given("Copilot CLI is enabled")
def step_copilot_enabled(context):
    html = context.copilot_state["html"]
    js_source = context.copilot_state["js"]
    assert copilot_defaults_ready(js_source), "Copilot defaults do not indicate installed/authenticated"
    assert has_id(html, "assistant-panel"), "Assistant panel missing from task modal"
    assert has_function(js_source, "setCopilotEnabled"), "Copilot enable handler missing"
    assert js_enables_copilot_option(js_source), "Copilot availability is not wired"
    context.copilot_state["enabled"] = True


@when("I request autocomplete while writing a task description")
def step_request_copilot_autocomplete(context):
    html = context.copilot_state["html"]
    js_source = context.copilot_state["js"]
    assert has_id(html, "task-description"), "Task description field missing"
    assert has_id(html, "assistant-suggest"), "Assistant suggest button missing"
    assert has_event_handler(js_source, "assistantSuggestButton", "click"), "Suggest button is not wired"
    assert has_function(js_source, "requestAssistantSuggestions"), "Suggestion request handler missing"
    context.copilot_state["requested"] = True


@then("I see Copilot suggestions")
def step_see_copilot_suggestions(context):
    assert context.copilot_state.get("requested"), "Autocomplete was not requested"
    html = context.copilot_state["html"]
    js_source = context.copilot_state["js"]
    assert has_id(html, "assistant-suggestions"), "Assistant suggestions container missing"
    suggestions = extract_copilot_suggestions(js_source)
    assert suggestions, "Copilot suggestions are not configured"
    assert js_requests_copilot_suggestions(js_source), "Copilot suggestions are not requested"
    context.copilot_state["suggestions"] = suggestions


@then("I can insert a suggestion into the task description")
def step_insert_copilot_suggestion(context):
    js_source = context.copilot_state["js"]
    assert has_event_handler(js_source, "assistantSuggestions", "click"), "Suggestion click handler missing"
    assert has_function(js_source, "insertSuggestion"), "Suggestion insertion handler missing"
    assert js_inserts_suggestion(js_source), "Suggestion insertion does not update description"


@given("Copilot CLI is not installed")
def step_copilot_not_installed(context):
    js_source = context.copilot_state["js"]
    assert js_sets_copilot_install_instructions(js_source), "Copilot install instructions are not wired"
    context.copilot_state["installed"] = False
    context.copilot_state["authenticated"] = False


@given("Copilot CLI is installed but not authenticated")
def step_copilot_not_authenticated(context):
    js_source = context.copilot_state["js"]
    assert js_sets_copilot_auth_instructions(js_source), "Copilot auth instructions are not wired"
    context.copilot_state["installed"] = True
    context.copilot_state["authenticated"] = False


@then("I see instructions to install Copilot CLI")
def step_copilot_install_instructions(context):
    html = context.copilot_state["html"]
    assert has_id(html, "copilot-instructions"), "Copilot install instructions element missing"
    js_source = context.copilot_state["js"]
    assert js_sets_copilot_install_instructions(js_source), "Copilot install instructions are not surfaced"


@then("I see instructions to authenticate Copilot CLI")
def step_copilot_auth_instructions(context):
    html = context.copilot_state["html"]
    assert has_id(html, "copilot-instructions"), "Copilot auth instructions element missing"
    js_source = context.copilot_state["js"]
    assert js_sets_copilot_auth_instructions(js_source), "Copilot auth instructions are not surfaced"


@then("Copilot CLI is not enabled")
def step_copilot_not_enabled(context):
    assert context.copilot_state.get("enabled") is False, "Copilot CLI is unexpectedly enabled"
    js_source = context.copilot_state["js"]
    assert js_blocks_copilot_enable_when_not_ready(js_source), "Copilot enable guard missing"
