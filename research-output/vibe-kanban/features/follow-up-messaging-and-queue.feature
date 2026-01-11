Feature: Follow-up messaging and queueing
  As a user
  I want to send and queue follow-up messages
  So that I can guide the agent even while it is running

  Scenario: Send a follow-up message when idle
    Given a task attempt is idle
    When I type a follow-up message
    And I press Send
    Then the message is delivered to the agent

  Scenario: Queue a message while the agent is running
    Given a task attempt is running
    When I compose a follow-up message
    And I choose "Queue"
    Then the message is queued
    And I see an indicator that it will run next

  Scenario: Cancel a queued message by editing
    Given a message is queued
    When I edit the message text
    Then the queue is cancelled
    And the message becomes an editable draft again

  Scenario: Stop a running attempt
    Given a task attempt is running
    When I press "Stop"
    Then the running process is stopped

  Scenario: Run setup or cleanup scripts manually
    Given I am viewing a task attempt
    When I choose to run the setup script or cleanup script
    Then the selected script runs and appears in the logs

  Scenario: No setup or cleanup script configured
    Given no setup or cleanup script is configured for the project
    When I try to run a setup or cleanup script
    Then I see a message that no script is configured

  Scenario: Scripts cannot run while another process is active
    Given a process is already running
    When I attempt to run a setup or cleanup script
    Then I see a message that scripts are disabled while running
