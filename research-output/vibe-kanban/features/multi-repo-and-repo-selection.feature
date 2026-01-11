Feature: Multi-repo selection and repository targeting
  As a user
  I want to work across multiple repositories in a project
  So that agents and git actions target the correct repo

  Scenario: Select multiple repositories for an attempt
    Given a project has multiple repositories
    When I create or start a task attempt
    And I select target branches for each repository
    Then the attempt is created with all selected repositories

  Scenario: Choose which repository to act on
    Given an attempt includes multiple repositories
    When I open git actions
    Then I can select which repository to view and operate on

  Scenario: Add a repository to an existing attempt
    Given an attempt is running with one repository
    When I add another repository to the attempt
    Then the new repository is included in future operations

  Scenario: No repositories available
    Given a project has no repositories configured
    When I try to start an attempt
    Then I am prompted to add at least one repository first
