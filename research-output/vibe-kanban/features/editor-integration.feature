Feature: Editor integration
  As a user
  I want to open projects and task worktrees in my editor
  So that I can work locally with full context

  Scenario: Choose an editor type
    Given I am on the Settings page
    When I select an editor type (e.g., VS Code, Cursor, Windsurf, or Custom)
    Then Vibe Kanban saves the editor preference

  Scenario: Open a project in the editor
    Given I have a project
    When I click "Open in IDE" on the project
    Then my editor opens the project directory

  Scenario: Open a task worktree in the editor
    Given I have a task attempt
    When I click "Open in IDE" from the task
    Then my editor opens the worktree for that attempt

  Scenario: Configure Remote SSH for hosted deployments
    Given Vibe Kanban is running on a remote server
    When I configure Remote SSH Host and User
    Then "Open in IDE" opens the project via remote SSH

  Scenario: Editor not found
    Given I selected a local editor command
    When the editor command is not available on my system
    Then I see a warning that the editor is not found
