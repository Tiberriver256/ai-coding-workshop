import re

from behave import given, when, then
from app_loader import load_html, load_js


def has_id(html, element_id):
    return f'id="{element_id}"' in html


def has_role(html, element_id, role):
    return f'id="{element_id}"' in html and f'role="{role}"' in html


def has_aria_live(html, element_id):
    return f'id="{element_id}"' in html and 'aria-live="polite"' in html


def button_text_matches(html, element_id, text):
    pattern = rf'id="{re.escape(element_id)}"[^>]*>\s*{re.escape(text)}\s*<'
    return bool(re.search(pattern, html))


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


def has_running_attempt(js_source):
    pattern = r"taskViewAttempt\s*=\s*\{[\s\S]*?status\s*:\s*['\"]running['\"]"
    return bool(re.search(pattern, js_source))


def extract_log_entries(js_source):
    match = re.search(r"taskViewLogEntries\s*=\s*\[(?P<body>[\s\S]*?)\];", js_source)
    if not match:
        return ""
    return match.group("body")


def log_entries_include_kinds(js_source, kinds):
    body = extract_log_entries(js_source)
    return all(re.search(rf"kind\s*:\s*['\"]{re.escape(kind)}['\"]", body) for kind in kinds)


def extract_process_entries(js_source):
    match = re.search(r"taskViewProcesses\s*=\s*\[(?P<body>[\s\S]*?)\];", js_source)
    if not match:
        return ""
    return match.group("body")


def process_entries_include_status_and_timestamps(js_source):
    body = extract_process_entries(js_source)
    if not body:
        return False
    has_status = bool(re.search(r"status\s*:\s*['\"]", body))
    has_time = bool(re.search(r"(startedAt|updatedAt)\s*:\s*", body))
    return has_status and has_time


def has_process_log_seed(js_source):
    return bool(re.search(r"taskProcessLogEntries\s*=\s*\{", js_source))


def has_list_click_handler(js_source, list_id, function_name):
    pattern = rf"{re.escape(list_id)}[\s\S]*?addEventListener\(\s*['\"]click['\"][\s\S]*?{re.escape(function_name)}"
    return bool(re.search(pattern, js_source))


@given("a task attempt is running")
def step_task_attempt_running(context):
    html = load_html()
    js_source = load_js()
    assert has_id(html, "task-view"), "Task view panel missing"
    assert has_running_attempt(js_source), "Running task attempt seed missing"
    context.monitoring_state = {"html": html, "js": js_source}


@when("I open the task view")
def step_open_task_view(context):
    html = context.monitoring_state["html"]
    js_source = context.monitoring_state["js"]
    assert has_id(html, "open-task-view"), "Open task view control missing"
    assert has_id(html, "task-view-status"), "Task view status label missing"
    assert has_function(js_source, "openTaskView"), "Open task view handler missing"
    assert has_button_handler(js_source, "open-task-view", "openTaskView"), "Open task view action not wired"


@then("I see streaming logs of agent actions and responses")
def step_see_streaming_logs(context):
    html = context.monitoring_state["html"]
    js_source = context.monitoring_state["js"]
    assert has_id(html, "task-log-stream"), "Task log stream container missing"
    assert has_role(html, "task-log-stream", "log"), "Task log stream must use role=log"
    assert has_aria_live(html, "task-log-stream"), "Task log stream must be aria-live"
    assert has_function(js_source, "startTaskLogStream"), "Log streaming function missing"
    assert has_function(js_source, "renderTaskLogEntry"), "Log entry renderer missing"
    assert function_body_contains(js_source, "startTaskLogStream", "setInterval"), "Log stream does not schedule updates"
    assert log_entries_include_kinds(js_source, ["action", "response"]), "Log stream missing action/response entries"


@when('I open "View Processes"')
def step_open_view_processes(context):
    html = context.monitoring_state["html"]
    js_source = context.monitoring_state["js"]
    assert has_id(html, "open-processes"), "View processes button missing"
    assert button_text_matches(html, "open-processes", "View Processes"), "View Processes label missing"
    assert has_function(js_source, "openProcessPanel"), "Open processes handler missing"
    assert has_button_handler(js_source, "open-processes", "openProcessPanel"), "View Processes action not wired"


@then("I see a list of processes with status and timestamps")
def step_see_process_list(context):
    html = context.monitoring_state["html"]
    js_source = context.monitoring_state["js"]
    assert has_id(html, "process-panel"), "Process panel missing"
    assert has_id(html, "process-list"), "Process list container missing"
    assert has_function(js_source, "renderProcessList"), "Process list renderer missing"
    assert has_function(js_source, "renderProcessListItem"), "Process list item renderer missing"
    assert process_entries_include_status_and_timestamps(js_source), "Process list missing status/timestamp data"
    assert function_body_contains(js_source, "renderProcessListItem", "formatTimestamp"), "Process timestamps not formatted"


@then("I can open a process to view its logs")
def step_open_process_logs(context):
    html = context.monitoring_state["html"]
    js_source = context.monitoring_state["js"]
    assert has_id(html, "process-log-viewer"), "Process log viewer missing"
    assert has_id(html, "process-log-entries"), "Process log list missing"
    assert has_function(js_source, "openProcessLogView"), "Process log view handler missing"
    assert has_function(js_source, "renderProcessLogEntry"), "Process log entry renderer missing"
    assert has_process_log_seed(js_source), "Process log seed data missing"
    assert has_list_click_handler(js_source, "process-list", "handleProcessListClick"), "Process list click handler missing"
