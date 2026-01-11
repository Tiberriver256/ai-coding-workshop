Feature: Monitor and control agent execution
  As a user
  I want to see live agent activity and control execution
  So that I can intervene when needed

  Background:
    Given a task attempt is running

  Scenario: View real-time execution logs
    When I open the task view
    Then I see streaming logs of agent actions and responses

  Scenario: View all processes for an attempt
    When I open "View Processes"
    Then I see a list of processes with status and timestamps
    And I can open a process to view its logs

  Scenario: Abort a running attempt
    When I click "Stop" on the task attempt
    Then the agent stops the current work
    And the attempt status changes to Stopped

  Scenario: No processes available
    Given the attempt has no processes
    When I open "View Processes"
    Then I see a message indicating no processes are available
