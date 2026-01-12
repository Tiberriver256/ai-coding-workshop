# BDD Acceptance Evidence: Azure DevOps PR Missing CLI

## Date
January 12, 2026

## Scenario
- Feature: `tests/bdd/azure-devops-support.feature`
- Scenario: Azure CLI not configured

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
    Given my project repository is hosted on Azure Repos                   # tests/bdd/steps/azure_devops_steps.py:89
    Given a task attempt has changes                                       # tests/bdd/steps/github_steps.py:164
    And the Azure CLI and DevOps extension are installed and authenticated # tests/bdd/steps/azure_devops_steps.py:100
    When I click "Create PR"                                               # tests/bdd/steps/github_steps.py:185
    Then a pull request is created on Azure DevOps                         # tests/bdd/steps/azure_devops_steps.py:121
    And the task shows the PR status                                       # tests/bdd/steps/github_steps.py:221

  Scenario: Azure CLI not configured                                  # tests/bdd/azure-devops-support.feature:16
    Given my project repository is hosted on Azure Repos              # tests/bdd/steps/azure_devops_steps.py:89
    Given a task attempt has changes                                  # tests/bdd/steps/github_steps.py:164
    And the Azure CLI is not installed or authenticated               # tests/bdd/steps/azure_devops_steps.py:112
    When I attempt to create a PR                                     # tests/bdd/steps/github_steps.py:236
    Then I see instructions to install and authenticate the Azure CLI # tests/bdd/steps/azure_devops_steps.py:130
    And the Azure DevOps PR is not created                            # tests/bdd/steps/azure_devops_steps.py:139

1 feature passed, 0 failed, 0 skipped
2 scenarios passed, 0 failed, 0 skipped
12 steps passed, 0 failed, 0 skipped
Took 0min 0.013s
```

## Notes
- Confirms missing Azure CLI guidance appears and PR creation is blocked.
