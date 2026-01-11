Feature: Vibe Kanban MCP server for external clients
  As a user of an MCP client
  I want to manage Vibe Kanban projects and tasks programmatically
  So that I can automate planning and execution

  Scenario: List projects via MCP
    Given the Vibe Kanban MCP server is running locally
    When my MCP client calls "list_projects"
    Then I receive a list of available projects

  Scenario: Create and start a task via MCP
    Given the MCP server is running
    When my MCP client calls "create_task" with a project, title, and description
    And I call "start_task_attempt" with an executor and base branch
    Then the task is created and a task attempt starts

  Scenario: Update or delete a task via MCP
    Given a task exists
    When my MCP client calls "update_task" or "delete_task"
    Then the task is updated or removed accordingly

  Scenario: MCP server is local-only
    Given the MCP server runs locally
    When a remote client attempts to access it
    Then the connection is rejected or unavailable
