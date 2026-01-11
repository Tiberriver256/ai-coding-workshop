Feature: Scalability
  To support many concurrent devices per user
  As a platform operator
  I want update delivery to scale with minimal overhead

  Scenario: Connection-scoped routing limits fan-out
    Given multiple user-, session-, and machine-scoped connections
    When a session update is emitted
    Then only interested connections should receive the update

  Scenario: Separate scopes reduce cross-traffic
    Given concurrent session and machine control flows
    When updates are emitted
    Then session-scoped updates should not be broadcast to machine-scoped clients

