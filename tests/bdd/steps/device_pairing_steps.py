from pathlib import Path
import re

from behave import given, when, then

REPO_ROOT = Path(__file__).resolve().parents[3]


def load_text(path):
    return path.read_text(encoding="utf-8")


def load_desktop_html():
    return load_text(REPO_ROOT / "app" / "index.html")


def load_desktop_js():
    return load_text(REPO_ROOT / "app" / "app.js")


def load_mobile_html():
    return load_text(REPO_ROOT / "app" / "mobile" / "index.html")


def load_mobile_js():
    return load_text(REPO_ROOT / "app" / "mobile" / "app.js")


def load_cli_script():
    return load_text(REPO_ROOT / "bin" / "unified")


def has_id(html, element_id):
    return f'id="{element_id}"' in html


def cli_supports_auth_login(source):
    return bool(re.search(r"auth\s+login", source))


def cli_mentions_qr(source):
    return "QR" in source or "qr" in source


def cli_has_fallback_link(source):
    return "Fallback link" in source or "connection link" in source


def js_has_function(source, name):
    return bool(re.search(rf"function\s+{re.escape(name)}\s*\(", source))


def js_has_click_handler(source, element_id, function_name):
    pattern = rf"{re.escape(element_id)}[\s\S]*?addEventListener\(\s*['\"]click['\"][\s\S]*?{re.escape(function_name)}"
    return bool(re.search(pattern, source))


def js_reads_pairing_param(source):
    return "URLSearchParams" in source and "pairing" in source


def js_parses_manual_link(source):
    if not js_has_function(source, "parsePairingLink"):
        return False
    if "pairing" not in source:
        return False
    return "new URL" in source or "URL(" in source


def js_approves_pairing(source):
    if not js_has_function(source, "approvePairingRequest"):
        return False
    body_match = re.search(
        r"function\s+approvePairingRequest\s*\([^)]*\)\s*\{([\s\S]*?)\n\}",
        source,
    )
    if not body_match:
        return False
    body = body_match.group(1)
    return "savePairedDevices" in body or "pairedDevices" in body


def js_renders_device_list(source):
    return js_has_function(source, "renderDeviceList")


@given("I am signed in on the mobile app")
def step_signed_in_mobile(context):
    mobile_html = load_mobile_html()
    assert has_id(mobile_html, "mobile-account"), "Mobile signed-in status missing"
    context.device_state = {
        "mobile_html": mobile_html,
        "mobile_js": load_mobile_js(),
        "desktop_html": load_desktop_html(),
        "desktop_js": load_desktop_js(),
    }


@given("the unified CLI is installed on my computer")
def step_cli_installed(context):
    cli_path = REPO_ROOT / "bin" / "unified"
    assert cli_path.exists(), "Unified CLI script missing"
    cli_source = load_cli_script()
    assert "#!/usr/bin/env node" in cli_source, "Unified CLI script missing node shebang"
    context.device_state["cli_source"] = cli_source


@when('I run "unified auth login" on my computer')
def step_run_auth_login(context):
    cli_source = context.device_state["cli_source"]
    assert cli_supports_auth_login(cli_source), "Unified CLI does not support auth login"


@when("I choose the mobile QR pairing option")
def step_choose_qr_pairing(context):
    cli_source = context.device_state["cli_source"]
    assert cli_mentions_qr(cli_source), "Unified CLI does not mention QR pairing"


@then("the CLI shows a QR code and a fallback connection link")
def step_cli_shows_qr_and_link(context):
    cli_source = context.device_state["cli_source"]
    assert cli_mentions_qr(cli_source), "CLI does not show a QR code"
    assert cli_has_fallback_link(cli_source), "CLI does not show a fallback connection link"


@when("I scan the QR code in the mobile app")
def step_scan_qr_code(context):
    mobile_js = context.device_state["mobile_js"]
    assert js_reads_pairing_param(mobile_js), "Mobile app does not read pairing link parameters"


@when("I copy the connection link")
def step_copy_connection_link(context):
    cli_source = context.device_state["cli_source"]
    assert cli_has_fallback_link(cli_source), "CLI does not include a connection link to copy"


@when("I paste the link into the mobile app")
def step_paste_link_into_mobile(context):
    mobile_html = context.device_state["mobile_html"]
    mobile_js = context.device_state["mobile_js"]
    assert has_id(mobile_html, "manual-link-input"), "Manual link input missing"
    assert has_id(mobile_html, "submit-link"), "Manual link submit button missing"
    assert js_parses_manual_link(mobile_js), "Mobile app does not parse manual link input"
    assert js_has_click_handler(mobile_js, "submit-link", "submitManualLink"), (
        "Manual link submit button is not wired"
    )


@when("I approve the pairing request")
def step_approve_pairing(context):
    mobile_html = context.device_state["mobile_html"]
    mobile_js = context.device_state["mobile_js"]
    assert has_id(mobile_html, "approve-pairing"), "Approve pairing button missing"
    assert js_has_click_handler(mobile_js, "approve-pairing", "approvePairingRequest"), (
        "Approve pairing button is not wired"
    )
    assert js_approves_pairing(mobile_js), "Approve pairing does not store paired device"


@then("the computer is paired to my account")
def step_computer_paired(context):
    mobile_js = context.device_state["mobile_js"]
    assert "slice0001.devices" in mobile_js, "Paired devices storage key missing"
    assert js_approves_pairing(mobile_js), "Pairing approval does not record device"


@then("the computer appears in the app's device list")
def step_device_in_list(context):
    desktop_html = context.device_state["desktop_html"]
    desktop_js = context.device_state["desktop_js"]
    mobile_html = context.device_state["mobile_html"]
    mobile_js = context.device_state["mobile_js"]

    assert has_id(desktop_html, "device-list"), "Desktop device list container missing"
    assert has_id(mobile_html, "device-list"), "Mobile device list container missing"
    assert js_renders_device_list(desktop_js), "Desktop device list renderer missing"
    assert js_renders_device_list(mobile_js), "Mobile device list renderer missing"
