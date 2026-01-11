Feature: Real-time sync across Happy devices
  As a user
  I want my sessions and machines to stay in sync across devices
  So that I always see the latest status and messages

  Background:
    Given my computer is paired with my Happy mobile app
    And I am signed in on both devices

  Scenario: Session status updates in real time
    Given I am viewing the sessions list on my phone
    When a session starts on my computer
    Then the session appears as online on my phone
    When the session ends on my computer
    Then the session appears as offline on my phone

  Scenario: Machine status updates in real time
    Given I am viewing my machine list on my phone
    When the Happy daemon sends a heartbeat from my computer
    Then the machine status shows as online
    When the daemon stops sending heartbeats
    Then the machine status shows as offline

  Scenario: Messages stay consistent across devices
    Given I have the same session open on my phone and computer
    When I send a message from the phone
    Then the message appears on the computer
    When the agent responds on the computer
    Then the response appears on the phone
