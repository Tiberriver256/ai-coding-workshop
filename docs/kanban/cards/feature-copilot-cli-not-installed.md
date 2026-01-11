# feature-copilot-cli-not-installed

## Goal
Implement the BDD scenario "Copilot CLI is not installed" for Copilot CLI support.

## Why
Continue copilot-cli-support scenarios.

## Acceptance Criteria
- Behave scenario `Copilot CLI is not installed` passes in `tests/bdd/copilot-cli-support.feature`.
- Settings show install instructions and Copilot CLI remains disabled when not installed.
- Test evidence recorded.

## Owner
Delegate: BDD feature owner (red/green/refactor sub-delegates).

## Status
Done

## What I Changed
- Added the BDD scenario and steps for Copilot CLI not-installed handling.
- Added install guidance messaging in Settings with enablement guardrails.
- Captured Behave evidence in `docs/testing/acceptance/bdd-copilot-cli-not-installed.md`.

## Links
- Evidence: `docs/testing/acceptance/bdd-copilot-cli-not-installed.md`
