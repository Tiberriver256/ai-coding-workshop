# BDD Acceptance Evidence: GitHub PR Missing Auth

## Date
January 11, 2026

## Scenario
- Feature: `tests/bdd/github-support.feature`
- Scenario: Missing GitHub CLI authentication prevents PR creation

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
    Given my project repository is hosted on GitHub                 # tests/bdd/steps/github_steps.py:137
    Given a task attempt has changes                                # tests/bdd/steps/github_steps.py:142
    And the GitHub CLI is installed and authenticated               # tests/bdd/steps/github_steps.py:153
    When I click "Create PR"                                        # tests/bdd/steps/github_steps.py:163
    Then the PR title and description are prefilled from the task   # tests/bdd/steps/github_steps.py:173
    And I can select a base branch                                  # tests/bdd/steps/github_steps.py:182
    And a pull request is created on GitHub                         # tests/bdd/steps/github_steps.py:190
    And the task shows the PR status                                # tests/bdd/steps/github_steps.py:199

  Scenario: Missing GitHub CLI authentication prevents PR creation     # tests/bdd/github-support.feature:18
    Given my project repository is hosted on GitHub                    # tests/bdd/steps/github_steps.py:137
    Given a task attempt has changes                                   # tests/bdd/steps/github_steps.py:142
    And the GitHub CLI is not installed or authenticated               # tests/bdd/steps/github_steps.py:206
    When I attempt to create a PR                                      # tests/bdd/steps/github_steps.py:214
    Then I see instructions to install and authenticate the GitHub CLI # tests/bdd/steps/github_steps.py:225
    And the PR is not created                                          # tests/bdd/steps/github_steps.py:233

1 feature passed, 0 failed, 0 skipped
2 scenarios passed, 0 failed, 0 skipped
14 steps passed, 0 failed, 0 skipped
Took 0min 0.022s
```

## Notes
- Verifies missing GitHub CLI guidance appears and PR creation is blocked.
