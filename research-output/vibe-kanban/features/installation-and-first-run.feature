Feature: Install and launch Vibe Kanban
  As a developer
  I want to launch Vibe Kanban from the terminal
  So that I can access the web UI and start managing tasks

  Scenario: Launching Vibe Kanban opens the web UI
    Given I have Node.js installed
    When I run "npx vibe-kanban" in a terminal
    Then a local URL is printed in the terminal
    And my default browser opens to the Vibe Kanban UI

  Scenario: First-run setup collects basic preferences
    Given I launched Vibe Kanban for the first time
    When the setup dialogs appear
    Then I can choose my default coding agent configuration
    And I can select my preferred editor integration

  Scenario: No projects are available on first run
    Given I have no existing projects configured
    When I open the Projects page
    Then I see an empty state prompting me to create my first project
