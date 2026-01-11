Feature: Performance
  The system should provide low-latency remote control and session updates.

  Scenario: Real-time message propagation
    Given network round-trip time is 100 ms or less and packet loss is under 1%
    When the CLI sends a session message to the server
    Then the mobile client receives the update within 500 ms at the 95th percentile

  Scenario: Session startup readiness
    Given the server is reachable and authentication is valid
    When the CLI creates a new session and opens the real-time channel
    Then the session is marked ready within 2 seconds

  Scenario: Permission request notification
    Given permission mode is "default"
    When a tool call requires user approval
    Then a permission request is delivered to the mobile client within 1 second
