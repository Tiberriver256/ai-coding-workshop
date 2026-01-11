Feature: Scalability of synchronization and routing

  Scenario: Cursor pagination scales with large datasets
    Given a user has 100000 sessions
    When the client requests sessions with a limit of 50 using a cursor
    Then the response should contain at most 50 sessions
    And a next cursor should be provided when more results exist

  Scenario: Scoped routing limits fan-out at scale
    Given a user has 1 user-scoped connection, 50 session-scoped connections, and 10 machine-scoped connections
    When a session update for a specific session is emitted
    Then only the user-scoped connection and the session-scoped connections for that session should receive the update

  Scenario: Batch updates reduce database write amplification
    Given 1000 devices send heartbeat events in a 60-second window
    When the system persists activity timestamps
    Then the number of database writes should be bounded by the batching interval and threshold
