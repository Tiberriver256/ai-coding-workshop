Feature: Agent profiles and variants
  As a user
  I want to configure agent profiles and variants
  So that I can choose the right behavior for each task

  Scenario: Configure agent profiles in the form editor
    Given I am on Settings > Agents
    When I select an agent and variant
    And I edit the configuration fields
    Then the variant configuration is saved

  Scenario: Configure agent profiles in the JSON editor
    Given I am on Settings > Agents
    When I switch to the JSON editor
    And I update the profiles JSON
    Then the changes are saved
    And the updated variants are available in task attempts

  Scenario: Cannot delete the last variant
    Given an agent has only one configuration variant
    When I attempt to delete it
    Then I see a message that the last configuration cannot be deleted
