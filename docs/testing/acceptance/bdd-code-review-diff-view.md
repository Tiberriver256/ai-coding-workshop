# BDD Acceptance Evidence: Code Review Diff View

## Date
January 12, 2026

## Scenario
- Feature: `tests/bdd/code-review.feature`
- Scenario: Open the diff view

## Command
```
source .venv/bin/activate
behave tests/bdd/code-review.feature
```

## Result
Pass

## Output
```
USING RUNNER: behave.runner:Runner
Feature: Code review diff view # tests/bdd/code-review.feature:1
  As a user
  I want to inspect file changes in a diff view
  So that I can review agent work before merging
  Feature: Code review diff view  # tests/bdd/code-review.feature:1

  Scenario: Open the diff view                     # tests/bdd/code-review.feature:9
    Given a task is in the In Review column        # tests/bdd/steps/code_review_steps.py:75
    When I open the task and select the diff view  # tests/bdd/steps/code_review_steps.py:86
    Then I see the list of files changed           # tests/bdd/steps/code_review_steps.py:99
    And I can switch between inline and split view # tests/bdd/steps/code_review_steps.py:108

1 feature passed, 0 failed, 0 skipped
1 scenario passed, 0 failed, 0 skipped
4 steps passed, 0 failed, 0 skipped
Took 0min 0.005s
```

## Notes
- Confirms the review modal, diff file list rendering, and inline/split toggles are wired.
