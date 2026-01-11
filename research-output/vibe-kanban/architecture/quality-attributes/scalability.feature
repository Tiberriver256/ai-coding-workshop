Feature: Scalability
  The system should handle multiple concurrent tasks and streams without degradation.

  Scenario: Concurrent log streaming remains stable
    Given 100 concurrent task sessions with active log streams
    When the system runs continuously for 10 minutes
    Then stream delivery latency should remain under 2 seconds on average

  Scenario: File search cache respects capacity
    Given the cache capacity is 50 repositories
    When a 51st repository is indexed
    Then the least-recently-used cache entry should be evicted
