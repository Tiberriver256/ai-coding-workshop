import re

from behave import given, then, when
from app_loader import load_html, load_js


def has_id(html, element_id):
    return f'id="{element_id}"' in html


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


def azure_cli_defaults_ready(js_source):
    match = re.search(r"defaultAzureSettings\s*=\s*\{(?P<body>[\s\S]*?)\}", js_source)
    if not match:
        return False
    body = match.group("body")
    return "installed: true" in body and "authenticated: true" in body and "devopsExtension: true" in body


def azure_cli_instructions_available(js_source):
    return (
        has_function(js_source, "setAzureCliInstructions")
        and "Install Azure CLI" in js_source
        and "az extension add" in js_source
        and "az login" in js_source
    )


def pr_modal_surfaces_azure_cli_instructions(js_source):
    body = extract_function_body(js_source, "openPullRequestModal")
    if not body:
        return False
    return "setAzureCliInstructions" in body and "isAzureCliReady" in body


def pr_creation_records_azure(js_source):
    body = extract_function_body(js_source, "createPullRequest")
    if not body:
        return False
    return "provider" in body and "azure" in body and "recordEvidence" in body


def pr_creation_blocked_without_azure_cli(js_source):
    body = extract_function_body(js_source, "createPullRequest")
    if not body:
        return False
    return "isAzureCliReady" in body and "return null" in body


def azure_repo_unsupported_message_available(html, js_source):
    return (
        has_id(html, "azure-repo-unsupported")
        and has_function(js_source, "setAzureRepoUnsupportedMessage")
        and "Azure Repos" in js_source
        and "unsupported" in js_source
    )


def pr_modal_surfaces_unsupported_repo(js_source):
    body = extract_function_body(js_source, "openPullRequestModal")
    if not body:
        return False
    return "isAzureRepoUnsupported" in body and "setAzureRepoUnsupportedMessage" in body


def pr_creation_blocked_for_unsupported_repo(js_source):
    body = extract_function_body(js_source, "createPullRequest")
    if not body:
        return False
    return "isAzureRepoUnsupported" in body and "setAzureRepoUnsupportedMessage" in body and "return null" in body


@given("my project repository is hosted on Azure Repos")
def step_project_hosted_on_azure(context):
    html = load_html()
    js_source = load_js()
    assert "data-repo-provider=\"azure\"" in html, "Repo provider must be set to Azure"
    assert has_function(js_source, "getRepoProvider"), "Repo provider helper missing"
    context.github_state = {}
    context.azure_state = context.github_state
    context.azure_state.update({"html": html, "js": js_source})


@given("my project is not hosted on Azure Repos")
def step_project_not_hosted_on_azure(context):
    html = load_html()
    js_source = load_js()
    assert "data-repo-provider=\"azure\"" in html, "Expected Azure Repos provider in base HTML"
    html = html.replace('data-repo-provider="azure"', 'data-repo-provider="github"')
    assert "data-repo-provider=\"github\"" in html, "Repo provider override failed"
    assert has_function(js_source, "getRepoProvider"), "Repo provider helper missing"
    context.azure_state = {"html": html, "js": js_source}


@given("the Azure CLI and DevOps extension are installed and authenticated")
def step_azure_cli_installed(context):
    html = context.azure_state["html"]
    js_source = context.azure_state["js"]
    assert has_id(html, "azure-cli-instructions"), "Azure CLI instructions element missing"
    assert has_function(js_source, "loadAzureSettings"), "Azure CLI settings loader missing"
    assert has_function(js_source, "isAzureCliReady"), "Azure CLI readiness check missing"
    assert azure_cli_defaults_ready(js_source), "Default Azure CLI settings must be installed and authenticated"
    assert azure_cli_instructions_available(js_source), "Azure CLI instructions are not wired"
    assert pr_modal_surfaces_azure_cli_instructions(js_source), "Azure CLI readiness not used in PR modal"


@given("the Azure CLI is not installed or authenticated")
def step_azure_cli_missing(context):
    js_source = context.azure_state["js"]
    assert azure_cli_instructions_available(js_source), "Azure CLI instructions are not wired"
    context.azure_state["installed"] = False
    context.azure_state["authenticated"] = False
    context.azure_state["devopsExtension"] = False


@when("I attempt to create a PR with Azure DevOps")
def step_attempt_create_azure_pr(context):
    html = context.azure_state["html"]
    js_source = context.azure_state["js"]
    assert has_id(html, "activity-pr"), "Create PR button missing"
    assert has_function(js_source, "openPullRequestModal"), "Open PR modal handler missing"
    assert pr_modal_surfaces_unsupported_repo(js_source), "Unsupported repo check missing in PR modal"


@then("a pull request is created on Azure DevOps")
def step_pr_created(context):
    js_source = context.azure_state["js"]
    assert has_function(js_source, "createPullRequest"), "Create PR handler missing"
    assert function_body_contains(js_source, "createPullRequest", "task.pullRequest"), "PR payload not saved on task"
    assert function_body_contains(js_source, "createPullRequest", "status"), "PR status not set"
    assert pr_creation_records_azure(js_source), "Azure PR creation details missing"


@then("I see instructions to install and authenticate the Azure CLI")
def step_azure_cli_instructions(context):
    html = context.azure_state["html"]
    assert has_id(html, "azure-cli-instructions"), "Azure CLI instructions element missing"
    js_source = context.azure_state["js"]
    assert azure_cli_instructions_available(js_source), "Azure CLI instructions are not visible"
    assert pr_modal_surfaces_azure_cli_instructions(js_source), "Missing Azure CLI instructions not surfaced"


@then("I see a message that the repository is unsupported")
def step_unsupported_repo_message(context):
    html = context.azure_state["html"]
    js_source = context.azure_state["js"]
    assert azure_repo_unsupported_message_available(html, js_source), "Unsupported repo message missing"
    assert pr_modal_surfaces_unsupported_repo(js_source), "Unsupported repo message not surfaced in PR modal"
    assert pr_creation_blocked_for_unsupported_repo(js_source), "Unsupported repo guard missing in PR creation"


@then("the Azure DevOps PR is not created")
def step_azure_pr_not_created(context):
    js_source = context.azure_state["js"]
    assert pr_creation_blocked_without_azure_cli(js_source), "PR creation guard missing when Azure CLI is unavailable"
    assert pr_creation_blocked_for_unsupported_repo(js_source), "PR creation guard missing for unsupported repo"
