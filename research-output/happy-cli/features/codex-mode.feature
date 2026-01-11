Feature: Run Codex mode
  Users can start a Codex session through Happy for remote control and collaboration.

  Scenario: Start Codex mode when authenticated
    Given I am authenticated with Happy
    When I run "happy codex"
    Then a Codex session starts
    And the session is connected to the Happy service

  Scenario: Prompt for authentication before starting Codex
    Given I am not authenticated with Happy
    When I run "happy codex"
    Then Happy starts the authentication flow
    And the Codex session starts after authentication completes
