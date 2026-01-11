Feature: Usage reporting and querying
  As an authenticated client, I want to report usage and query usage summaries for billing or analytics.

  Background:
    Given I am an authenticated API client

  Scenario: Report usage for a session via WebSocket
    Given I have a valid session id
    When I emit "usage-report" with a key, sessionId, tokens, and cost
    Then the acknowledgement indicates success
    And the acknowledgement includes report timestamps

  Scenario: Usage report fails for an unknown session
    Given I have a session id that does not belong to me
    When I emit "usage-report" with that sessionId
    Then the acknowledgement indicates an error
    And the error states the session was not found

  Scenario: Query usage over a time range
    When I POST /v1/usage/query with startTime, endTime, and groupBy
    Then the response includes aggregated usage entries
    And the response indicates the grouping used and total report count

  Scenario: Querying usage for a session I do not own returns not found
    Given I have a session id that does not belong to me
    When I POST /v1/usage/query with that sessionId
    Then the response status is 404
    And the response contains a "Session not found" error
