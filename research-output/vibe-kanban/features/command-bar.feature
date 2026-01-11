Feature: Command bar
  As a user
  I want a command bar for quick actions
  So that I can navigate and run actions efficiently

  Scenario: Open the command bar and run an action
    Given I am in the new UI
    When I open the command bar
    And I search for an action
    And I select it
    Then the action is executed

  Scenario: No matching results
    Given I open the command bar
    When I search for a nonexistent action
    Then I see a "No results found" message
