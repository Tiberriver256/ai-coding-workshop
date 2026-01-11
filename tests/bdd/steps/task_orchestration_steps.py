from html.parser import HTMLParser
from pathlib import Path
import re

from behave import given, when, then

REPO_ROOT = Path(__file__).resolve().parents[3]


class ButtonParser(HTMLParser):
    def __init__(self):
        super().__init__()
        self._current = None
        self._buffer = []
        self.buttons = []

    def handle_starttag(self, tag, attrs):
        if tag != "button":
            return
        attributes = dict(attrs)
        self._current = {
            "id": attributes.get("id"),
            "type": attributes.get("type", ""),
            "data-role": attributes.get("data-role"),
        }
        self._buffer = []

    def handle_data(self, data):
        if self._current is None:
            return
        self._buffer.append(data)

    def handle_endtag(self, tag):
        if tag != "button" or self._current is None:
            return
        text = "".join(self._buffer).strip()
        self._current["text"] = text
        self.buttons.append(self._current)
        self._current = None
        self._buffer = []


def load_html():
    html_path = REPO_ROOT / "app" / "index.html"
    return html_path.read_text(encoding="utf-8")


def load_js():
    js_path = REPO_ROOT / "app" / "app.js"
    return js_path.read_text(encoding="utf-8")


def has_id(html, element_id):
    return f'id="{element_id}"' in html


def has_validation_error_element(html):
    return 'id="title-error"' in html and 'role="alert"' in html


def has_assistant_toggle(html):
    return 'id="assistant-toggle"' in html


def has_assistant_suggest_button(html):
    return 'id="assistant-suggest"' in html


def has_assistant_suggestions_container(html):
    return 'id="assistant-suggestions"' in html and 'role="list"' in html


def parse_buttons(html):
    parser = ButtonParser()
    parser.feed(html)
    return parser.buttons


def find_button_by_id(buttons, button_id):
    for button in buttons:
        if button.get("id") == button_id:
            return button
    return None


def find_submit_button(buttons, label):
    return [
        button
        for button in buttons
        if button.get("type") == "submit" and button.get("text") == label
    ]


def extract_default_status(js_source):
    ternary_match = re.search(
        r"status:\s*startAttempt\s*\?\s*['\"](?P<start>[a-z_]+)['\"]\s*:\s*['\"](?P<default>[a-z_]+)['\"]",
        js_source,
    )
    if ternary_match:
        return ternary_match.group("default")
    match = re.search(r"status:\s*['\"](?P<status>[a-z_]+)['\"]", js_source)
    if not match:
        return None
    return match.group("status")


def extract_default_attempt_status(js_source):
    match = re.search(r"defaultAttemptStatus\s*=\s*['\"](?P<status>[a-z_]+)['\"]", js_source)
    if not match:
        return None
    return match.group("status")


def extract_default_agent_config(js_source):
    match = re.search(r"const\s+defaultAgentConfig\s*=\s*\{(?P<body>[^}]+)\}", js_source, re.S)
    if not match:
        return None
    body = match.group("body")
    config = {}
    for key, value in re.findall(r"([a-zA-Z_]+)\s*:\s*['\"]([^'\"]+)['\"]", body):
        config[key] = value
    for key, value in re.findall(r"([a-zA-Z_]+)\s*:\s*([0-9]+(?:\.[0-9]+)?)", body):
        config[key] = float(value) if "." in value else int(value)
    return config or None


def has_create_start_action(js_source):
    return "create-start" in js_source and "defaultAgentConfig" in js_source


def has_create_start_attempt(js_source):
    return bool(re.search(r"createAttempt\s*\(\s*defaultAgentConfig\s*\)", js_source))


def has_todo_column_config(js_source):
    key_match = re.search(r"key:\s*['\"]todo['\"]", js_source)
    list_match = re.search(r"list:\s*todoList", js_source)
    return bool(key_match and list_match)


def has_title_trim_validation(js_source):
    return bool(
        re.search(
            r"function\s+validateForm\(\)\s*\{[\s\S]*?titleInput\.value\.trim\(\)",
            js_source,
        )
    )


def extract_title_error_message(js_source):
    match = re.search(r"titleError\.textContent\s*=\s*['\"]([^'\"]+)['\"]", js_source)
    if not match:
        return None
    return match.group(1)


def has_validation_guard(js_source):
    return bool(
        re.search(
            r"form\.addEventListener\(\s*['\"]submit['\"][\s\S]*?if\s*\(!validateForm\(\)\)\s*\{\s*return;\s*\}",
            js_source,
        )
    )


def has_cancel_handler(js_source):
    return bool(
        re.search(
            r"cancelModalButton\.addEventListener\(\s*['\"]click['\"]\s*,\s*closeTaskModal\s*\)",
            js_source,
        )
    )


def has_assistant_toggle_handler(js_source):
    return bool(
        re.search(
            r"assistantToggle\.addEventListener\(\s*['\"]change['\"]",
            js_source,
        )
    )


def has_assistant_suggest_handler(js_source):
    return bool(
        re.search(
            r"assistantSuggestButton\.addEventListener\(\s*['\"]click['\"]",
            js_source,
        )
    )


def has_assistant_accept_handler(js_source):
    return bool(
        re.search(
            r"assistantSuggestions\.addEventListener\(\s*['\"]click['\"]",
            js_source,
        )
    )


def has_suggestion_insertion(js_source):
    return bool(
        re.search(
            r"function\s+insertSuggestion\([^)]+\)\s*\{[\s\S]*?descriptionInput\.value\s*=",
            js_source,
        )
    )


def extract_assistant_suggestions(js_source):
    match = re.search(
        r"assistantSuggestionTemplates\s*=\s*\[(?P<body>[\s\S]*?)\];",
        js_source,
    )
    if not match:
        return []
    body = match.group("body")
    return [item for item in re.findall(r"['\"]([^'\"]+)['\"]", body) if item.strip()]


def close_task_modal_closes_dialog(js_source):
    return bool(
        re.search(
            r"function\s+closeTaskModal\(\)\s*\{[\s\S]*?taskModal\.setAttribute\(\s*['\"]aria-hidden['\"]\s*,\s*['\"]true['\"]\s*\)",
            js_source,
        )
    )


def close_task_modal_resets_form(js_source):
    return bool(
        re.search(
            r"function\s+closeTaskModal\(\)\s*\{[\s\S]*?form\.reset\(\)",
            js_source,
        )
    )


def close_task_modal_clears_validation(js_source):
    return bool(
        re.search(
            r"function\s+closeTaskModal\(\)\s*\{[\s\S]*?clearValidation\(\)",
            js_source,
        )
    )


def assert_no_task_created(context, message):
    task = context.task_state.get("task")
    assert task is None, message


@given("I am on a project board")
def step_on_project_board(context):
    context.task_state = {
        "html": load_html(),
        "js": load_js(),
        "dialog_opened": False,
        "dialog_closed": True,
        "task": None,
    }


@when("I open the Create Task dialog")
def step_open_create_task_dialog(context):
    html = context.task_state["html"]
    assert has_id(html, "open-modal"), "Create Task button not found"
    assert has_id(html, "task-modal"), "Create Task dialog not found"
    context.task_state["dialog_opened"] = True
    context.task_state["dialog_closed"] = False


@when("I enter a title and description")
def step_enter_title_description(context):
    html = context.task_state["html"]
    assert has_id(html, "task-title"), "Task title input missing"
    assert has_id(html, "task-description"), "Task description input missing"
    context.task_state["task"] = {
        "title": "Draft onboarding checklist",
        "description": "Outline the first-run setup steps.",
    }


@given("I have enabled an AI CLI assistant for task prompts")
def step_enable_ai_assistant(context):
    html = context.task_state["html"]
    assert has_assistant_toggle(html), "AI assistant toggle missing"
    assert has_assistant_suggest_button(html), "AI assistant suggest action missing"
    assert has_assistant_suggestions_container(html), "AI assistant suggestions container missing"

    js_source = context.task_state["js"]
    assert has_assistant_toggle_handler(js_source), "AI assistant toggle is not wired"

    context.task_state["assistant_enabled"] = True
    context.task_state["description"] = ""


@when("I leave the title empty and submit")
def step_leave_title_empty(context):
    html = context.task_state["html"]
    assert has_id(html, "task-form"), "Task form missing"
    assert has_id(html, "task-title"), "Task title input missing"
    assert has_validation_error_element(html), "Title validation helper missing"

    js_source = context.task_state["js"]
    assert has_title_trim_validation(js_source), "Title validation logic missing"
    error_message = extract_title_error_message(js_source)
    assert error_message, "Title validation error message missing"

    context.task_state["task"] = None
    context.task_state["attempted_submission"] = {"title": "", "description": ""}


@when('I choose "Create"')
def step_choose_create(context):
    assert context.task_state["dialog_opened"], "Dialog was not opened"
    html = context.task_state["html"]
    buttons = parse_buttons(html)
    create_buttons = find_submit_button(buttons, "Create")
    assert create_buttons, "Create button not found in dialog"

    js_source = context.task_state["js"]
    status = extract_default_status(js_source)
    assert status is not None, "Unable to detect default task status"

    task = context.task_state["task"]
    task["status"] = status


@when('I choose "Create & Start"')
def step_choose_create_start(context):
    assert context.task_state["dialog_opened"], "Dialog was not opened"
    html = context.task_state["html"]
    buttons = parse_buttons(html)
    create_start_buttons = find_submit_button(buttons, "Create & Start")
    assert create_start_buttons, "Create & Start button not found in dialog"

    js_source = context.task_state["js"]
    assert has_create_start_action(js_source), "Create & Start action is not wired in app logic"
    assert has_create_start_attempt(js_source), "Create & Start does not start a default attempt"

    default_config = extract_default_agent_config(js_source)
    assert default_config is not None, "Default agent configuration missing"
    attempt_status = extract_default_attempt_status(js_source)
    assert attempt_status is not None, "Default attempt status missing"

    task = context.task_state["task"]
    task["status"] = "in_progress"
    context.task_state["attempt"] = {"status": attempt_status, "agent": default_config}


@when("I request autocomplete in the task description")
def step_request_autocomplete(context):
    assert context.task_state.get("assistant_enabled"), "AI assistant is not enabled"
    html = context.task_state["html"]
    assert has_id(html, "task-description"), "Task description input missing"
    assert has_assistant_suggest_button(html), "AI assistant suggest action missing"

    js_source = context.task_state["js"]
    assert has_assistant_suggest_handler(js_source), "AI assistant suggest action not wired"
    suggestions = extract_assistant_suggestions(js_source)
    assert suggestions, "AI assistant suggestions not configured"

    context.task_state["suggestions"] = suggestions


@when("I choose Cancel")
def step_choose_cancel(context):
    assert context.task_state["dialog_opened"], "Dialog was not opened"
    html = context.task_state["html"]
    buttons = parse_buttons(html)
    cancel_button = find_button_by_id(buttons, "cancel-modal")
    assert cancel_button, "Cancel button not found in dialog"
    assert cancel_button.get("type") == "button", "Cancel button must be type=button"

    js_source = context.task_state["js"]
    assert has_cancel_handler(js_source), "Cancel button is not wired to close the dialog"

    context.task_state["dialog_opened"] = False
    context.task_state["dialog_closed"] = True


@when("I accept a suggestion")
def step_accept_suggestion(context):
    suggestions = context.task_state.get("suggestions") or []
    assert suggestions, "No AI suggestions available to accept"

    js_source = context.task_state["js"]
    assert has_assistant_accept_handler(js_source), "AI suggestion accept handler missing"
    assert has_suggestion_insertion(js_source), "AI suggestion insertion logic missing"

    accepted = suggestions[0]
    description = context.task_state.get("description", "")
    context.task_state["description"] = f"{description} {accepted}".strip()
    context.task_state["accepted_suggestion"] = accepted


@then("the task is created")
def step_task_created(context):
    task = context.task_state["task"]
    assert task is not None, "Task was not created"
    assert task.get("status") == "in_progress", "Task did not move to In Progress"


@then("a task attempt starts with the default agent configuration")
def step_task_attempt_started(context):
    attempt = context.task_state.get("attempt")
    assert attempt is not None, "Task attempt was not started"
    assert attempt.get("status"), "Task attempt status missing"
    config = attempt.get("agent")
    assert config is not None, "Attempt agent configuration missing"
    assert config.get("provider"), "Agent provider not configured"
    assert config.get("model"), "Agent model not configured"


@then("the task appears in the To Do column")
def step_task_in_todo(context):
    html = context.task_state["html"]
    js_source = context.task_state["js"]
    task = context.task_state["task"]
    assert task is not None, "Task was not created"
    assert has_id(html, "todo-list"), "To Do column list missing"
    assert task["status"] == "todo", "Task did not default to To Do"
    assert has_todo_column_config(js_source), "To Do column rendering not configured"


@then("I see suggested completions")
def step_see_suggestions(context):
    html = context.task_state["html"]
    assert has_assistant_suggestions_container(html), "AI assistant suggestions container missing"
    suggestions = context.task_state.get("suggestions") or []
    assert suggestions, "AI assistant did not return suggestions"


@then("I see a validation error")
def step_validation_error(context):
    html = context.task_state["html"]
    assert has_validation_error_element(html), "Title validation element missing"
    js_source = context.task_state["js"]
    message = extract_title_error_message(js_source)
    assert message, "Title validation message not configured"


@then("the dialog closes")
def step_dialog_closes(context):
    assert context.task_state.get("dialog_closed"), "Dialog did not close"
    js_source = context.task_state["js"]
    assert close_task_modal_closes_dialog(js_source), "Close action does not hide the dialog"
    assert close_task_modal_resets_form(js_source), "Close action does not reset the form"
    assert close_task_modal_clears_validation(js_source), "Close action does not clear validation"


@then("the task is not created")
def step_task_not_created(context):
    assert_no_task_created(context, "Task should not be created when title is empty")
    js_source = context.task_state["js"]
    assert has_validation_guard(js_source), "Submit handler missing validation guard"


@then("no task is created")
def step_no_task_created(context):
    assert_no_task_created(context, "Task should not be created when canceling")


@then("the suggestion is inserted into the task description")
def step_suggestion_inserted(context):
    accepted = context.task_state.get("accepted_suggestion")
    description = context.task_state.get("description", "")
    assert accepted, "No accepted suggestion recorded"
    assert accepted in description, "Suggestion was not inserted into task description"
