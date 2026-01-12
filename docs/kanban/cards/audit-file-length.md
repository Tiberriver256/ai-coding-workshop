# audit-file-length

## Goal
Audit repository text files for the 500-line limit and plan any splits.

## Why
Violations are a hard rule; catching them early prevents launch blockers.

## Acceptance Criteria
- Report created at `docs/plan/file-length-audit.md` listing any files >450 lines and split actions.
- Kanban card updated with summary and evidence link.

## Owner
Delegate: Refactoring specialist.

## Status
Done

## Links
- PR/commit: (pending)
- Evidence: `docs/plan/file-length-audit.md`

## Notes
- Read-only scan; do not modify existing files unless explicitly instructed.
- No file may exceed 500 lines.
- Summary: Found 2 files over 500 lines (`utilities/delegate.sh`, `utilities/delegate.how-to.md`) with proposed split plans in the audit report.
