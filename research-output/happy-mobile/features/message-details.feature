Feature: View full message details
  As a user
  I want to open a message for full details
  So that I can inspect tool output and long responses

  Scenario: Open a tool message in full view
    Given I am viewing a session
    And a message contains a tool call
    When I open the message details
    Then I see the tool header and status
    And I see the full tool output

  Scenario: Open a regular message in full view
    Given I am viewing a session
    When I open a text message
    Then I see the full message content

  Scenario: Message not found
    Given I open message details
    And the message no longer exists
    Then I am returned to the previous screen
