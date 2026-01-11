Feature: Scalability
  The system should support growth in concurrent sessions and message volume.

  Scenario: Concurrent session connections
    Given a single machine has 100 active session connections
    When the server sends a burst of 1,000 updates across those sessions
    Then the CLI processes all updates within 2 seconds without dropping messages

  Scenario: RPC handler scale on reconnect
    Given 50 RPC methods are registered for a session scope
    When the real-time connection reconnects
    Then all 50 methods are re-registered within 1 second

  Scenario: Daemon session spawning throughput
    Given the daemon receives 10 session spawn requests within 1 minute
    When each request targets a unique working directory
    Then all 10 sessions are spawned or rejected with explicit errors within 30 seconds
