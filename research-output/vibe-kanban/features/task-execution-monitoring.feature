Feature: Task execution monitoring
  As a user
  I want to monitor coding agent execution
  So that I can see progress in real time

  Scenario: View real-time execution logs
    Given a task attempt is running
    When I open the task view
    Then I see streaming logs of agent actions and responses

  Scenario: Expand file changes in the log
    Given a log entry represents a file change
    When I expand the entry
    Then I can see which part of the file was modified

  Scenario: View all processes for an attempt
    Given a task attempt has running or completed processes
    When I open "View Processes"
    Then I see a list of processes with status and timestamps
    And I can open a process to view its logs

  Scenario: No processes available
    Given an attempt has no processes
    When I open "View Processes"
    Then I see a message indicating no processes are available
