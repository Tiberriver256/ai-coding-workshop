# feature-kanban-board-manual-move

## Goal
Implement the BDD scenario "Manually move a task without triggering agent work" for the kanban board.

## Why
Continue the kanban-board scenarios sequentially while ensuring manual task moves stay separate from agent activity.

## Acceptance Criteria
- Behave scenario `Manually move a task without triggering agent work` passes in `tests/bdd/kanban-board.feature`.
- Drag/move relocates the task between columns.
- No agent activity is recorded solely by the drag.
- Acceptance evidence captured.

## Owner
Delegate: BDD feature owner (red/green/refactor sub-delegates).

## Status
Done

## What I Changed
- Added BDD scenario coverage and step assertions for manual drag/move behavior.
- Implemented drag-and-drop status updates without evidence logging.
- Captured Behave run evidence in `docs/testing/acceptance/bdd-kanban-board-manual-move.md`.

## Links
- Evidence: `docs/testing/acceptance/bdd-kanban-board-manual-move.md`
