# feature-github-pr-missing-auth

## Goal
Implement the BDD scenario "Missing GitHub CLI authentication prevents PR creation" for GitHub support.

## Why
Continue GitHub support scenarios.

## Acceptance Criteria
- Behave scenario "Missing GitHub CLI authentication prevents PR creation" passes in `tests/bdd/github-support.feature`.
- Missing GitHub CLI auth shows instructions and blocks PR creation.
- Evidence recorded in `docs/testing/acceptance/bdd-github-pr-missing-auth.md`.

## Owner
Delegate: BDD feature owner (red/green/refactor sub-delegates).

## Status
Done

## What I Changed
- Added the missing-auth scenario to the GitHub support BDD feature and steps.
- Implemented GitHub CLI instruction messaging plus PR creation guards in the PR modal flow.
- Captured Behave evidence in `docs/testing/acceptance/bdd-github-pr-missing-auth.md`.

## Links
- Evidence: `docs/testing/acceptance/bdd-github-pr-missing-auth.md`
