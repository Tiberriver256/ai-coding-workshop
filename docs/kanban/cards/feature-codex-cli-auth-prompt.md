# feature-codex-cli-auth-prompt

## Goal
Implement the BDD scenario "Prompt for authentication before starting Codex" for codex-cli-support.

## Why
Continue codex-cli-support feature scenario coverage.

## Acceptance Criteria
- Behave scenario passes in `tests/bdd/codex-cli-support.feature`.
- Unified CLI prompts for authentication when unauthenticated and starts Codex after auth completes.
- Acceptance evidence captured.

## Owner
Delegate: BDD feature owner (red/green/refactor sub-delegates).

## Status
Done

## What I Changed
- Added BDD scenario + steps for unauthenticated Codex auth prompt flow.
- Updated unified CLI to start auth flow, simulate completion, then start the Codex session.
- Captured Behave run evidence in `docs/testing/acceptance/bdd-codex-cli-auth-prompt.md`.

## Links
- Evidence: `docs/testing/acceptance/bdd-codex-cli-auth-prompt.md`
