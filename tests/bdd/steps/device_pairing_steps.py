import re

from behave import given, when, then
from app_loader import (
    REPO_ROOT,
    load_html,
    load_js,
    load_mobile_html,
    load_mobile_js,
    load_text,
)


def load_desktop_html():
    return load_html()


def load_desktop_js():
    return load_js()


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


def cli_mentions_rejection(source):
    return bool(re.search(r"reject", source, re.IGNORECASE))


def cli_supports_force_reauth(source):
    has_force_flag = "--force" in source
    has_force_link = "searchParams.set('force'" in source or 'searchParams.set("force"' in source or "force=true" in source
    return has_force_flag and has_force_link


def js_has_function(source, name):
    return bool(re.search(rf"function\s+{re.escape(name)}\s*\(", source))


def js_has_click_handler(source, element_id, function_name):
    pattern = rf"{re.escape(element_id)}[\s\S]*?addEventListener\(\s*['\"]click['\"][\s\S]*?{re.escape(function_name)}"
    return bool(re.search(pattern, source))


def js_reads_pairing_param(source):
    return "URLSearchParams" in source and "pairing" in source


def js_ingests_pairing_link(source):
    return js_has_function(source, "ingestPairingLink") and "ingestPairingLink()" in source


def js_parses_manual_link(source):
    if not js_has_function(source, "parsePairingLink"):
        return False
    if "pairing" not in source:
        return False
    return "new URL" in source or "URL(" in source


def js_validates_pairing_token(source):
    if not js_has_function(source, "isValidPairingToken"):
        return False
    return "pair_" in source


def js_handles_invalid_pairing_link(source):
    if "Invalid connection link" not in source:
        return False
    return "pairingError" in source or js_has_function(source, "setPairingError")


def js_disables_approve_on_invalid_link(source):
    pattern = r"if\s*\(\s*pairingError[\s\S]*?\)\s*\{[\s\S]*?approvePairingButton\.disabled\s*=\s*true"
    return bool(re.search(pattern, source))


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


def js_rejects_pairing(source):
    if not js_has_function(source, "rejectPairingRequest"):
        return False
    body_match = re.search(
        r"function\s+rejectPairingRequest\s*\([^)]*\)\s*\{([\s\S]*?)\n\}",
        source,
    )
    if not body_match:
        return False
    body = body_match.group(1)
    marks_rejected = bool(re.search(r"rejected", body, re.IGNORECASE))
    avoids_pairing = "savePairedDevices" not in body
    return marks_rejected and avoids_pairing


def js_renders_device_list(source):
    return js_has_function(source, "renderDeviceList")


def js_handles_force_pairing(source):
    if "force" not in source:
        return False
    has_param = "force" in source and ("params.get('force')" in source or "searchParams.get('force')" in source)
    has_request_flag = "force" in source and ("pairingRequest.force" in source or "force:" in source)
    return has_param and has_request_flag


def js_marks_repaired_status(source):
    if "re-paired" not in source and "repaired" not in source:
        return False
    return "status" in source and ("re-paired" in source or "repaired" in source)


def js_shows_repaired_status(source):
    if "pairingStatus" not in source:
        return False
    return "Re-paired" in source or "Repaired" in source


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


@when("I open a valid connection link in the mobile app")
def step_open_valid_link(context):
    mobile_js = context.device_state["mobile_js"]
    assert js_reads_pairing_param(mobile_js), "Mobile app does not read pairing link parameters"
    assert js_ingests_pairing_link(mobile_js), "Mobile app does not ingest pairing links"


@when("I open an invalid connection link in the mobile app")
def step_open_invalid_link(context):
    mobile_js = context.device_state["mobile_js"]
    assert js_validates_pairing_token(mobile_js), "Mobile app does not validate pairing tokens"
    assert js_handles_invalid_pairing_link(mobile_js), "Mobile app does not handle invalid connection links"


@when("I approve the pairing request")
def step_approve_pairing(context):
    mobile_html = context.device_state["mobile_html"]
    mobile_js = context.device_state["mobile_js"]
    assert has_id(mobile_html, "approve-pairing"), "Approve pairing button missing"
    assert js_has_click_handler(mobile_js, "approve-pairing", "approvePairingRequest"), (
        "Approve pairing button is not wired"
    )
    assert js_approves_pairing(mobile_js), "Approve pairing does not store paired device"


@when("I reject the pairing request")
def step_reject_pairing(context):
    mobile_html = context.device_state["mobile_html"]
    mobile_js = context.device_state["mobile_js"]
    assert has_id(mobile_html, "reject-pairing"), "Reject pairing button missing"
    assert js_has_click_handler(mobile_js, "reject-pairing", "rejectPairingRequest"), (
        "Reject pairing button is not wired"
    )
    assert js_rejects_pairing(mobile_js), "Reject pairing does not mark request rejected"


@then("the computer is paired to my account")
def step_computer_paired(context):
    mobile_js = context.device_state["mobile_js"]
    assert "slice0001.devices" in mobile_js, "Paired devices storage key missing"
    assert js_approves_pairing(mobile_js), "Pairing approval does not record device"


@then("the computer is not paired to my account")
def step_computer_not_paired(context):
    mobile_js = context.device_state["mobile_js"]
    assert js_rejects_pairing(mobile_js), "Rejection does not avoid pairing the device"


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


@then("I see an invalid link message")
def step_invalid_link_message(context):
    mobile_js = context.device_state["mobile_js"]
    assert "Invalid connection link" in mobile_js, "Invalid link message missing"


@then("I cannot approve the pairing")
def step_cannot_approve_pairing(context):
    mobile_js = context.device_state["mobile_js"]
    assert js_disables_approve_on_invalid_link(mobile_js), "Approve button not disabled for invalid link"


@then("the CLI shows that the request was rejected")
def step_cli_rejected(context):
    cli_source = context.device_state["cli_source"]
    assert cli_mentions_rejection(cli_source), "CLI does not mention rejection state"


@given("my computer is already paired")
def step_computer_already_paired(context):
    mobile_js = context.device_state["mobile_js"]
    assert "pairedDevicesKey" in mobile_js, "Paired devices storage key missing"
    assert "loadPairedDevices" in mobile_js, "Paired devices loader missing"


@when('I run "unified auth login --force" on my computer')
def step_run_auth_login_force(context):
    cli_source = context.device_state["cli_source"]
    assert cli_supports_force_reauth(cli_source), "Unified CLI does not support forced re-authentication"


@when("I approve the new pairing request on my phone")
def step_approve_new_pairing(context):
    mobile_js = context.device_state["mobile_js"]
    assert js_handles_force_pairing(mobile_js), "Mobile app does not handle force re-pair requests"
    assert js_approves_pairing(mobile_js), "Approve pairing does not store paired device"


@then("the computer is re-paired")
def step_computer_repaired(context):
    mobile_js = context.device_state["mobile_js"]
    assert js_marks_repaired_status(mobile_js), "Re-pair status not recorded for device"


@then("the app shows the updated pairing status")
def step_app_shows_updated_status(context):
    mobile_js = context.device_state["mobile_js"]
    assert js_shows_repaired_status(mobile_js), "Updated pairing status not shown in the app"
