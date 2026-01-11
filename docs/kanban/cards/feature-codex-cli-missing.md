# feature-codex-cli-missing

## Goal
Implement the BDD scenario "Codex CLI is not installed locally" for codex-cli-support.

## Why
Finish codex-cli-support scenario coverage for missing local Codex CLI handling.

## Acceptance Criteria
- Behave scenario passes in `tests/bdd/codex-cli-support.feature`.
- Unified CLI reports missing Codex CLI and does not start a session.
- Acceptance evidence captured.

## Owner
Delegate: BDD feature owner (red/green/refactor sub-delegates).

## Status
Done

## What I Changed
- Added missing Codex CLI scenario to BDD feature + steps.
- Implemented Codex CLI discovery guard in `bin/unified`.
- Captured Behave run evidence in `docs/testing/acceptance/bdd-codex-cli-missing.md`.

## Links
- Evidence: `docs/testing/acceptance/bdd-codex-cli-missing.md`
