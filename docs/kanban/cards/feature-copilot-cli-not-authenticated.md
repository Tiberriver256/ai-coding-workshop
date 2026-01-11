# feature-copilot-cli-not-authenticated

## Goal
Implement the BDD scenario "Copilot CLI is installed but not authenticated" for Copilot CLI support.

## Why
Finish copilot-cli-support scenarios.

## Acceptance Criteria
- Behave scenario `Copilot CLI is installed but not authenticated` passes in `tests/bdd/copilot-cli-support.feature`.
- Settings show authentication instructions and Copilot CLI remains disabled when not authenticated.
- Test evidence recorded.

## Owner
Delegate: BDD feature owner (red/green/refactor sub-delegates).

## Status
Done

## What I Changed
- Added the BDD scenario and steps for Copilot CLI not-authenticated handling.
- Ensured settings keep Copilot disabled until authentication is complete.
- Captured Behave evidence in `docs/testing/acceptance/bdd-copilot-cli-not-authenticated.md`.

## Links
- Evidence: `docs/testing/acceptance/bdd-copilot-cli-not-authenticated.md`
