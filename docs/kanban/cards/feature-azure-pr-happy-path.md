# feature-azure-pr-happy-path

## Goal
Implement the BDD scenario "Create a pull request on Azure DevOps (happy path)" for Azure Repos support.

## Why
Begin Azure DevOps support scenarios with a successful Create PR flow.

## Acceptance Criteria
- Behave scenario `Create a pull request on Azure DevOps (happy path)` passes in `tests/bdd/azure-devops-support.feature`.
- Azure CLI readiness is enforced and the PR status renders on the task.
- Evidence recorded in the task activity.

## Owner
Delegate: BDD feature owner (red/green/refactor sub-delegates).

## Status
Done

## What I Changed
- Added the Azure DevOps BDD feature and steps to validate Azure CLI readiness and PR creation.
- Implemented Azure CLI readiness checks, provider labeling, and Azure PR creation details in the Create PR flow.
- Captured Behave evidence in `docs/testing/acceptance/bdd-azure-pr-happy-path.md`.

## Links
- Evidence: `docs/testing/acceptance/bdd-azure-pr-happy-path.md`
