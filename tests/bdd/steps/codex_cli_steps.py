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
