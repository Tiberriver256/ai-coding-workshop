# feature-task-orchestration-create-start

## Goal
Implement the BDD scenario "Create and start a task attempt immediately" for task orchestration.

## Why
We need coverage for creating a task and kicking off agent work in one action.

## Acceptance Criteria
- Behave scenario `Create and start a task attempt immediately` passes in `tests/bdd/task-orchestration.feature`.
- UI shows a Create & Start option that creates a task and marks an attempt as started.
- Test evidence recorded.

## Owner
Delegate: BDD feature owner (red/green/refactor sub-delegates).

## Status
Done

## What I Changed
- Added the BDD scenario and steps to validate Create & Start behavior and default agent configuration wiring.
- Implemented Create & Start UI, default attempt metadata, and in-progress status handling in the task board UI.
- Captured Behave evidence in `docs/testing/acceptance/bdd-task-orchestration-create-start.md`.

## Links
- Evidence: `docs/testing/acceptance/bdd-task-orchestration-create-start.md`
