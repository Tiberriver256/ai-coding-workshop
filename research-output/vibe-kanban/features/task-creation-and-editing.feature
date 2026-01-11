Feature: Task creation and editing
  As a user
  I want to create and manage tasks
  So that I can describe work for coding agents

  Scenario: Create a task without starting an agent
    Given I am on a project board
    When I open the Create Task dialog
    And I enter a title and description
    And I choose "Create"
    Then the task appears in the To Do column

  Scenario: Create and start a task attempt immediately
    Given I am on a project board
    When I open the Create Task dialog
    And I enter a title and description
    And I choose "Create & Start"
    Then the task is created
    And a task attempt starts with the default agent configuration

  Scenario: Edit a task
    Given a task exists
    When I edit the task title or description
    Then the task details are updated

  Scenario: Duplicate a task
    Given a task exists
    When I choose "Duplicate"
    Then a new task is created with the copied title and description

  Scenario: Delete a task
    Given a task exists
    When I choose "Delete" and confirm
    Then the task is removed from the board

  Scenario: Set a task status manually
    Given I am editing a task
    When I set the status to Cancelled
    Then the task appears in the Cancelled column

  Scenario: Task creation requires a title
    Given I am creating a task
    When I leave the title empty and submit
    Then I see a validation error
    And the task is not created
