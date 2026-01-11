# feature-codex-cli-authenticated

## Goal
Implement the BDD scenario "Start Codex mode when authenticated" for codex-cli-support.

## Why
Begin codex-cli-support feature scenario coverage.

## Acceptance Criteria
- Behave scenario passes in `tests/bdd/codex-cli-support.feature`.
- Unified CLI starts a Codex session when authenticated and shows the connected message.
- Acceptance evidence captured.

## Owner
Delegate: BDD feature owner (red/green/refactor sub-delegates).

## Status
Done

## What I Changed
- Added codex-cli-support BDD feature + steps for authenticated Codex start behavior.
- Implemented unified `codex` command with authentication guard and connected messaging.
- Captured Behave run evidence in `docs/testing/acceptance/bdd-codex-cli-authenticated.md`.

## Links
- Evidence: `docs/testing/acceptance/bdd-codex-cli-authenticated.md`
