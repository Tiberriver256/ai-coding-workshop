# BDD Acceptance Evidence: Azure DevOps PR Happy Path

## Date
January 12, 2026

## Scenario
- Feature: `tests/bdd/azure-devops-support.feature`
- Scenario: Create a pull request on Azure DevOps (happy path)

## Command
```
source .venv/bin/activate
behave tests/bdd/azure-devops-support.feature
```

## Result
Pass

## Output
```
USING RUNNER: behave.runner:Runner
Feature: Azure DevOps support for pull requests # tests/bdd/azure-devops-support.feature:1
  As a user
  I want to create pull requests on Azure DevOps
  So that I can use the product with Azure Repos
  Feature: Azure DevOps support for pull requests  # tests/bdd/azure-devops-support.feature:1

  Scenario: Create a pull request on Azure DevOps (happy path)             # tests/bdd/azure-devops-support.feature:9
    Given my project repository is hosted on Azure Repos                   # tests/bdd/steps/azure_devops_steps.py:81
    Given a task attempt has changes                                       # tests/bdd/steps/github_steps.py:164
    And the Azure CLI and DevOps extension are installed and authenticated # tests/bdd/steps/azure_devops_steps.py:92
    When I click "Create PR"                                               # tests/bdd/steps/github_steps.py:185
    Then a pull request is created on Azure DevOps                         # tests/bdd/steps/azure_devops_steps.py:104
    And the task shows the PR status                                       # tests/bdd/steps/github_steps.py:221

1 feature passed, 0 failed, 0 skipped
1 scenario passed, 0 failed, 0 skipped
6 steps passed, 0 failed, 0 skipped
Took 0min 0.011s
```

## Notes
- Confirms Azure CLI readiness checks, PR creation path, and PR status rendering.
