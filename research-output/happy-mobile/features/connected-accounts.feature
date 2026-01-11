Feature: Connect external accounts
  As a user
  I want to connect my AI provider and GitHub accounts
  So that I can use provider-specific features and social identity

  Scenario: Connect Claude Code account
    Given I am on Settings
    When I tap "Claude Code"
    Then I see instructions for connecting via the terminal

  Scenario: Connect GitHub account
    Given I am on Settings
    When I tap "GitHub" and I am not connected
    Then I am taken to GitHub authorization

  Scenario: Disconnect GitHub account
    Given I am on Settings
    And my GitHub account is connected
    When I tap "GitHub" and confirm disconnect
    Then my GitHub account is disconnected
