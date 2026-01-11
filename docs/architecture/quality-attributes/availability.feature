Feature: Availability
  The system should remain usable despite disconnects or network constraints.

  Scenario: Remote access falls back to relay when P2P fails
    Given two devices cannot establish direct connectivity
    When a remote control session is initiated
    Then the session should be established through the relay
    And control commands should continue to flow end-to-end encrypted

  Scenario: Reconnect triggers resynchronization of the kanban board
    Given a client was disconnected from the state stream
    When the connection is re-established
    Then the client should resume from retained patches if available
    And otherwise refresh the latest snapshot

  Scenario: External integrations degrade gracefully
    Given the external DevOps system is temporarily unavailable
    When the user requests a status update
    Then the system should retry with backoff
    And present a clear degraded-state message
