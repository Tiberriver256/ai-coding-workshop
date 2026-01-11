Feature: Subtasks and task relationships
  As a user
  I want to create subtasks and view relationships
  So that I can break down and track complex work

  Scenario: Create a subtask from a task attempt
    Given I am viewing a task attempt
    When I choose "Create Subtask"
    And I enter a subtask title and description
    Then a new task is created as a subtask
    And it appears on the kanban board

  Scenario: Subtasks inherit the parent attempt branch
    Given I create a subtask from a task attempt
    Then the subtask uses the parent attempt's base branch by default

  Scenario: View child tasks from a parent task
    Given a task has subtasks
    When I open the parent task
    Then I can see a Task Relationships panel listing child tasks
    And I can navigate to a child task from the list

  Scenario: View parent task from a subtask
    Given I open a subtask
    Then I see its parent task in the Task Relationships panel
    And I can navigate back to the parent

  Scenario: View related tasks from a task attempt
    Given I am viewing a task attempt
    When I open \"Related tasks\"
    Then I see a list of parent and child tasks connected to the attempt

  Scenario: Subtasks are linked to attempts, not just tasks
    Given I create a new attempt for a task
    When I view existing subtasks
    Then they remain linked to the original attempt
    And new subtasks use the new attempt's branch
