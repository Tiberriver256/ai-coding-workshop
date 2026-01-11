# feature-copilot-cli-enable

## Goal
Implement the BDD scenario "Enable Copilot CLI integration (happy path)" for Copilot CLI support.

## Why
Begin copilot-cli-support feature scenarios.

## Acceptance Criteria
- Behave scenario `Enable Copilot CLI integration (happy path)` passes in `tests/bdd/copilot-cli-support.feature`.
- Settings enable Copilot CLI and make it available in assistant selection for task prompt autocomplete.
- Test evidence recorded.

## Owner
Delegate: BDD feature owner (red/green/refactor sub-delegates).

## Status
Done

## What I Changed
- Added the BDD feature and steps for Copilot CLI enablement.
- Implemented the Settings integration card, Copilot enablement state, and assistant provider selection wiring.
- Captured Behave evidence in `docs/testing/acceptance/bdd-copilot-cli-enable.md`.

## Links
- Evidence: `docs/testing/acceptance/bdd-copilot-cli-enable.md`
