Feature: Real-time session updates and messaging
  As an authenticated client, I want to update session metadata/state and send messages over WebSocket for real-time sync.

  Background:
    Given I am connected to the WebSocket at /v1/updates with a valid token

  Scenario: Update session metadata with version control
    Given I know the current metadata version for session {sessionId}
    When I emit "update-metadata" with sid, metadata, and expectedVersion
    Then the acknowledgement result is "success"
    And the acknowledgement includes the new metadata version

  Scenario: Metadata update fails on version mismatch
    Given the session metadata version has advanced
    When I emit "update-metadata" with a stale expectedVersion
    Then the acknowledgement result is "version-mismatch"
    And the acknowledgement includes the current version and metadata

  Scenario: Update session agent state with version control
    Given I know the current agent state version for session {sessionId}
    When I emit "update-state" with sid, agentState, and expectedVersion
    Then the acknowledgement result is "success"
    And the acknowledgement includes the new agent state version

  Scenario: Send a session message
    Given I am authorized for session {sessionId}
    When I emit "message" with sid and message payload
    Then the message is recorded for the session

  Scenario: Duplicate message with the same localId is ignored
    Given I sent a message with localId "m-123" for session {sessionId}
    When I emit another "message" with the same localId "m-123"
    Then only one message with that localId exists in the session history

  Scenario: Send a session heartbeat
    Given I am authorized for session {sessionId}
    When I emit "session-alive" with a recent timestamp
    Then the server marks the session as active

  Scenario: End a session
    Given I am authorized for session {sessionId}
    When I emit "session-end" with a recent timestamp
    Then the server marks the session as inactive
