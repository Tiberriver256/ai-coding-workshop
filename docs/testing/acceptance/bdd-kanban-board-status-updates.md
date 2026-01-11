# BDD Acceptance Evidence: Kanban Board Status Updates

## Date
January 11, 2026

## Scenario
- Feature: `tests/bdd/kanban-board.feature`
- Scenario: Task status updates from agent activity

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
    Given a project has tasks in multiple statuses                                        # tests/bdd/steps/kanban_board_steps.py:134
    When I open the project board                                                         # tests/bdd/steps/kanban_board_steps.py:139
    Then I see tasks grouped into columns such as To Do, In Progress, In Review, and Done # tests/bdd/steps/kanban_board_steps.py:148

  Scenario: Task status updates from agent activity  # tests/bdd/kanban-board.feature:13
    Given a project has tasks in multiple statuses   # tests/bdd/steps/kanban_board_steps.py:134
    Given a task is in the To Do column              # tests/bdd/steps/kanban_board_steps.py:157
    When a task attempt starts                       # tests/bdd/steps/kanban_board_steps.py:186
    Then the task moves to In Progress               # tests/bdd/steps/kanban_board_steps.py:204
    When the attempt completes                       # tests/bdd/steps/kanban_board_steps.py:211
    Then the task moves to In Review                 # tests/bdd/steps/kanban_board_steps.py:229
    When the task is merged                          # tests/bdd/steps/kanban_board_steps.py:236
    Then the task moves to Done                      # tests/bdd/steps/kanban_board_steps.py:254

1 feature passed, 0 failed, 0 skipped
2 scenarios passed, 0 failed, 0 skipped
11 steps passed, 0 failed, 0 skipped
Took 0min 0.020s
```

## Notes
- The scenario validates agent activity controls, status transitions, and evidence logging hooks in the UI logic.
