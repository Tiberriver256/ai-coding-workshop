# split-delegate-script

## Goal
Split `utilities/delegate.sh` into smaller modules under 500 lines per file.

## Why
Hard rule: no file may exceed 500 lines.

## Acceptance Criteria
- `utilities/delegate.sh` reduced below 500 lines.
- New helper modules created in `utilities/lib/` as needed.
- All delegate functionality preserved (`./delegate.sh --help` works).
- Kanban card updated with summary and evidence link.

## Owner
Delegate: Refactoring specialist.

## Status
Done

## Links
- PR/commit: (pending)
- Evidence: [utilities/delegate.sh](../../../utilities/delegate.sh), [utilities/lib/delegate-sessions.sh](../../../utilities/lib/delegate-sessions.sh), [utilities/lib/delegate-roles.sh](../../../utilities/lib/delegate-roles.sh), [utilities/lib/delegate-prompt.sh](../../../utilities/lib/delegate-prompt.sh)

## Notes
- Keep shell scripts POSIX/Bash compatible as currently used.
- No file may exceed 500 lines.
- Summary: extracted session management, role helpers, and prompt building into `utilities/lib/` modules; `utilities/delegate.sh` now sources them and stays under 500 lines.
