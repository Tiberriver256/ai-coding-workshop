# acceptance-test-automation

## Goal
Automate Slice 0001 acceptance tests.

## Why
Repeatable evidence is required for launch readiness and CI.

## Acceptance Criteria
- Playwright (or equivalent) tests added under `tests/acceptance/`.
- `package.json` includes `test:acceptance` script.
- `docs/testing/acceptance/slice-0001.md` updated with automated run evidence.
- Kanban card updated with summary and evidence link.

## Owner
Delegate: QA automation engineer.

## Status
Done

## Summary
Added Playwright harness + acceptance tests covering create, validation, cancel, and persistence.

## Links
- PR/commit: (pending)
- Evidence: `docs/testing/acceptance/slice-0001.md`

## Notes
- Kept harness minimal (static server + Playwright config).
