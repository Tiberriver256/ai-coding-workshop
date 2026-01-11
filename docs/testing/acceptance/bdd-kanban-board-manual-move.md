# BDD Acceptance Evidence: Kanban Board Manual Move

## Date
January 11, 2026

## Scenario
- Feature: `tests/bdd/kanban-board.feature`
- Scenario: Manually move a task without triggering agent work

## Command
```
source .venv/bin/activate
behave tests/bdd/kanban-board.feature
```

## Result
Pass

## Output
```
USING RUNNER: behave.runner:Runner
Feature: Kanban board for coding tasks # tests/bdd/kanban-board.feature:1
  As a user
  I want a kanban board that reflects coding work
  So that I can track task progress end to end
  Feature: Kanban board for coding tasks  # tests/bdd/kanban-board.feature:1

  Scenario: Tasks appear in status columns                                                # tests/bdd/kanban-board.feature:9
    Given a project has tasks in multiple statuses                                        # tests/bdd/steps/kanban_board_steps.py:163
    When I open the project board                                                         # tests/bdd/steps/kanban_board_steps.py:168
    Then I see tasks grouped into columns such as To Do, In Progress, In Review, and Done # tests/bdd/steps/kanban_board_steps.py:177

  Scenario: Task status updates from agent activity  # tests/bdd/kanban-board.feature:13
    Given a project has tasks in multiple statuses   # tests/bdd/steps/kanban_board_steps.py:163
    Given a task is in the To Do column              # tests/bdd/steps/kanban_board_steps.py:186
    When a task attempt starts                       # tests/bdd/steps/kanban_board_steps.py:215
    Then the task moves to In Progress               # tests/bdd/steps/kanban_board_steps.py:233
    When the attempt completes                       # tests/bdd/steps/kanban_board_steps.py:240
    Then the task moves to In Review                 # tests/bdd/steps/kanban_board_steps.py:258
    When the task is merged                          # tests/bdd/steps/kanban_board_steps.py:265
    Then the task moves to Done                      # tests/bdd/steps/kanban_board_steps.py:283

  Scenario: Manually move a task without triggering agent work  # tests/bdd/kanban-board.feature:22
    Given a project has tasks in multiple statuses              # tests/bdd/steps/kanban_board_steps.py:163
    Given I am viewing the kanban board                         # tests/bdd/steps/kanban_board_steps.py:290
    When I drag a task to another column                        # tests/bdd/steps/kanban_board_steps.py:306
    Then the task appears in the target column                  # tests/bdd/steps/kanban_board_steps.py:322
    And no agent action is triggered solely by the drag         # tests/bdd/steps/kanban_board_steps.py:330

1 feature passed, 0 failed, 0 skipped
3 scenarios passed, 0 failed, 0 skipped
16 steps passed, 0 failed, 0 skipped
Took 0min 0.021s
```

## Notes
- Manual drag-and-drop updates task status without recording agent activity.
