Feature: Organization switching
  As a user in multiple organizations
  I want to switch my active organization
  So that I can view the correct shared projects and tasks

  Scenario: Switch to another organization
    Given I belong to more than one organization
    When I open the organization switcher
    And I select a different organization
    Then the active organization changes
    And organization-specific data reflects the new selection

  Scenario: No organizations available
    Given I do not belong to any organizations
    When I open the organization switcher
    Then I see a message indicating no organizations are available
