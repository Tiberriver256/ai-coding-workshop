# cli-executable

## Goal
Deliver an executable CLI that starts the server via pi-mono.

## Why
Sprint review requires a real CLI that launches the backend.

## Acceptance Criteria
- CLI command documented in `docs/setup/README.md`.
- CLI starts the server and logs a ready message.
- BDD test added for CLI flow (Playwright/Appium/CLI runner as appropriate).
- Kanban card updated with summary and evidence link.

## Owner
Delegate: Backend engineer (pi-mono).

## Status
Done

## Summary
Implemented `task-board` CLI entrypoint that starts the server and logs the ready URL, updated setup/integration docs, and added a node-based CLI smoke test.

## Links
- PR/commit: (pending)
- Evidence: `tests/cli/cli-smoke.test.js`

## Notes
- Align with pi-mono architecture in `~/repos/pi-mono`.
- No file may exceed 500 lines.
