# feature-azure-pr-missing-cli

## Goal
Implement the BDD scenario "Azure CLI not configured" for Azure DevOps support.

## Why
Continue Azure DevOps support scenarios.

## Acceptance Criteria
- Behave scenario "Azure CLI not configured" passes in `tests/bdd/azure-devops-support.feature`.
- Missing Azure CLI shows instructions and blocks PR creation.
- Evidence recorded in `docs/testing/acceptance/bdd-azure-pr-missing-cli.md`.

## Owner
Delegate: BDD feature owner (red/green/refactor sub-delegates).

## Status
Done

## What I Changed
- Added the Azure CLI not configured scenario to the Azure DevOps BDD feature and steps.
- Strengthened Azure CLI instruction checks and PR creation guardrails.
- Captured Behave evidence in `docs/testing/acceptance/bdd-azure-pr-missing-cli.md`.

## Links
- Evidence: `docs/testing/acceptance/bdd-azure-pr-missing-cli.md`
