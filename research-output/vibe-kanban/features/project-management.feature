Feature: Project management
  As a user
  I want to create and manage projects
  So that I can organize tasks by repository

  Scenario: Create a project from an existing repository
    Given I am on the Projects page
    When I create a project from an existing git repository
    Then the project is added to my project list
    And the project opens to its kanban board

  Scenario: Create a blank project
    Given I am on the Projects page
    When I choose to create a blank project
    Then a new git repository is created
    And the project appears in my project list

  Scenario: Open a project
    Given I have an existing project
    When I select the project
    Then I see the project's task board and details

  Scenario: Delete a project
    Given I have an existing project
    When I delete the project
    Then the project is removed from the project list

  Scenario: Repository discovery takes a long time
    Given I am creating a project from an existing repository
    When automatic discovery takes longer than usual
    Then I am offered a manual browse option to pick a repository
