import re

from behave import given, when, then
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


def has_button_handler(js_source, button_id, function_name):
    pattern = rf"{re.escape(button_id)}[\s\S]*?addEventListener\(\s*['\"]click['\"][\s\S]*?{re.escape(function_name)}"
    return bool(re.search(pattern, js_source))


def has_click_listener(js_source, target_name, function_name):
    pattern = rf"{re.escape(target_name)}\s*\.\s*addEventListener\(\s*['\"]click['\"]\s*,\s*{re.escape(function_name)}"
    return bool(re.search(pattern, js_source))


def review_task_seeded(js_source):
    pattern = r"function\s+createReviewTask[\s\S]*?status:\s*['\"]in_review['\"]"
    return bool(re.search(pattern, js_source))


def review_task_has_diff_files(js_source):
    return bool(re.search(r"diffFiles\s*:\s*\[", js_source))


def review_task_has_diff_lines(js_source):
    pattern = r"diffFiles\s*:\s*\[[\s\S]*?lines\s*:\s*\["
    return bool(re.search(pattern, js_source))


def render_list_opens_review(js_source):
    body = extract_function_body(js_source, "renderTaskList")
    return "openReviewModal" in body and "in_review" in body


def open_review_selects_diff(js_source):
    body = extract_function_body(js_source, "openReviewModal")
    return "setReviewView" in body and "diff" in body


@given("a task is in the In Review column")
def step_task_in_review_column(context):
    html = load_html()
    js_source = load_js()
    assert has_id(html, "in-review-list"), "In Review column list missing"
    assert has_function(js_source, "createReviewTask"), "Review task seed missing"
    assert review_task_seeded(js_source), "Review task is not seeded with in_review status"
    assert review_task_has_diff_files(js_source), "Review task diff file list missing"
    context.review_state = {"html": html, "js": js_source}


@when("I open the task and select the diff view")
def step_open_task_select_diff(context):
    html = context.review_state["html"]
    js_source = context.review_state["js"]
    assert has_id(html, "review-modal"), "Review modal missing"
    assert has_id(html, "review-diff-tab"), "Diff view tab missing"
    assert has_function(js_source, "openReviewModal"), "Open review modal handler missing"
    assert has_function(js_source, "setReviewView"), "Review view selector missing"
    assert render_list_opens_review(js_source), "Review action is not wired from task list"
    assert has_button_handler(js_source, "review-diff-tab", "setReviewView"), "Diff tab is not wired"
    assert open_review_selects_diff(js_source), "Review modal does not select diff view"


@then("I see the list of files changed")
def step_see_file_list(context):
    html = context.review_state["html"]
    js_source = context.review_state["js"]
    assert has_id(html, "diff-file-list"), "Diff file list container missing"
    assert has_function(js_source, "renderDiffFileList"), "Diff file list renderer missing"
    assert function_body_contains(js_source, "renderDiffFileList", "diffFiles"), "Diff file list does not use diffFiles"


@then("I can switch between inline and split view")
def step_switch_inline_split(context):
    html = context.review_state["html"]
    js_source = context.review_state["js"]
    assert has_id(html, "diff-inline"), "Inline view toggle missing"
    assert has_id(html, "diff-split"), "Split view toggle missing"
    assert has_function(js_source, "setDiffViewMode"), "Diff view mode setter missing"
    assert has_button_handler(js_source, "diff-inline", "setDiffViewMode"), "Inline toggle is not wired"
    assert has_button_handler(js_source, "diff-split", "setDiffViewMode"), "Split toggle is not wired"


@given("I am viewing a file diff")
def step_viewing_file_diff(context):
    html = load_html()
    js_source = load_js()
    assert has_id(html, "diff-file-list"), "Diff file list container missing"
    assert has_function(js_source, "renderDiffFileList"), "Diff file list renderer missing"
    assert has_function(js_source, "renderDiffLines"), "Diff line renderer missing"
    assert review_task_has_diff_lines(js_source), "Review task diff lines missing"
    context.review_state = {"html": html, "js": js_source}


@when("I click the comment icon next to a line")
def step_click_comment_icon(context):
    js_source = context.review_state["js"]
    assert "diff-line-comment" in js_source, "Diff line comment button missing"
    assert has_function(js_source, "toggleLineCommentForm"), "Line comment toggle missing"
    assert has_function(js_source, "handleDiffFileListClick"), "Diff line click handler missing"
    assert has_click_listener(js_source, "diffFileList", "handleDiffFileListClick"), "Diff line click handler not wired"


@when("I enter a comment")
def step_enter_comment(context):
    js_source = context.review_state["js"]
    assert has_function(js_source, "buildLineCommentForm"), "Line comment form builder missing"
    assert "diff-comment-input" in js_source, "Line comment input missing"
    assert "diff-comment-submit" in js_source, "Line comment submit action missing"


@then("the comment is added to my review")
def step_comment_added_to_review(context):
    html = context.review_state["html"]
    js_source = context.review_state["js"]
    assert has_id(html, "review-comment-list"), "Review comment list container missing"
    assert has_function(js_source, "addLineComment"), "Line comment add logic missing"
    assert has_function(js_source, "renderReviewComments"), "Review comment renderer missing"
