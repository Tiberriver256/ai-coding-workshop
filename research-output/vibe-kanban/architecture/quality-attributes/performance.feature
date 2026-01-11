Feature: Performance
  The system should remain responsive for core interactive workflows.

  Scenario: Cached file search is fast
    Given a repository with 50,000 files is already indexed in the file search cache
    When a user searches for a filename prefix
    Then the search results should be returned within 100 ms

  Scenario: Initial task list snapshot is fast
    Given a project with 1,000 tasks
    When the client subscribes to the task stream
    Then the initial snapshot should be delivered within 500 ms

  Scenario: Live diff updates are timely
    Given a task attempt workspace has an active diff stream
    When a file is saved in the workspace
    Then a diff update should be delivered within 1 second
