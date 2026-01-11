Feature: Link local projects to remote organization projects
  As a user
  I want to link a local project to a remote organization project
  So that I can collaborate and share tasks

  Scenario: Link to an existing remote project
    Given I am signed in and belong to an organization
    And I have a local project
    When I choose to link the project to a remote project
    And I select an organization and a remote project
    Then the local project is linked to the remote project

  Scenario: Create a new remote project while linking
    Given I am signed in and belong to an organization
    And I have a local project
    When I choose to create a new remote project during linking
    And I provide a new remote project name
    Then the remote project is created
    And the local project is linked to it

  Scenario: Unlink a project from a remote project
    Given a local project is linked to a remote project
    When I choose to unlink it
    Then the local project is no longer linked

  Scenario: Linking requires login and an organization
    Given I am signed out or have no organizations
    When I attempt to link a project
    Then I am prompted to log in or create/select an organization

  Scenario: No remote projects exist in the selected organization
    Given I selected an organization with no remote projects
    When I attempt to link to an existing remote project
    Then I am prompted to create a new remote project instead
