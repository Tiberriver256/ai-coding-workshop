# feature-azure-pr-unsupported-repo

## Goal
Implement the BDD scenario "Repository is not an Azure Repos project" for Azure DevOps support.

## Why
Finish Azure DevOps support scenarios.

## Acceptance Criteria
- Behave scenario "Repository is not an Azure Repos project" passes in `tests/bdd/azure-devops-support.feature`.
- Unsupported repo message shows and Azure DevOps PR creation is blocked.
- Evidence recorded in `docs/testing/acceptance/bdd-azure-pr-unsupported-repo.md`.

## Owner
Delegate: BDD feature owner (red/green/refactor sub-delegates).

## Status
Done

## What I Changed
- Added the unsupported repo scenario to the Azure DevOps BDD feature and steps.
- Added Azure Repos unsupported messaging and PR guardrails in the PR modal flow.
- Captured Behave evidence in `docs/testing/acceptance/bdd-azure-pr-unsupported-repo.md`.

## Links
- Evidence: `docs/testing/acceptance/bdd-azure-pr-unsupported-repo.md`
