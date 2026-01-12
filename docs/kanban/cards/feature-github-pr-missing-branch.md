# feature-github-pr-missing-branch

## Goal
Implement the BDD scenario "Target branch does not exist on remote" for GitHub support.

## Why
Finish GitHub support scenarios.

## Acceptance Criteria
- Behave scenario "Target branch does not exist on remote" passes in `tests/bdd/github-support.feature`.
- Selecting a missing base branch shows an error and blocks PR creation.
- Evidence recorded in `docs/testing/acceptance/bdd-github-pr-missing-branch.md`.

## Owner
Delegate: BDD feature owner (red/green/refactor sub-delegates).

## Status
Done

## What I Changed
- Added the missing-branch scenario to the BDD feature and step checks.
- Implemented base-branch validation with error messaging in the PR modal.
- Captured Behave evidence in `docs/testing/acceptance/bdd-github-pr-missing-branch.md`.

## Links
- Evidence: `docs/testing/acceptance/bdd-github-pr-missing-branch.md`
