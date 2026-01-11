Feature: Configure a custom server
  As an advanced user
  I want to set a custom server URL
  So that I can connect to my own backend

  Scenario: Save a valid custom server URL
    Given I am on Server Configuration
    When I enter a valid Happy server URL
    And I confirm the change
    Then the server URL is saved
    And the app uses the custom server

  Scenario: Invalid server URL format
    Given I am on Server Configuration
    When I enter an invalid URL
    Then I see a validation error
    And the server URL is not saved

  Scenario: Server validation fails
    Given I am on Server Configuration
    When the server does not respond as a Happy server
    Then I see an error message
    And the server URL is not saved

  Scenario: Reset to default server
    Given I am on Server Configuration
    When I choose "Reset to Default" and confirm
    Then the app returns to the default server
