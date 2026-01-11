Feature: GitHub CLI setup
  As a user
  I want guided GitHub CLI setup
  So that I can create pull requests from Vibe Kanban

  Scenario: Run GitHub CLI setup on macOS
    Given I am on the Settings page
    And I am using macOS
    When I run GitHub CLI setup
    Then Vibe Kanban checks for the CLI
    And installs it via Homebrew if needed
    And guides me through authentication

  Scenario: Manual setup on unsupported platforms
    Given I am on Windows or Linux
    When I open GitHub CLI setup
    Then I see manual installation and authentication instructions

  Scenario: Setup fails
    Given I start GitHub CLI setup
    When the setup fails
    Then I see an error message and guidance to retry
