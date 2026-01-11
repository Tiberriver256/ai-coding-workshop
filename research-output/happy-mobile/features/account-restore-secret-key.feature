Feature: Restore an account with a secret key
  As a user who saved a secret key
  I want to restore my account with that key
  So that I can regain access on a new device

  Scenario: Restore with a valid secret key
    Given I am on the secret key restore screen
    When I enter a valid secret key
    And I tap "Restore Account"
    Then I am signed in
    And I return to the previous screen

  Scenario: Secret key is missing
    Given I am on the secret key restore screen
    When I leave the secret key field empty
    And I tap "Restore Account"
    Then I see a message telling me to enter a secret key
    And I remain on the restore screen

  Scenario: Secret key is invalid
    Given I am on the secret key restore screen
    When I enter an invalid secret key
    And I tap "Restore Account"
    Then I see a message that the secret key is invalid
    And I remain on the restore screen
