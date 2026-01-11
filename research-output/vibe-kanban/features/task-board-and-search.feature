Feature: Task board, search, and filters
  As a user
  I want a kanban board with search and filters
  So that I can track task progress

  Scenario: Tasks appear in status columns
    Given a project has tasks in multiple statuses
    When I open the project board
    Then I see tasks grouped into columns such as To Do, In Progress, In Review, Done, and Cancelled

  Scenario: Task status updates from agent activity
    Given a task is in the To Do column
    When a task attempt starts
    Then the task moves to In Progress
    When the attempt completes
    Then the task moves to In Review
    When the task is merged
    Then the task moves to Done

  Scenario: Manually drag a task between columns
    Given I am viewing the kanban board
    When I drag a task to another column
    Then the task appears in the target column
    And no coding agent action is triggered solely by the drag

  Scenario: Search tasks on the board
    Given there are many tasks on the board
    When I enter text into the search field
    Then only tasks matching the search are shown

  Scenario: Toggle shared tasks visibility
    Given shared tasks are available
    When I toggle the shared tasks filter
    Then shared tasks are shown or hidden accordingly

  Scenario: Sort and group tasks
    Given I am viewing the task list
    When I select a sort order or grouping option
    Then tasks are reorganized based on the selected criteria
