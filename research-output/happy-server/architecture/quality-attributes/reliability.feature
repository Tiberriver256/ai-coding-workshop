Feature: Reliability and recovery

  Scenario: No update is emitted when a transaction fails
    Given a state-changing operation begins a transaction
    When the transaction rolls back due to an error
    Then no real-time update should be emitted for that operation

  Scenario: Clients can recover missed updates after reconnecting
    Given a client disconnects from the real-time channel
    When the client reconnects and requests updates using a cursor or change filter
    Then the client should receive all committed changes since its last known sequence

  Scenario: Background timeout handling cleans up stale activity
    Given a session has been inactive for more than 10 minutes
    When the timeout process runs
    Then the session should be marked inactive
    And an activity update should be emitted to interested clients
