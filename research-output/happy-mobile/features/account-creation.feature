Feature: Create a new Happy account on mobile
  As a new user
  I want to create a Happy account from the welcome screen
  So that I can use the app without a desktop setup

  Scenario: Create a new account successfully
    Given I have installed the Happy mobile app
    And I am not authenticated
    When I tap "Create Account"
    Then the app creates a new account for me
    And I am signed in and taken to the main app

  Scenario: Account creation fails
    Given I am on the welcome screen
    And I am not authenticated
    When I tap "Create Account"
    And the account creation fails
    Then I see an error message
    And I remain on the welcome screen

  Scenario: Choose to link or restore instead of creating
    Given I am on the welcome screen
    And I am not authenticated
    When I tap "Link or Restore Account"
    Then I am taken to the restore options
