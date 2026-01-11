from html.parser import HTMLParser
from pathlib import Path
import re

from behave import given, when, then

COLUMN_HEADINGS = ("To Do", "In Progress", "In Review", "Done")
REPO_ROOT = Path(__file__).resolve().parents[3]


class ColumnHeadingParser(HTMLParser):
    def __init__(self):
        super().__init__()
        self._capture = False
        self._buffer = []
        self.headings = []

    def handle_starttag(self, tag, attrs):
        if tag == "h2":
            self._capture = True
            self._buffer = []

    def handle_data(self, data):
        if self._capture:
            self._buffer.append(data)

    def handle_endtag(self, tag):
        if tag == "h2" and self._capture:
            text = "".join(self._buffer).strip()
            if text:
                self.headings.append(text)
            self._capture = False
            self._buffer = []


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


def function_sets_status(js_source, function_name, status_value):
    pattern = rf"function\s+{re.escape(function_name)}\s*\([^)]*\)\s*\{{[\s\S]*?['\"]{status_value}['\"]"
    return bool(re.search(pattern, js_source))


def has_record_evidence(js_source):
    return bool(
        re.search(r"function\s+recordEvidence\s*\(", js_source) and "task.evidence" in js_source
    )


def function_records_evidence(js_source, function_name, evidence_type):
    literal_pattern = rf"function\s+{re.escape(function_name)}[\s\S]*?recordEvidence\([\s\S]*?['\"]{evidence_type}['\"]"
    constant_pattern = rf"function\s+{re.escape(function_name)}[\s\S]*?recordEvidence\([\s\S]*?activityEvidenceTypes\.{re.escape(evidence_type)}"
    return bool(re.search(literal_pattern, js_source) or re.search(constant_pattern, js_source))


def has_button_handler(js_source, button_id, function_name):
    pattern = rf"{re.escape(button_id)}[\s\S]*?addEventListener\(\s*['\"]click['\"][\s\S]*?{re.escape(function_name)}"
    return bool(re.search(pattern, js_source))


def has_activity_task_seed(js_source):
    seed_present = re.search(r"function\s+seedActivityTask\s*\(", js_source)
    todo_in_create = re.search(
        r"function\s+createActivityTask\s*\([\s\S]*?status:\s*['\"]todo['\"]",
        js_source,
    )
    todo_in_seed = re.search(
        r"function\s+seedActivityTask\s*\([\s\S]*?status:\s*['\"]todo['\"]",
        js_source,
    )
    return bool(seed_present and (todo_in_create or todo_in_seed))


@given("a project has tasks in multiple statuses")
def step_project_has_tasks(context):
    context.kanban_state["columns"] = list(COLUMN_HEADINGS)


@when("I open the project board")
def step_open_project_board(context):
    html = load_html()
    parser = ColumnHeadingParser()
    parser.feed(html)
    context.kanban_state["columns"] = parser.headings
    context.kanban_state["opened"] = True


@then("I see tasks grouped into columns such as To Do, In Progress, In Review, and Done")
def step_see_task_columns(context):
    assert context.kanban_state["opened"], "Board was not opened"
    expected = set(COLUMN_HEADINGS)
    assert expected.issubset(set(context.kanban_state["columns"])), (
        "Expected columns are missing"
    )


@given("a task is in the To Do column")
def step_task_in_todo_column(context):
    html = load_html()
    js_source = load_js()
    assert has_id(html, "todo-list"), "To Do column list missing"
    assert has_id(html, "agent-activity"), "Agent activity panel missing"
    assert has_id(html, "activity-log"), "Activity log container missing"

    buttons = parse_buttons(html)
    start_button = find_button_by_id(buttons, "activity-start")
    complete_button = find_button_by_id(buttons, "activity-complete")
    merge_button = find_button_by_id(buttons, "activity-merge")
    assert start_button and start_button.get("text") == "Start Attempt", "Start Attempt button missing"
    assert (
        complete_button and complete_button.get("text") == "Complete Attempt"
    ), "Complete Attempt button missing"
    assert merge_button and merge_button.get("text") == "Merge Task", "Merge Task button missing"

    assert has_activity_task_seed(js_source), "Seed task for agent activity missing"
    assert has_record_evidence(js_source), "Evidence logging is not configured"

    context.kanban_state = {
        "html": html,
        "js": js_source,
        "task": {"id": "task_agent_activity_demo", "status": "todo"},
        "evidence": [],
    }


@when("a task attempt starts")
def step_task_attempt_starts(context):
    js_source = context.kanban_state["js"]
    assert has_function(js_source, "startTaskAttempt"), "Start attempt handler missing"
    assert function_sets_status(js_source, "startTaskAttempt", "in_progress"), (
        "Start attempt does not move task to In Progress"
    )
    assert function_records_evidence(js_source, "startTaskAttempt", "attempt_started"), (
        "Start attempt does not record evidence"
    )
    assert has_button_handler(js_source, "activity-start", "startTaskAttempt"), (
        "Start attempt button is not wired"
    )

    context.kanban_state["task"]["status"] = "in_progress"
    context.kanban_state["evidence"].append("attempt_started")


@then("the task moves to In Progress")
def step_task_moves_in_progress(context):
    task = context.kanban_state["task"]
    assert task.get("status") == "in_progress", "Task did not move to In Progress"
    assert "attempt_started" in context.kanban_state["evidence"], "Attempt start evidence missing"


@when("the attempt completes")
def step_attempt_completes(context):
    js_source = context.kanban_state["js"]
    assert has_function(js_source, "completeTaskAttempt"), "Complete attempt handler missing"
    assert function_sets_status(js_source, "completeTaskAttempt", "in_review"), (
        "Complete attempt does not move task to In Review"
    )
    assert function_records_evidence(js_source, "completeTaskAttempt", "attempt_completed"), (
        "Complete attempt does not record evidence"
    )
    assert has_button_handler(js_source, "activity-complete", "completeTaskAttempt"), (
        "Complete attempt button is not wired"
    )

    context.kanban_state["task"]["status"] = "in_review"
    context.kanban_state["evidence"].append("attempt_completed")


@then("the task moves to In Review")
def step_task_moves_in_review(context):
    task = context.kanban_state["task"]
    assert task.get("status") == "in_review", "Task did not move to In Review"
    assert "attempt_completed" in context.kanban_state["evidence"], "Attempt completion evidence missing"


@when("the task is merged")
def step_task_merged(context):
    js_source = context.kanban_state["js"]
    assert has_function(js_source, "mergeTask"), "Merge handler missing"
    assert function_sets_status(js_source, "mergeTask", "done"), (
        "Merge does not move task to Done"
    )
    assert function_records_evidence(js_source, "mergeTask", "task_merged"), (
        "Merge does not record evidence"
    )
    assert has_button_handler(js_source, "activity-merge", "mergeTask"), (
        "Merge button is not wired"
    )

    context.kanban_state["task"]["status"] = "done"
    context.kanban_state["evidence"].append("task_merged")


@then("the task moves to Done")
def step_task_moves_done(context):
    task = context.kanban_state["task"]
    assert task.get("status") == "done", "Task did not move to Done"
    assert "task_merged" in context.kanban_state["evidence"], "Merge evidence missing"
