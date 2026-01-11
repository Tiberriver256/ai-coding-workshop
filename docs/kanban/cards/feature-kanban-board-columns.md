# feature-kanban-board-columns

## Goal
Implement the BDD scenario "Tasks appear in status columns" for the kanban board.

## Why
We need feature-driven coverage of the UI columns to ensure user-facing expectations are met.

## Acceptance Criteria
- Behave scenario `Tasks appear in status columns` passes in `tests/bdd/kanban-board.feature`.
- UI shows columns for To Do, In Progress, In Review, and Done.
- Test evidence recorded.

## Owner
Delegate: BDD feature owner (red/green/refactor sub-delegates).

## Status
Done

## What I Changed
- Updated BDD steps to read column headings from `app/index.html`.
- Expanded the board UI to four columns and grouped task rendering by status.
- Captured Behave run evidence in `docs/testing/acceptance/bdd-kanban-board-columns.md`.

## Links
- Evidence: `docs/testing/acceptance/bdd-kanban-board-columns.md`
