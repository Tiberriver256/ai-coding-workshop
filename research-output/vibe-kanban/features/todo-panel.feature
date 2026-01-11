Feature: Agent todo list
  As a user
  I want to see the agent's todo list
  So that I can track progress at a glance

  Scenario: View todos with status indicators
    Given an agent has produced a todo list
    When I open the task view
    Then I see a Todos panel with items marked as pending, in progress, completed, or cancelled

  Scenario: Collapse and expand the todos panel
    Given the Todos panel is visible
    When I collapse the panel
    Then the list is hidden
    When I expand the panel
    Then the list is shown again
