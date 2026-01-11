Feature: Performance for sync and core APIs

  Scenario: Session list retrieval is fast for common payload sizes
    Given a user has 150 sessions
    When the client requests the session list
    Then the response time should be under 300 ms
    And the response should include no more than 150 sessions

  Scenario: Real-time update fan-out is low latency
    Given a user has 20 active devices connected to the real-time channel
    When one device sends a new message to a session
    Then all other interested devices should receive the update within 1 second

  Scenario: Presence heartbeats do not overload storage
    Given a device sends a heartbeat every 5 seconds for 10 minutes
    When the system records durable activity timestamps
    Then the durable updates for that device should occur no more than once every 30 seconds
