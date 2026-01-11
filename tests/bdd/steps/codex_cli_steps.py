from pathlib import Path
import re

from behave import given, when, then

REPO_ROOT = Path(__file__).resolve().parents[3]


def load_cli_script():
    return (REPO_ROOT / "bin" / "unified").read_text(encoding="utf-8")


def get_cli_source(context):
    if hasattr(context, "device_state") and context.device_state.get("cli_source"):
        return context.device_state["cli_source"]
    return load_cli_script()


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


def cli_supports_codex_command(source):
    return bool(re.search(r"args\[0\]\s*===\s*['\"]codex['\"]", source))


def cli_defines_auth_token(source):
    return "UNIFIED_AUTH_TOKEN" in source


def cli_checks_auth_for_codex(source):
    body = extract_function_body(source, "handleCodexCommand")
    if not body:
        return False
    return "isAuthenticated" in body


def cli_starts_auth_flow_for_codex(source):
    body = extract_function_body(source, "handleCodexCommand")
    if not body:
        return False
    return "startAuthenticationFlow" in body


def cli_mentions_auth_flow_start(source):
    return "Starting authentication flow" in source or "Authentication required" in source


def cli_mentions_auth_completion(source):
    return "Authentication complete" in source


def cli_auth_flow_completes(source):
    body = extract_function_body(source, "startAuthenticationFlow")
    if not body:
        return False
    return "completeAuthentication" in body


def cli_auth_flow_precedes_session_start(source):
    body = extract_function_body(source, "handleCodexCommand")
    if not body:
        return False
    auth_index = body.find("startAuthenticationFlow")
    start_index = body.find("startCodexSession")
    if auth_index == -1 or start_index == -1:
        return False
    return auth_index < start_index


def cli_mentions_codex_start(source):
    return "Codex session started" in source


def cli_mentions_connected_message(source):
    return "Connected for remote access" in source


@given("I am authenticated with the product")
def step_authenticated(context):
    cli_source = get_cli_source(context)
    assert cli_defines_auth_token(cli_source), "Unified CLI missing auth token support"
    assert cli_checks_auth_for_codex(cli_source), "Unified CLI does not check auth before starting Codex"
    context.cli_source = cli_source


@given("I am not authenticated with the product")
def step_not_authenticated(context):
    cli_source = get_cli_source(context)
    assert cli_defines_auth_token(cli_source), "Unified CLI missing auth token support"
    assert cli_checks_auth_for_codex(cli_source), "Unified CLI does not check auth before starting Codex"
    assert cli_starts_auth_flow_for_codex(cli_source), "Unified CLI does not start auth flow for Codex"
    context.cli_source = cli_source


@when('I run "unified codex"')
def step_run_codex(context):
    cli_source = get_cli_source(context)
    assert cli_supports_codex_command(cli_source), "Unified CLI does not support the codex command"
    context.cli_source = cli_source


@then("a Codex session starts")
def step_codex_session_starts(context):
    cli_source = context.cli_source
    assert cli_mentions_codex_start(cli_source), "Codex session start message missing"


@then("the session is connected for remote access")
def step_codex_connected(context):
    cli_source = context.cli_source
    assert cli_mentions_connected_message(cli_source), "Codex session connected message missing"


@then("the product starts the authentication flow")
def step_auth_flow_starts(context):
    cli_source = context.cli_source
    assert cli_starts_auth_flow_for_codex(cli_source), "Auth flow is not triggered for unauthenticated Codex start"
    assert cli_mentions_auth_flow_start(cli_source), "Auth flow start message missing"


@then("the Codex session starts after authentication completes")
def step_codex_after_auth(context):
    cli_source = context.cli_source
    assert cli_mentions_auth_completion(cli_source), "Authentication completion message missing"
    assert cli_auth_flow_completes(cli_source), "Authentication flow does not complete"
    assert cli_auth_flow_precedes_session_start(cli_source), "Codex starts before auth flow completes"
    assert cli_mentions_codex_start(cli_source), "Codex session start message missing"
