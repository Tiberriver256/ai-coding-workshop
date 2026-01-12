# BDD Acceptance Evidence: GitHub PR Missing Base Branch

## Date
January 12, 2026

## Scenario
- Feature: `tests/bdd/github-support.feature`
- Scenario: Target branch does not exist on remote

## Command
```
source .venv/bin/activate
behave tests/bdd/github-support.feature
```

## Result
Pass

## Output
```
USING RUNNER: behave.runner:Runner
Feature: GitHub support for pull requests # tests/bdd/github-support.feature:1
  As a user
  I want to create pull requests on GitHub
  So that I can merge agent changes through my normal workflow
  Feature: GitHub support for pull requests  # tests/bdd/github-support.feature:1

  Scenario: Create a pull request from a task attempt (happy path)  # tests/bdd/github-support.feature:9
    Given my project repository is hosted on GitHub                 # tests/bdd/steps/github_steps.py:159
    Given a task attempt has changes                                # tests/bdd/steps/github_steps.py:164
    And the GitHub CLI is installed and authenticated               # tests/bdd/steps/github_steps.py:175
    When I click "Create PR"                                        # tests/bdd/steps/github_steps.py:185
    Then the PR title and description are prefilled from the task   # tests/bdd/steps/github_steps.py:195
    And I can select a base branch                                  # tests/bdd/steps/github_steps.py:204
    And a pull request is created on GitHub                         # tests/bdd/steps/github_steps.py:212
    And the task shows the PR status                                # tests/bdd/steps/github_steps.py:221

  Scenario: Missing GitHub CLI authentication prevents PR creation     # tests/bdd/github-support.feature:18
    Given my project repository is hosted on GitHub                    # tests/bdd/steps/github_steps.py:159
    Given a task attempt has changes                                   # tests/bdd/steps/github_steps.py:164
    And the GitHub CLI is not installed or authenticated               # tests/bdd/steps/github_steps.py:228
    When I attempt to create a PR                                      # tests/bdd/steps/github_steps.py:236
    Then I see instructions to install and authenticate the GitHub CLI # tests/bdd/steps/github_steps.py:246
    And the PR is not created                                          # tests/bdd/steps/github_steps.py:255

  Scenario: Target branch does not exist on remote              # tests/bdd/github-support.feature:25
    Given my project repository is hosted on GitHub             # tests/bdd/steps/github_steps.py:159
    Given a task attempt has changes                            # tests/bdd/steps/github_steps.py:164
    And the GitHub CLI is installed and authenticated           # tests/bdd/steps/github_steps.py:175
    And I selected a base branch that does not exist on GitHub  # tests/bdd/steps/github_steps.py:261
    When I attempt to create a PR                               # tests/bdd/steps/github_steps.py:236
    Then I see an error indicating the target branch is missing # tests/bdd/steps/github_steps.py:269

1 feature passed, 0 failed, 0 skipped
3 scenarios passed, 0 failed, 0 skipped
20 steps passed, 0 failed, 0 skipped
Took 0min 0.030s
```

## Notes
- Confirms missing base branch selections show an error and block PR creation.
