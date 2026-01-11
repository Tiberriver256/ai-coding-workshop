Feature: Availability
  To keep sessions usable across devices
  As a platform operator
  I want the system to recover quickly from disconnections

  Scenario: Reconnect triggers resynchronization
    Given a mobile client that was disconnected from the update channel
    When the connection is re-established
    Then the client should invalidate cached views
    And refresh sessions, machines, and messages to converge on current state

  Scenario: Push notifications work when real-time channels are offline
    Given a mobile device that is offline from the update channel
    When the CLI sends a push notification
    Then the user should still receive the notification via the push provider

