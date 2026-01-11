# feature-task-orchestration-create-task

## Goal
Implement the BDD scenario "Create a task without starting an agent" for task orchestration.

## Why
We need coverage for task creation that queues work without triggering an agent.

## Acceptance Criteria
- Behave scenario `Create a task without starting an agent` passes in `tests/bdd/task-orchestration.feature`.
- UI shows a Create Task dialog with a Create button that places tasks in To Do.
- Test evidence recorded.

## Owner
Delegate: BDD feature owner (red/green/refactor sub-delegates).

## Status
Done

## What I Changed
- Added the task orchestration BDD feature and steps to assert Create dialog behavior and To Do placement.
- Updated the Create button label and verified the default To Do status in the UI logic.
- Captured Behave evidence in `docs/testing/acceptance/bdd-task-orchestration-create-task.md`.

## Links
- Evidence: `docs/testing/acceptance/bdd-task-orchestration-create-task.md`
