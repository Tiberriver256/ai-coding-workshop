Feature: Scalability
  To support growth in users and update volume
  As a system owner
  I want the client to remain stable under high concurrency and event rates

  Scenario: High update volume processing
    Given 1,000 active sessions generating 10,000 update events per minute
    When the client processes the incoming updates for 10 minutes
    Then the update backlog should remain below 5 seconds of lag
    And the client should not crash or drop the connection

  Scenario: Concurrent control operations
    Given 50 concurrent control operations are initiated against remote sessions
    When the client issues these operations over the update channel
    Then 99% of acknowledgments should be received within 2 seconds

  Scenario: Large local cache
    Given the client has cached 5,000 messages and 1,000 session records locally
    When the app restores from local cache
    Then memory usage attributable to the cache should remain below 300 MB
