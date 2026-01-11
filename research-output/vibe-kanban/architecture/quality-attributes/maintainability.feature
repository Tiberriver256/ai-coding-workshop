Feature: Maintainability
  The system should keep client/server contracts and state updates easy to evolve.

  Scenario: Shared types stay in sync with backend models
    Given backend API models have changed
    When shared types are regenerated
    Then client builds should succeed without manual type edits

  Scenario: API responses follow the standard envelope
    Given a client calls any API endpoint
    Then the response should include success, data, error, and message fields

  Scenario: JSON Patch updates apply cleanly
    Given a client has applied the initial snapshot
    When a JSON Patch update is received
    Then applying the patch should succeed without conflicts
