# BDD Acceptance Evidence: GitHub PR Happy Path

## Date
January 11, 2026

## Scenario
- Feature: `tests/bdd/github-support.feature`
- Scenario: Create a pull request from a task attempt (happy path)

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
    Given my project repository is hosted on GitHub                 # tests/bdd/steps/github_steps.py:115
    Given a task attempt has changes                                # tests/bdd/steps/github_steps.py:120
    And the GitHub CLI is installed and authenticated               # tests/bdd/steps/github_steps.py:131
    When I click "Create PR"                                        # tests/bdd/steps/github_steps.py:141
    Then the PR title and description are prefilled from the task   # tests/bdd/steps/github_steps.py:151
    And I can select a base branch                                  # tests/bdd/steps/github_steps.py:160
    And a pull request is created on GitHub                         # tests/bdd/steps/github_steps.py:168
    And the task shows the PR status                                # tests/bdd/steps/github_steps.py:177

1 feature passed, 0 failed, 0 skipped
1 scenario passed, 0 failed, 0 skipped
8 steps passed, 0 failed, 0 skipped
Took 0min 0.012s
```

## Notes
- Validates the Create PR modal wiring, GitHub-ready settings, and PR status rendering.
