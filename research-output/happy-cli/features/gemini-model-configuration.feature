Feature: Configure the default Gemini model
  Users can set or view the default Gemini model used by Happy.

  Scenario: Set a supported Gemini model
    Given Happy CLI is installed
    When I run "happy gemini model set gemini-2.5-flash"
    Then the model setting is saved for future sessions
    And I see a confirmation message with the chosen model

  Scenario: Reject an unsupported model name
    Given Happy CLI is installed
    When I run "happy gemini model set gemini-unknown"
    Then I see an error listing the available models

  Scenario: Get the current model from configuration
    Given I have previously set a Gemini model in my config file
    When I run "happy gemini model get"
    Then I see the current model value

  Scenario: Fall back to the environment variable
    Given no Gemini model is set in the config file
    And the GEMINI_MODEL environment variable is set
    When I run "happy gemini model get"
    Then I see the model from GEMINI_MODEL

  Scenario: Fall back to the default model
    Given no Gemini model is set in the config file
    And the GEMINI_MODEL environment variable is not set
    When I run "happy gemini model get"
    Then I see the default model "gemini-2.5-pro"
