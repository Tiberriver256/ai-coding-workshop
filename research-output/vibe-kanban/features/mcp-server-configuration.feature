Feature: MCP server configuration for agents
  As a user
  I want to configure MCP servers for my agents
  So that agents have extra tools and context

  Scenario: Install a popular MCP server with one click
    Given I am on Settings > MCP Servers
    When I select a coding agent and install a popular MCP server
    Then the server is added to the agent configuration

  Scenario: Add a custom MCP server
    Given I am editing the MCP server configuration JSON
    When I add a custom MCP server definition and save
    Then the configuration is saved
    And the agent uses the updated MCP servers

  Scenario: Save MCP configuration changes
    Given I changed the MCP configuration
    When I click "Save Settings"
    Then the settings are persisted for future sessions
