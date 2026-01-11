Feature: Workspace management (new UI)
  As a user
  I want to create and manage workspaces
  So that I can organize active and archived task attempts

  Scenario: Create a new workspace from the chat box
    Given I am in the new UI create mode
    And I selected a project and repositories
    When I enter a message and choose an agent profile
    And I send the message
    Then a new workspace is created
    And a task attempt starts with the selected agent

  Scenario: Add repositories before creating a workspace
    Given I am in create mode
    When I browse repositories on disk or create a new repo
    Then the repositories are added to the workspace configuration

  Scenario: Save selected agent as default
    Given I change the agent profile from my current default
    When I enable "Save as default" and create a workspace
    Then my default agent configuration is updated

  Scenario: Select and switch between workspaces
    Given I have multiple active workspaces
    When I select a different workspace from the sidebar
    Then the main panel updates to the selected workspace

  Scenario: Search workspaces by name
    Given I have many workspaces
    When I type in the workspace search field
    Then the sidebar list filters to matching workspaces

  Scenario: Rename, pin, archive, and delete a workspace
    Given a workspace exists
    When I rename the workspace
    Then its name is updated
    When I pin the workspace
    Then it appears as pinned in the list
    When I archive the workspace
    Then it moves to the archived section
    When I delete the workspace
    Then it is removed permanently

  Scenario: Duplicate a workspace
    Given a workspace exists
    When I choose "Duplicate workspace"
    Then a new workspace is created with the same task details

  Scenario: Open workspace in the legacy UI
    Given a workspace exists
    When I choose to open it in the old UI
    Then I am taken to the legacy task view for that workspace

  Scenario: No project selected in create mode
    Given I am in create mode
    And no project exists
    When I try to create a workspace
    Then I see a prompt to create or select a project first
