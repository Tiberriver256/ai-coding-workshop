# feature-copilot-cli-autocomplete

## Goal
Implement the BDD scenario "Use Copilot CLI to autocomplete a task prompt" for Copilot CLI support.

## Why
Continue copilot-cli-support scenarios.

## Acceptance Criteria
- Behave scenario `Use Copilot CLI to autocomplete a task prompt` passes in `tests/bdd/copilot-cli-support.feature`.
- Copilot suggestions appear in the task modal and can be inserted into the description when Copilot is enabled.
- Test evidence recorded.

## Owner
Delegate: BDD feature owner (red/green/refactor sub-delegates).

## Status
Done

## What I Changed
- Added BDD coverage for Copilot prompt autocomplete in the Copilot CLI feature file and steps.
- Implemented Copilot-specific suggestion templates and request logic in the task modal.
- Captured Behave evidence in `docs/testing/acceptance/bdd-copilot-cli-autocomplete.md`.

## Links
- Evidence: `docs/testing/acceptance/bdd-copilot-cli-autocomplete.md`
