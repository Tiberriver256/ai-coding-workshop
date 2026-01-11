Feature: Consistency and conflict handling

  Scenario: Optimistic concurrency prevents lost updates
    Given a client holds an outdated version of an entity
    When the client submits an update with the stale version
    Then the update should be rejected with a version-mismatch response
    And the latest version should be returned to the client

  Scenario: Update sequences are strictly increasing per user
    Given a user receives real-time updates over time
    When updates are emitted by the server
    Then each update sequence number should be greater than the previous one
    And gaps should indicate missed updates for resync
