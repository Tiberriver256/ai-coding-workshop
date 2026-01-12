Feature: Agent execution monitoring
  As a user
  I want to view live execution logs
  So that I can monitor agent progress

  Background:
    Given a task attempt is running

  Scenario: View real-time execution logs
    When I open the task view
    Then I see streaming logs of agent actions and responses
