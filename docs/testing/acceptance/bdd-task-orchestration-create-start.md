# BDD Acceptance Evidence: Create and Start Task Attempt

## Date
January 11, 2026

## Scenario
- Feature: `tests/bdd/task-orchestration.feature`
- Scenario: Create and start a task attempt immediately

## Command
```
source .venv/bin/activate
behave tests/bdd/task-orchestration.feature
```

## Result
Pass

## Output
```
USING RUNNER: behave.runner:Runner
Feature: Task orchestration # tests/bdd/task-orchestration.feature:1
  As a user
  I want to create tasks without starting an agent
  So that I can queue work for later
  Feature: Task orchestration  # tests/bdd/task-orchestration.feature:1

  Scenario: Create a task without starting an agent  # tests/bdd/task-orchestration.feature:9
    Given I am on a project board                    # tests/bdd/steps/task_orchestration_steps.py:118
    When I open the Create Task dialog               # tests/bdd/steps/task_orchestration_steps.py:128
    And I enter a title and description              # tests/bdd/steps/task_orchestration_steps.py:136
    And I choose "Create"                            # tests/bdd/steps/task_orchestration_steps.py:147
    Then the task appears in the To Do column        # tests/bdd/steps/task_orchestration_steps.py:203

  Scenario: Create and start a task attempt immediately            # tests/bdd/task-orchestration.feature:15
    Given I am on a project board                                  # tests/bdd/steps/task_orchestration_steps.py:118
    When I open the Create Task dialog                             # tests/bdd/steps/task_orchestration_steps.py:128
    And I enter a title and description                            # tests/bdd/steps/task_orchestration_steps.py:136
    And I choose "Create & Start"                                  # tests/bdd/steps/task_orchestration_steps.py:163
    Then the task is created                                       # tests/bdd/steps/task_orchestration_steps.py:185
    And a task attempt starts with the default agent configuration # tests/bdd/steps/task_orchestration_steps.py:192

1 feature passed, 0 failed, 0 skipped
2 scenarios passed, 0 failed, 0 skipped
11 steps passed, 0 failed, 0 skipped
Took 0min 0.011s
```

## Notes
- Steps confirm the Create & Start submit path wires to the default agent configuration in `app/app.js`.
- UI evidence includes the Create & Start button in `app/index.html` and attempt metadata rendering in `app/app.js`.
