Feature: Task attempts
  As a user
  I want to start and manage task attempts
  So that coding agents can work on my tasks

  Scenario: Start the first attempt for a task
    Given a task has no attempts
    When I click "Start Attempt"
    And I choose an agent profile and variant
    And I select a base branch for the repository
    Then a new task attempt starts
    And the task moves to In Progress

  Scenario: Create a new attempt for a fresh start
    Given a task already has an attempt
    When I choose "Create New Attempt"
    And I select a different agent or base branch
    Then a new attempt starts with a fresh context

  Scenario: Create and start during task creation
    Given I am creating a new task
    When I select "Create & Start"
    Then the task is created
    And an attempt starts using the default agent configuration

  Scenario: Attempt creation requires repository branches
    Given I am creating an attempt
    When I do not select a base branch for each repository
    Then I cannot start the attempt
    And I see a validation error
