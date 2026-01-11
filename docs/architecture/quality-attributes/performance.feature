Feature: Performance
  The system should keep the kanban UI and remote control responsive.

  Scenario: Incremental updates avoid full reloads
    Given a project board with many tasks
    When a single task changes status
    Then the client should receive a small patch update
    And the board should update without full reload

  Scenario: Log and diff streaming stays responsive under load
    Given a task attempt is producing continuous logs and diffs
    When stream payloads exceed the configured threshold
    Then the system should switch to summarized updates
    And keep delivery latency within an interactive range
