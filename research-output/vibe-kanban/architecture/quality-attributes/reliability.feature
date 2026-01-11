Feature: Reliability
  The system should deliver consistent state and recover from transient failures.

  Scenario: Stream reconnection provides history and live updates
    Given a client disconnects from the event stream
    When the client reconnects within the retention window
    Then it should receive history followed by live updates without gaps

  Scenario: PR status eventually updates task state
    Given a pull request is merged in the external Git host
    When the poller runs within the next 2 minutes
    Then the corresponding task status should update to Done

  Scenario: Remote calls retry on transient failures
    Given a transient network error occurs when calling the remote service
    When the client retries with exponential backoff
    Then the request should succeed within 3 attempts or surface a clear error
