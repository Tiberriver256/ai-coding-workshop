Feature: Performance
  To provide low-latency cross-device experiences
  As a user
  I want real-time updates to be fast without excessive load

  Scenario: Durable updates stream over the real-time channel after bootstrap
    Given a client that has completed HTTP bootstrap
    When a new message is created on another device
    Then the update should arrive over the real-time channel without polling

  Scenario: Ephemeral activity updates are throttled
    Given frequent heartbeat signals from active sessions
    When activity updates are processed
    Then durable storage writes should be throttled or batched
    And ephemeral updates should still appear in the UI

