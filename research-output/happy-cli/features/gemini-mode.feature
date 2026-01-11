Feature: Run Gemini mode
  Users can start a Gemini session through Happy for remote control.

  Scenario: Start Gemini mode when authenticated
    Given I am authenticated with Happy
    When I run "happy gemini"
    Then a Gemini session starts
    And the session is connected to the Happy service

  Scenario: Prompt for authentication before starting Gemini
    Given I am not authenticated with Happy
    When I run "happy gemini"
    Then Happy starts the authentication flow
    And the Gemini session starts after authentication completes
