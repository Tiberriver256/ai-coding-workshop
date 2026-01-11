# BDD Acceptance Evidence: Kanban Board Search

## Date
January 11, 2026

## Scenario
- Feature: `tests/bdd/kanban-board.feature`
- Scenario: Search tasks on the board

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
    Given a project has tasks in multiple statuses                                        # tests/bdd/steps/kanban_board_steps.py:182
    When I open the project board                                                         # tests/bdd/steps/kanban_board_steps.py:187
    Then I see tasks grouped into columns such as To Do, In Progress, In Review, and Done # tests/bdd/steps/kanban_board_steps.py:196

  Scenario: Task status updates from agent activity  # tests/bdd/kanban-board.feature:13
    Given a project has tasks in multiple statuses   # tests/bdd/steps/kanban_board_steps.py:182
    Given a task is in the To Do column              # tests/bdd/steps/kanban_board_steps.py:205
    When a task attempt starts                       # tests/bdd/steps/kanban_board_steps.py:234
    Then the task moves to In Progress               # tests/bdd/steps/kanban_board_steps.py:252
    When the attempt completes                       # tests/bdd/steps/kanban_board_steps.py:259
    Then the task moves to In Review                 # tests/bdd/steps/kanban_board_steps.py:277
    When the task is merged                          # tests/bdd/steps/kanban_board_steps.py:284
    Then the task moves to Done                      # tests/bdd/steps/kanban_board_steps.py:302

  Scenario: Manually move a task without triggering agent work  # tests/bdd/kanban-board.feature:22
    Given a project has tasks in multiple statuses              # tests/bdd/steps/kanban_board_steps.py:182
    Given I am viewing the kanban board                         # tests/bdd/steps/kanban_board_steps.py:309
    When I drag a task to another column                        # tests/bdd/steps/kanban_board_steps.py:325
    Then the task appears in the target column                  # tests/bdd/steps/kanban_board_steps.py:341
    And no agent action is triggered solely by the drag         # tests/bdd/steps/kanban_board_steps.py:349

  Scenario: Search tasks on the board              # tests/bdd/kanban-board.feature:28
    Given a project has tasks in multiple statuses # tests/bdd/steps/kanban_board_steps.py:182
    Given there are many tasks on the board        # tests/bdd/steps/kanban_board_steps.py:360
    When I enter text into the search field        # tests/bdd/steps/kanban_board_steps.py:368
    Then only tasks matching the search are shown  # tests/bdd/steps/kanban_board_steps.py:382

1 feature passed, 0 failed, 0 skipped
4 scenarios passed, 0 failed, 0 skipped
20 steps passed, 0 failed, 0 skipped
Took 0min 0.035s
```

## Notes
- Search input filters tasks by title or description and re-renders the board.
