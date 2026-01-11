Feature: Manage artifacts
  As a user
  I want to create and manage artifacts
  So that I can save notes or outputs from my sessions

  Scenario: View artifacts list
    Given I am signed in
    When I open Artifacts
    Then I see a list of my artifacts

  Scenario: Empty artifacts list
    Given I open Artifacts
    And I have no artifacts
    Then I see an empty state message

  Scenario: Create a new artifact
    Given I am on the new artifact screen
    When I enter a title or body
    And I tap Save
    Then the artifact is created
    And I am taken to the artifact detail view

  Scenario: Prevent saving an empty artifact
    Given I am on the new artifact screen
    When I leave both title and body empty
    And I tap Save
    Then I see an error message
    And the artifact is not created

  Scenario: View an artifact
    Given I open an artifact from the list
    Then I see its title, date, and content

  Scenario: Edit an artifact
    Given I am viewing an artifact
    When I tap Edit
    And I update the title or body
    And I tap Save
    Then the changes are saved

  Scenario: Delete an artifact
    Given I am viewing an artifact
    When I tap Delete and confirm
    Then the artifact is removed
    And I return to the list
