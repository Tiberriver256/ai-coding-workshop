# feature-task-orchestration-autocomplete

## Goal
Implement the BDD scenario "Autocomplete task instructions with an AI assistant" for task orchestration.

## Why
Complete the remaining task-orchestration scenario with BDD coverage.

## Acceptance Criteria
- Behave scenario `Autocomplete task instructions with an AI assistant` passes in `tests/bdd/task-orchestration.feature`.
- UI offers suggestions when the assistant is enabled and inserts an accepted suggestion into the task description.
- Test evidence recorded.

## Owner
Delegate: BDD feature owner (red/green/refactor sub-delegates).

## Status
Done

## What I Changed
- Added the BDD scenario and steps to validate assistant toggle, suggestions, and insertion behavior.
- Implemented the AI assistant toggle, suggestion rendering, and insertion logic in the task modal UI.
- Captured Behave evidence in `docs/testing/acceptance/bdd-task-orchestration-autocomplete.md`.

## Links
- Evidence: `docs/testing/acceptance/bdd-task-orchestration-autocomplete.md`
