Feature: Approvals for agent actions
  As a user
  I want to approve or deny sensitive agent actions
  So that I stay in control of changes

  Scenario: Approve an action
    Given an agent action requires approval
    When I click "Approve"
    Then the action proceeds
    And the log reflects the approved action

  Scenario: Deny an action
    Given an agent action requires approval
    When I click "Deny"
    Then the action is cancelled or adjusted
    And the log reflects the denial

  Scenario: No approvals for unsupported agents
    Given I am using an agent that does not support approvals
    When the agent runs actions
    Then no approval prompt is shown
