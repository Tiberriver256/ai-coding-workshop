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
        self._current = {"id": attributes.get("id")}
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


def parse_buttons(html):
    parser = ButtonParser()
    parser.feed(html)
    return parser.buttons


def find_button_by_id(buttons, button_id):
    for button in buttons:
        if button.get("id") == button_id:
            return button
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


def function_body_contains(js_source, function_name, fragment):
    body = extract_function_body(js_source, function_name)
    return fragment in body


def has_button_handler(js_source, button_id, function_name):
    pattern = rf"{re.escape(button_id)}[\s\S]*?addEventListener\(\s*['\"]click['\"][\s\S]*?{re.escape(function_name)}"
    return bool(re.search(pattern, js_source))


def function_records_evidence(js_source, function_name, evidence_type):
    literal_pattern = rf"function\s+{re.escape(function_name)}[\s\S]*?recordEvidence\([\s\S]*?['\"]{evidence_type}['\"]"
    constant_pattern = rf"function\s+{re.escape(function_name)}[\s\S]*?recordEvidence\([\s\S]*?activityEvidenceTypes\.{re.escape(evidence_type)}"
    return bool(re.search(literal_pattern, js_source) or re.search(constant_pattern, js_source))


def activity_task_has_changes(js_source):
    pattern = r"function\s+createActivityTask[\s\S]*?changes:\s*\["
    return bool(re.search(pattern, js_source))


def select_has_option(html, select_id, option_value):
    pattern = rf"<select[^>]*id=\"{re.escape(select_id)}\"[\s\S]*?<option[^>]*value=\"{re.escape(option_value)}\""
    return bool(re.search(pattern, html))


def github_cli_instructions_available(js_source):
    return (
        has_function(js_source, "setGithubCliInstructions")
        and "Install GitHub CLI" in js_source
        and "gh auth login" in js_source
    )


def pr_modal_surfaces_github_cli_instructions(js_source):
    body = extract_function_body(js_source, "openPullRequestModal")
    if not body:
        return False
    return "setGithubCliInstructions" in body and "isGithubCliReady" in body


def pr_creation_blocked_without_github_cli(js_source):
    body = extract_function_body(js_source, "createPullRequest")
    if not body:
        return False
    return "isGithubCliReady" in body and "return null" in body


@given("my project repository is hosted on GitHub")
def step_project_hosted_on_github(context):
    context.github_state = {}


@given("a task attempt has changes")
def step_task_attempt_has_changes(context):
    html = load_html()
    js_source = load_js()
    assert has_id(html, "agent-activity"), "Agent activity panel missing"
    assert has_id(html, "pr-modal"), "Create PR modal missing"
    assert has_function(js_source, "openPullRequestModal"), "Open PR modal handler missing"
    assert activity_task_has_changes(js_source), "Seeded activity task does not include changes"
    context.github_state.update({"html": html, "js": js_source})


@given("the GitHub CLI is installed and authenticated")
def step_github_cli_installed(context):
    js_source = context.github_state["js"]
    assert has_function(js_source, "loadGithubSettings"), "GitHub CLI settings loader missing"
    assert has_function(js_source, "isGithubCliReady"), "GitHub CLI readiness check missing"
    assert re.search(r"defaultGithubSettings\s*=\s*\{[^}]*installed:\s*true[^}]*authenticated:\s*true", js_source), (
        "Default GitHub CLI settings must be installed and authenticated"
    )


@when('I click "Create PR"')
def step_click_create_pr(context):
    html = context.github_state["html"]
    js_source = context.github_state["js"]
    buttons = parse_buttons(html)
    create_button = find_button_by_id(buttons, "activity-pr")
    assert create_button and create_button.get("text") == "Create PR", "Create PR button missing"
    assert has_button_handler(js_source, "activity-pr", "openPullRequestModal"), "Create PR button is not wired"


@then("the PR title and description are prefilled from the task")
def step_pr_prefilled(context):
    js_source = context.github_state["js"]
    assert function_body_contains(js_source, "openPullRequestModal", "task.title"), "PR title not sourced from task"
    assert function_body_contains(js_source, "openPullRequestModal", "task.description"), "PR description not sourced from task"
    assert function_body_contains(js_source, "openPullRequestModal", "prTitleInput.value"), "PR title input not set"
    assert function_body_contains(js_source, "openPullRequestModal", "prDescriptionInput.value"), "PR description input not set"


@then("I can select a base branch")
def step_base_branch_select(context):
    html = context.github_state["html"]
    assert has_id(html, "pr-base-branch"), "Base branch select missing"
    assert select_has_option(html, "pr-base-branch", "main"), "Main branch option missing"
    assert select_has_option(html, "pr-base-branch", "develop"), "Develop branch option missing"


@then("a pull request is created on GitHub")
def step_pr_created(context):
    js_source = context.github_state["js"]
    assert has_function(js_source, "createPullRequest"), "Create PR handler missing"
    assert function_body_contains(js_source, "createPullRequest", "task.pullRequest"), "PR payload not saved on task"
    assert function_body_contains(js_source, "createPullRequest", "status"), "PR status not set"
    assert function_records_evidence(js_source, "createPullRequest", "pull_request_created"), "PR evidence not recorded"


@then("the task shows the PR status")
def step_task_shows_pr_status(context):
    js_source = context.github_state["js"]
    assert function_body_contains(js_source, "renderTaskList", "task.pullRequest"), "Task card does not read PR data"
    assert function_body_contains(js_source, "renderTaskList", "task-pr"), "Task PR status label missing"


@given("the GitHub CLI is not installed or authenticated")
def step_github_cli_missing(context):
    js_source = context.github_state["js"]
    assert github_cli_instructions_available(js_source), "GitHub CLI instructions are not wired"
    context.github_state["installed"] = False
    context.github_state["authenticated"] = False


@when("I attempt to create a PR")
def step_attempt_create_pr(context):
    html = context.github_state["html"]
    js_source = context.github_state["js"]
    buttons = parse_buttons(html)
    create_button = find_button_by_id(buttons, "activity-pr")
    assert create_button, "Create PR button missing"
    assert has_button_handler(js_source, "activity-pr", "openPullRequestModal"), "Create PR button is not wired"
    assert pr_modal_surfaces_github_cli_instructions(js_source), "Missing GitHub CLI instructions not surfaced"


@then("I see instructions to install and authenticate the GitHub CLI")
def step_github_cli_instructions(context):
    html = context.github_state["html"]
    assert has_id(html, "github-cli-instructions"), "GitHub CLI instructions element missing"
    js_source = context.github_state["js"]
    assert github_cli_instructions_available(js_source), "GitHub CLI instructions are not visible"


@then("the PR is not created")
def step_pr_not_created(context):
    js_source = context.github_state["js"]
    assert pr_creation_blocked_without_github_cli(js_source), "PR creation guard missing when GitHub CLI is unavailable"
