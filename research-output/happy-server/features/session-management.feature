Feature: Session management
  As an authenticated client, I want to create, list, and delete sessions and access their messages.

  Background:
    Given I am an authenticated API client

  Scenario: List recent sessions
    When I GET /v1/sessions
    Then the response includes up to 150 sessions sorted by most recently updated

  Scenario: Create a new session by tag
    Given no session exists for tag "project-abc"
    When I POST /v1/sessions with tag "project-abc" and metadata
    Then the response includes a new session for that tag

  Scenario: Reusing a tag returns the existing session
    Given a session already exists with tag "project-abc"
    When I POST /v1/sessions with tag "project-abc"
    Then the response includes the existing session id and versions

  Scenario: List active sessions only
    When I GET /v2/sessions/active with limit 50
    Then the response includes only recently active sessions

  Scenario: Cursor-based session pagination
    Given I have a nextCursor from a previous /v2/sessions call
    When I GET /v2/sessions with that cursor
    Then the response includes the next page of sessions
    And the response indicates whether more pages exist

  Scenario: Invalid cursor format is rejected
    When I GET /v2/sessions with cursor "bad-cursor"
    Then the response status is 400
    And the response contains an "Invalid cursor format" error

  Scenario: Retrieve messages for a session
    Given I have a valid session id
    When I GET /v1/sessions/{sessionId}/messages
    Then the response includes recent messages for that session

  Scenario: Deleting a session removes it from my account
    Given I have a valid session id
    When I DELETE /v1/sessions/{sessionId}
    Then the response indicates success

  Scenario: Deleting a missing session returns not found
    Given I have a session id that does not belong to me
    When I DELETE /v1/sessions/{sessionId}
    Then the response status is 404
    And the response contains a "Session not found" error
