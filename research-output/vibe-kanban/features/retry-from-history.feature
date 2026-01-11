Feature: Retry from a previous execution point
  As a user
  I want to restore a task attempt to a prior process
  So that I can retry from a known checkpoint

  Scenario: Restore to a previous process
    Given a task attempt has multiple execution processes
    When I choose to retry from a prior process
    Then I see a summary of the history change
    And I can confirm to restore to that point

  Scenario: Restore with a worktree reset
    Given I am restoring to a previous process
    When I enable "Reset worktree"
    Then the worktree is reset to the selected commit

  Scenario: Uncommitted changes require acknowledgment
    Given the worktree has uncommitted changes
    When I attempt to restore history
    Then I must acknowledge the risk before confirming
