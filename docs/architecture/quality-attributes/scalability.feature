Feature: Scalability
  The system should scale to many concurrent users, tasks, and devices.

  Scenario: Scope-based routing limits fan-out
    Given many concurrent user, workspace, and session connections
    When a task update is emitted
    Then only connections within the relevant scope should receive it

  Scenario: Relay capacity scales with concurrent remote sessions
    Given many concurrent remote access sessions through the relay
    When the session count increases
    Then the relay should continue to forward encrypted traffic
    And enforce per-tenant limits to prevent noisy-neighbor impact
