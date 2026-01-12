import re

from behave import given, when, then
from app_loader import load_html, load_js, load_mobile_html, load_mobile_js


def has_id(html, element_id):
    return f'id="{element_id}"' in html


def js_has_function(source, name):
    return bool(re.search(rf"function\s+{re.escape(name)}\s*\(", source))


def js_has_click_handler(source, element_id, function_name):
    pattern = rf"{re.escape(element_id)}[\s\S]*?addEventListener\(\s*['\"]click['\"][\s\S]*?{re.escape(function_name)}"
    return bool(re.search(pattern, source))


def js_has_element_reference(source, element_id):
    pattern = rf"getElementById\(\s*['\"]{re.escape(element_id)}['\"]\s*\)"
    return bool(re.search(pattern, source))


def js_uses_sessions_key(source):
    return "slice0001.sessions" in source


def js_uses_active_session_key(source):
    return "slice0001.mobile_active_session" in source


def extract_function_body(source, function_name):
    match = re.search(rf"function\s+{re.escape(function_name)}\s*\([^)]*\)\s*\{{", source)
    if not match:
        return ""
    start = match.end()
    brace_depth = 1
    index = start
    while index < len(source):
        char = source[index]
        if char == "{":
            brace_depth += 1
        elif char == "}":
            brace_depth -= 1
            if brace_depth == 0:
                return source[start:index]
        index += 1
    return ""


def function_body_contains(source, function_name, fragment):
    body = extract_function_body(source, function_name)
    return fragment in body


@given("my computer is paired to my account")
def step_paired_account(context):
    desktop_html = load_html()
    mobile_html = load_mobile_html()
    assert has_id(desktop_html, "device-list"), "Desktop device list missing"
    assert has_id(mobile_html, "device-list"), "Mobile device list missing"
    context.session_state = {
        "desktop_html": desktop_html,
        "desktop_js": load_js(),
        "mobile_html": mobile_html,
        "mobile_js": load_mobile_js(),
    }


@when("I start a new session on my computer")
def step_start_session(context):
    desktop_html = context.session_state["desktop_html"]
    desktop_js = context.session_state["desktop_js"]
    assert has_id(desktop_html, "start-session"), "Start session button missing"
    assert has_id(desktop_html, "session-list"), "Desktop session list missing"
    assert js_has_function(desktop_js, "createSession"), "Session factory missing"
    assert js_has_function(desktop_js, "startLocalSession"), "Start session handler missing"
    assert js_uses_sessions_key(desktop_js), "Desktop sessions storage key missing"
    assert js_has_click_handler(desktop_js, "start-session", "startLocalSession"), "Start session action not wired"


@then("the session appears in the mobile app sessions list")
def step_session_mobile_list(context):
    mobile_html = context.session_state["mobile_html"]
    mobile_js = context.session_state["mobile_js"]
    assert has_id(mobile_html, "session-list"), "Mobile session list missing"
    assert has_id(mobile_html, "session-count"), "Mobile session count missing"
    assert js_uses_sessions_key(mobile_js), "Mobile sessions storage key missing"
    assert js_has_function(mobile_js, "renderSessionList"), "Mobile session renderer missing"


@then("the session appears in the web app sessions list")
def step_session_web_list(context):
    desktop_html = context.session_state["desktop_html"]
    desktop_js = context.session_state["desktop_js"]
    assert has_id(desktop_html, "session-list"), "Web session list missing"
    assert js_has_function(desktop_js, "renderSessionList"), "Web session renderer missing"


@then("the session shows as online")
def step_session_online(context):
    desktop_js = context.session_state["desktop_js"]
    mobile_js = context.session_state["mobile_js"]
    assert function_body_contains(desktop_js, "renderSessionList", "Online"), "Web session online label missing"
    assert function_body_contains(mobile_js, "renderSessionList", "Online"), "Mobile session online label missing"
    assert function_body_contains(desktop_js, "renderSessionList", "online"), "Web session online status missing"
    assert function_body_contains(mobile_js, "renderSessionList", "online"), "Mobile session online status missing"


@given("I am viewing my computer in the mobile app")
def step_view_mobile_computer(context):
    mobile_html = load_mobile_html()
    mobile_js = load_mobile_js()
    assert has_id(mobile_html, "device-list"), "Mobile device list missing"
    assert has_id(mobile_html, "project-path-input"), "Mobile project path input missing"
    assert js_has_element_reference(mobile_js, "project-path-input"), "Mobile project path input not wired"
    context.session_state = {
        "mobile_html": mobile_html,
        "mobile_js": mobile_js,
    }


@when("I enter a project path")
def step_enter_project_path(context):
    mobile_html = context.session_state["mobile_html"]
    mobile_js = context.session_state["mobile_js"]
    assert has_id(mobile_html, "project-path-input"), "Mobile project path input missing"
    assert has_id(mobile_html, "project-path-status"), "Mobile project path status missing"
    assert js_has_element_reference(mobile_js, "project-path-input"), "Mobile project path input not referenced"


@when("I start a new session")
def step_start_mobile_session(context):
    mobile_html = context.session_state["mobile_html"]
    mobile_js = context.session_state["mobile_js"]
    assert has_id(mobile_html, "start-mobile-session"), "Mobile start session button missing"
    assert js_has_function(mobile_js, "startMobileSession"), "Mobile session start handler missing"
    assert js_has_click_handler(
        mobile_js, "start-mobile-session", "startMobileSession"
    ), "Mobile start session action not wired"


@then("a new session is created on my computer")
def step_mobile_session_created(context):
    mobile_js = context.session_state["mobile_js"]
    assert js_uses_sessions_key(mobile_js), "Mobile sessions storage key missing"
    assert js_has_function(mobile_js, "saveSessions"), "Mobile sessions save helper missing"
    assert js_has_function(mobile_js, "createSessionFromPath"), "Mobile session factory missing"
    assert function_body_contains(
        mobile_js, "startMobileSession", "saveSessions"
    ), "Mobile start session does not persist"


@then("the session opens on my phone")
def step_mobile_session_open(context):
    mobile_html = context.session_state["mobile_html"]
    mobile_js = context.session_state["mobile_js"]
    assert has_id(mobile_html, "active-session"), "Active session panel missing"
    assert js_has_function(mobile_js, "renderActiveSession"), "Active session renderer missing"
    assert js_has_function(mobile_js, "setActiveSession"), "Active session setter missing"
    assert js_uses_active_session_key(mobile_js), "Active session storage key missing"
