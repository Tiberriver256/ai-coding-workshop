Feature: Chat with the agent in a session
  As a user
  I want to exchange messages with my coding agent
  So that I can guide work from my phone

  Scenario: Send a message
    Given I am viewing a session
    When I type a message
    And I tap Send
    Then my message appears in the chat
    And the agent can respond

  Scenario: Prevent sending an empty message
    Given I am viewing a session
    When I tap Send with an empty input
    Then no message is sent

  Scenario: Abort an active response
    Given I am viewing a session
    And the agent is thinking or waiting
    When I tap Abort
    Then the request is cancelled

  Scenario: View session status and usage
    Given I am viewing a session
    Then I can see connection status
    And I can see usage details when available

  Scenario: Change permission mode mid-session
    Given I am viewing a session
    When I change the permission mode
    Then the session uses the new mode for future requests

  Scenario: Open file viewer from a session (experiments enabled)
    Given experimental features are enabled
    And I am viewing a session
    When I tap the file viewer button
    Then I see the project files for that session
