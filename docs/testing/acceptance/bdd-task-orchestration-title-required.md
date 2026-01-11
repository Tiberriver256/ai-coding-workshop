# BDD Acceptance Evidence: Task Creation Requires a Title

## Date
January 11, 2026

## Scenario
- Feature: `tests/bdd/task-orchestration.feature`
- Scenario: Task creation requires a title

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
    Given I am on a project board                    # tests/bdd/steps/task_orchestration_steps.py:147
    When I open the Create Task dialog               # tests/bdd/steps/task_orchestration_steps.py:157
    And I enter a title and description              # tests/bdd/steps/task_orchestration_steps.py:165
    And I choose "Create"                            # tests/bdd/steps/task_orchestration_steps.py:192
    Then the task appears in the To Do column        # tests/bdd/steps/task_orchestration_steps.py:248

  Scenario: Create and start a task attempt immediately            # tests/bdd/task-orchestration.feature:15
    Given I am on a project board                                  # tests/bdd/steps/task_orchestration_steps.py:147
    When I open the Create Task dialog                             # tests/bdd/steps/task_orchestration_steps.py:157
    And I enter a title and description                            # tests/bdd/steps/task_orchestration_steps.py:165
    And I choose "Create & Start"                                  # tests/bdd/steps/task_orchestration_steps.py:208
    Then the task is created                                       # tests/bdd/steps/task_orchestration_steps.py:230
    And a task attempt starts with the default agent configuration # tests/bdd/steps/task_orchestration_steps.py:237

  Scenario: Task creation requires a title  # tests/bdd/task-orchestration.feature:22
    Given I am on a project board           # tests/bdd/steps/task_orchestration_steps.py:147
    When I leave the title empty and submit # tests/bdd/steps/task_orchestration_steps.py:176
    Then I see a validation error           # tests/bdd/steps/task_orchestration_steps.py:259
    And the task is not created             # tests/bdd/steps/task_orchestration_steps.py:268

1 feature passed, 0 failed, 0 skipped
3 scenarios passed, 0 failed, 0 skipped
15 steps passed, 0 failed, 0 skipped
Took 0min 0.011s
```

## Notes
- Validation checks confirm the title error message is configured and the submit handler guards task creation.
