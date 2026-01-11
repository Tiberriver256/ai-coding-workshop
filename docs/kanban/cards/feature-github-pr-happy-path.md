# feature-github-pr-happy-path

## Goal
Implement the BDD scenario "Create a pull request from a task attempt (happy path)" for GitHub support.

## Why
Begin GitHub support feature scenarios with a successful Create PR flow.

## Acceptance Criteria
- Behave scenario `Create a pull request from a task attempt (happy path)` passes in `tests/bdd/github-support.feature`.
- Create PR modal is prefilled, allows base branch selection, and shows PR status on the task.
- Evidence recorded in the task activity.

## Owner
Delegate: BDD feature owner (red/green/refactor sub-delegates).

## Status
Done

## What I Changed
- Added the GitHub support BDD feature and steps to validate Create PR modal behavior and PR status rendering.
- Implemented the Create PR modal, base branch selection, and mocked PR status/evidence in the task UI.
- Captured Behave evidence in `docs/testing/acceptance/bdd-github-pr-happy-path.md`.

## Links
- Evidence: `docs/testing/acceptance/bdd-github-pr-happy-path.md`
