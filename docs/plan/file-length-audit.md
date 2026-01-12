# File Length Audit (2026-01-11)

## Scope
- Criterion: text files over 450 lines (hard limit is 500 lines).
- Method: line count scan of text files in repo (binary files ignored).

## Findings (2026-01-11)
Two files exceed the 500-line hard limit.

| File | Line Count | Status |
| --- | --- | --- |
| `utilities/delegate.sh` | 763 | ❌ Over 500 lines |
| `utilities/delegate.how-to.md` | 542 | ❌ Over 500 lines |

## Refresh (2026-01-12)
Re-scan of tracked text files shows the prior violations have been split and now comply.
The current over/near-limit list is below.

| File | Line Count | Status |
| --- | --- | --- |
| `package-lock.json` | 1313 | ❌ Over 500 lines (generated lockfile) |
| `app/app.part2.js` | 499 | ⚠️ Near limit |
| `app/app.part1.js` | 491 | ⚠️ Near limit |
| `app/mobile/app.js` | 463 | ⚠️ Near limit |
| `app/styles.part2.css` | 461 | ⚠️ Near limit |
| `tests/bdd/steps/task_orchestration_steps.py` | 459 | ⚠️ Near limit |

Notes:
- `utilities/delegate.sh` and `utilities/delegate.how-to.md` are now below 500 lines after the split.
- `package-lock.json` needs an explicit policy decision (exempt generated lockfiles or change tooling).

## Proposed Splits

### `utilities/delegate.sh` (763 lines)
**Goal:** Keep the entry script small and move function blocks into sourced modules.

Suggested split:
- `utilities/lib/delegate-sessions.sh`
  - Session management helpers: `show_status`, `kill_session`, `clean_sessions`, `purge_session`, `check_session`, `check_all_sessions`, `continue_session`, plus any related helpers.
- `utilities/lib/delegate-roles.sh`
  - Role helpers: `list_roles`, `load_common_role` and any shared constants for roles.
- `utilities/lib/delegate-prompt.sh`
  - Prompt construction: `build_prompt`, prompt file creation, and any prompt-related constants.
- `utilities/delegate.sh`
  - Keep: argument parsing, validation, and main execution flow; source the new modules at the top.

Expected outcome: each file under ~250 lines; entry script under ~200 lines.

### `utilities/delegate.how-to.md` (542 lines)
**Goal:** Split documentation into focused guides and keep the main doc as an overview.

Suggested split:
- `utilities/delegate.how-to.md`
  - Keep: Overview, Quick Start, and a short “How it works” section (target <200 lines).
- `docs/delegate/cli.md`
  - Command-line options table, common roles, and adding custom roles.
- `docs/delegate/usage.md`
  - Running tasks, monitoring, continuing conversations, session management, and state meanings.
- `docs/delegate/templates.md`
  - Role templates and task detail templates.
- `docs/delegate/troubleshooting.md`
  - Monitoring & debugging, troubleshooting, and best practices.

Add a short TOC and cross-links from the overview doc to the new pages.

## Notes
- No other text files exceeded 450 lines.
- This report does not change any files; it only proposes split targets.
