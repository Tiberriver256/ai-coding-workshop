Feature: Manage experimental and feature toggles
  As a user
  I want to control experimental features and behavior toggles
  So that I can opt in or out safely

  Scenario: Toggle experimental features
    Given I am on Features Settings
    When I enable experimental features
    Then experimental-only options become available

  Scenario: Toggle markdown copy improvements
    Given I am on Features Settings
    When I toggle the Markdown copy option
    Then the copy behavior updates accordingly

  Scenario: Hide inactive sessions
    Given I am on Features Settings
    When I enable "Hide Inactive Sessions"
    Then inactive sessions are hidden from the list
