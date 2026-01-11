Feature: Availability and health visibility

  Scenario: Health check reflects database availability
    Given the database is reachable
    When the health endpoint is called
    Then the response status should be 200

  Scenario: Health check fails fast on dependency outage
    Given the database is unreachable
    When the health endpoint is called
    Then the response status should be 503
    And the response should indicate a dependency failure
