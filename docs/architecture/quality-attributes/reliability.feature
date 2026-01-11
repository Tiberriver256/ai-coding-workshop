Feature: Reliability
  The system should deliver consistent state and safe execution outcomes.

  Scenario: Patch stream ordering prevents lost updates
    Given a client applies patches in sequence order
    When reconnecting within the retention window
    Then no task updates should be missing or duplicated

  Scenario: External operations are idempotent
    Given a pull request creation request is retried
    When the external system receives duplicate requests
    Then only one pull request should be created
    And the task should reference the single external identifier

  Scenario: Approval timeouts do not leave actions running
    Given a sensitive action is awaiting approval
    When the approval deadline passes
    Then the action should be marked as timed out
    And execution should not proceed
