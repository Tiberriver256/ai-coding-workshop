# BDD Acceptance Evidence: Autocomplete Task Instructions

## Date
January 11, 2026

## Scenario
- Feature: `tests/bdd/task-orchestration.feature`
- Scenario: Autocomplete task instructions with an AI assistant

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
    Given I am on a project board                    # tests/bdd/steps/task_orchestration_steps.py:254
    When I open the Create Task dialog               # tests/bdd/steps/task_orchestration_steps.py:265
    And I enter a title and description              # tests/bdd/steps/task_orchestration_steps.py:274
    And I choose "Create"                            # tests/bdd/steps/task_orchestration_steps.py:315
    Then the task appears in the To Do column        # tests/bdd/steps/task_orchestration_steps.py:417

  Scenario: Create and start a task attempt immediately            # tests/bdd/task-orchestration.feature:15
    Given I am on a project board                                  # tests/bdd/steps/task_orchestration_steps.py:254
    When I open the Create Task dialog                             # tests/bdd/steps/task_orchestration_steps.py:265
    And I enter a title and description                            # tests/bdd/steps/task_orchestration_steps.py:274
    And I choose "Create & Start"                                  # tests/bdd/steps/task_orchestration_steps.py:331
    Then the task is created                                       # tests/bdd/steps/task_orchestration_steps.py:399
    And a task attempt starts with the default agent configuration # tests/bdd/steps/task_orchestration_steps.py:406

  Scenario: Autocomplete task instructions with an AI assistant  # tests/bdd/task-orchestration.feature:22
    Given I am on a project board                                # tests/bdd/steps/task_orchestration_steps.py:254
    Given I have enabled an AI CLI assistant for task prompts    # tests/bdd/steps/task_orchestration_steps.py:285
    When I request autocomplete in the task description          # tests/bdd/steps/task_orchestration_steps.py:353
    Then I see suggested completions                             # tests/bdd/steps/task_orchestration_steps.py:428
    When I accept a suggestion                                   # tests/bdd/steps/task_orchestration_steps.py:384
    Then the suggestion is inserted into the task description    # tests/bdd/steps/task_orchestration_steps.py:466

  Scenario: Task creation requires a title  # tests/bdd/task-orchestration.feature:29
    Given I am on a project board           # tests/bdd/steps/task_orchestration_steps.py:254
    When I leave the title empty and submit # tests/bdd/steps/task_orchestration_steps.py:299
    Then I see a validation error           # tests/bdd/steps/task_orchestration_steps.py:436
    And the task is not created             # tests/bdd/steps/task_orchestration_steps.py:454

  Scenario: Cancel task creation       # tests/bdd/task-orchestration.feature:34
    Given I am on a project board      # tests/bdd/steps/task_orchestration_steps.py:254
    When I open the Create Task dialog # tests/bdd/steps/task_orchestration_steps.py:265
    And I choose Cancel                # tests/bdd/steps/task_orchestration_steps.py:368
    Then the dialog closes             # tests/bdd/steps/task_orchestration_steps.py:445
    And no task is created             # tests/bdd/steps/task_orchestration_steps.py:461

1 feature passed, 0 failed, 0 skipped
5 scenarios passed, 0 failed, 0 skipped
26 steps passed, 0 failed, 0 skipped
Took 0min 0.021s
```

## Notes
- Steps validate AI assistant toggle, suggestion wiring, and insertion logic across `app/index.html` and `app/app.js`.
