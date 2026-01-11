Feature: Sharing tasks with an organization
  As a team member
  I want to share tasks with my organization
  So that teammates can see and pick up work

  Scenario: Share a task with the organization
    Given I am signed in
    And the project is linked to an organization
    When I choose "Share" on a task
    And I confirm sharing
    Then the task is published to the shared workspace

  Scenario: Sharing requires sign-in
    Given I am signed out
    When I try to share a task
    Then I am prompted to sign in first

  Scenario: Sharing requires a linked project and git provider
    Given I am signed in
    And the project is not linked to an organization or git provider
    When I try to share a task
    Then I see a prompt to connect a git provider or link the project

  Scenario: Stop sharing a task
    Given a task is shared
    When I choose "Stop share"
    Then the task is removed from the shared workspace
    And the local task remains

  Scenario: Reassign a shared task
    Given I am the current assignee of a shared task
    When I reassign the task to another organization member
    Then the new assignee is updated

  Scenario: Only the current assignee can reassign
    Given I am not the current assignee
    When I attempt to reassign a shared task
    Then I see an error stating I cannot reassign it

  Scenario: Show or hide shared tasks on the board
    Given shared tasks exist
    When I toggle the shared tasks filter
    Then shared tasks are shown or hidden accordingly
