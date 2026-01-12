Feature: Create and orchestrate coding tasks
  As a user
  I want to create tasks and start agent work from the board
  So that I can orchestrate coding work efficiently

  Background:
    Given I am on a project board

  Scenario: Create a task without starting an agent
    When I open the Create Task dialog
    And I enter a title and description
    And I choose "Create"
    Then the task appears in the To Do column

  Scenario: Create and start a task attempt immediately
    When I open the Create Task dialog
    And I enter a title and description
    And I choose "Create & Start"
    Then the task is created
    And a task attempt starts with the default agent configuration

  Scenario: Autocomplete task instructions with an AI assistant
    Given I have enabled an AI CLI assistant for task prompts
    When I request autocomplete in the task description
    Then I see suggested completions
    When I accept a suggestion
    Then the suggestion is inserted into the task description

  Scenario: Task creation requires a title
    When I leave the title empty and submit
    Then I see a validation error
    And the task is not created

  Scenario: Cancel task creation
    When I open the Create Task dialog
    And I choose Cancel
    Then the dialog closes
    And no task is created
