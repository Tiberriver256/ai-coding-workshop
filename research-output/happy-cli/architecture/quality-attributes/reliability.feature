Feature: Reliability
  The system should remain correct and recover from transient failures.

  Scenario: Real-time reconnection after network loss
    Given the real-time channel disconnects for 30 seconds
    When network connectivity is restored
    Then the client reconnects within 10 seconds
    And keep-alive messages resume within 5 seconds after reconnect

  Scenario: Optimistic concurrency on metadata updates
    Given two clients update session metadata concurrently
    When one update wins and the other receives a version mismatch
    Then the losing client retries with the latest version
    And the final metadata reflects both updates without loss

  Scenario: Exponential backoff on transient update failures
    Given the server rejects three consecutive state updates due to version conflicts
    When the client retries with exponential backoff
    Then the update succeeds within 5 attempts once conflicts stop
