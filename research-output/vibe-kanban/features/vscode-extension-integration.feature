Feature: IDE extension integration
  As a user
  I want the Vibe Kanban IDE extension
  So that I can manage tasks and reviews inside my editor

  Scenario: Open a task in the IDE with the extension
    Given I have installed the Vibe Kanban extension
    And I open a task from Vibe Kanban using "Open in IDE"
    Then the IDE shows task context, logs, diffs, and processes

  Scenario: Extension UI is empty outside a worktree
    Given the IDE is not opened in a Vibe Kanban worktree
    When I open the extension
    Then I see an empty state indicating no task context is available
