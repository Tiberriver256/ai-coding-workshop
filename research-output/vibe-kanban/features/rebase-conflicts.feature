Feature: Resolve rebase conflicts
  As a user
  I want to resolve rebase conflicts within Vibe Kanban
  So that I can continue toward merging

  Scenario: Conflict banner appears after a failed rebase
    Given a rebase encounters conflicts
    When I return to the task
    Then I see a "Rebase conflicts" status and a conflict banner

  Scenario: Auto-resolve conflicts with the agent
    Given I see the conflict banner
    When I choose "Resolve Conflicts"
    Then a resolution prompt is generated
    And the agent attempts to resolve the conflicts

  Scenario: Resolve conflicts manually in an editor
    Given I see the conflict banner
    When I choose "Open in Editor"
    Then the conflicted files open in my editor
    And I can resolve conflicts manually

  Scenario: Abort a rebase
    Given a rebase is in conflict
    When I choose "Abort Rebase"
    Then the rebase is cancelled
    And the task returns to a rebase-needed state
