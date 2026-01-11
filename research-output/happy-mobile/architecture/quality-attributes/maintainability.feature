Feature: Maintainability
  To support long-term evolution of schemas and update types
  As a maintainer
  I want changes to be isolated and safe to deploy incrementally

  Scenario: Forward-compatible settings schema
    Given stored settings include fields unknown to the current client version
    When the client loads and saves settings
    Then unknown fields should be preserved unmodified
    And known fields should retain their defaults when missing

  Scenario: Unknown update type handling
    Given the server introduces a new update type not recognized by the client
    When the client receives the update
    Then the update should be ignored safely
    And the client should continue to process recognized update types

  Scenario: Idempotent update application
    Given the same update event is delivered twice
    When the client applies the update to local state
    Then the final state should be identical to a single application
