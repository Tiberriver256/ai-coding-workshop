# BDD Acceptance Evidence: Kanban Board Columns

## Date
January 11, 2026

## Scenario
- Feature: `tests/bdd/kanban-board.feature`
- Scenario: Tasks appear in status columns

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
  Scenario: Tasks appear in status columns                                                # tests/bdd/kanban-board.feature:9
    Given a project has tasks in multiple statuses                                        # tests/bdd/steps/kanban_board_steps.py:34
    When I open the project board                                                         # tests/bdd/steps/kanban_board_steps.py:39
    Then I see tasks grouped into columns such as To Do, In Progress, In Review, and Done # tests/bdd/steps/kanban_board_steps.py:50

1 feature passed, 0 failed, 0 skipped
1 scenario passed, 0 failed, 0 skipped
3 steps passed, 0 failed, 0 skipped
```

## Notes
- Steps validate the column headings rendered in `app/index.html`.
