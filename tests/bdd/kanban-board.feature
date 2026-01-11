Feature: Kanban board for coding tasks
  As a user
  I want a kanban board that reflects coding work
  So that I can track task progress end to end

  Background:
    Given a project has tasks in multiple statuses

  Scenario: Tasks appear in status columns
    When I open the project board
    Then I see tasks grouped into columns such as To Do, In Progress, In Review, and Done

  Scenario: Task status updates from agent activity
    Given a task is in the To Do column
    When a task attempt starts
    Then the task moves to In Progress
    When the attempt completes
    Then the task moves to In Review
    When the task is merged
    Then the task moves to Done

  Scenario: Manually move a task without triggering agent work
    Given I am viewing the kanban board
    When I drag a task to another column
    Then the task appears in the target column
    And no agent action is triggered solely by the drag

  Scenario: Search tasks on the board
    Given there are many tasks on the board
    When I enter text into the search field
    Then only tasks matching the search are shown
