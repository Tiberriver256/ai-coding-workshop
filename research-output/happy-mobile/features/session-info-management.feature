Feature: View and manage session details
  As a user
  I want to see details about a session and manage it
  So that I can understand and control it

  Scenario: Open session info
    Given I am viewing a session
    When I tap the session avatar or header
    Then I see session details including IDs, status, and metadata

  Scenario: Copy session identifiers
    Given I am on the session info screen
    When I tap the Happy session ID
    Then the ID is copied to my clipboard

  Scenario: Archive an active session
    Given I am on the session info screen
    And the session is online
    When I choose to archive the session and confirm
    Then the session is archived
    And I return to the previous screen

  Scenario: Delete an inactive session
    Given I am on the session info screen
    And the session is offline and inactive
    When I choose to delete the session and confirm
    Then the session is deleted

  Scenario: Session is missing or deleted
    Given I navigate to session info for a deleted session
    Then I see a deleted-session message
