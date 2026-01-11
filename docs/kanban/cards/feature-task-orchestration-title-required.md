# feature-task-orchestration-title-required

## Goal
Implement the BDD scenario "Task creation requires a title" for task orchestration.

## Why
We need validation coverage to prevent empty-title tasks from being created.

## Acceptance Criteria
- Behave scenario `Task creation requires a title` passes in `tests/bdd/task-orchestration.feature`.
- UI shows a validation error when the title is empty.
- Task creation is blocked when the title is empty.
- Test evidence recorded.

## Owner
Delegate: BDD feature owner (red/green/refactor sub-delegates).

## Status
Done

## What I Changed
- Added BDD steps to assert title-required validation and blocked creation.
- Updated the Create Task title input to be required and visually invalid when empty.
- Captured Behave evidence in `docs/testing/acceptance/bdd-task-orchestration-title-required.md`.

## Links
- Evidence: `docs/testing/acceptance/bdd-task-orchestration-title-required.md`
