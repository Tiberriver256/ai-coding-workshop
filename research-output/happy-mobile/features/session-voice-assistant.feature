Feature: Use the voice assistant in a session
  As a user
  I want to start and stop a voice assistant in a session
  So that I can interact hands-free

  Scenario: Start a voice session
    Given I am viewing a session
    And the voice assistant is disconnected
    When I tap the microphone button
    Then the voice assistant connects
    And I see a voice status indicator

  Scenario: Stop a voice session
    Given I am viewing a session
    And the voice assistant is connected
    When I tap the microphone button
    Then the voice assistant stops

  Scenario: Voice session fails to start
    Given I am viewing a session
    When I tap the microphone button
    And the voice assistant fails to connect
    Then I see an error message
    And the voice assistant remains disconnected
