# feature-kanban-board-status-updates

## Goal
Implement the BDD scenario "Task status updates from agent activity" for the kanban board.

## Why
We need the board to reflect agent attempt lifecycle transitions end-to-end.

## Acceptance Criteria
- Behave scenario `Task status updates from agent activity` passes in `tests/bdd/kanban-board.feature`.
- Task transitions To Do -> In Progress -> In Review -> Done.
- Evidence recorded for each transition.
- Acceptance evidence captured.

## Owner
Delegate: BDD feature owner (red/green/refactor sub-delegates).

## Status
Done

## What I Changed
- Added BDD scenario coverage and step assertions for agent-driven status transitions.
- Implemented agent activity controls, status transitions, and evidence logging in the UI/app logic.
- Captured Behave run evidence in `docs/testing/acceptance/bdd-kanban-board-status-updates.md`.

## Links
- Evidence: `docs/testing/acceptance/bdd-kanban-board-status-updates.md`
