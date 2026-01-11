Feature: Manage a connected machine
  As a user
  I want to view and manage a connected machine
  So that I can start sessions and control the daemon

  Scenario: View machine details
    Given I am on a machine detail screen
    Then I see the machine status and metadata
    And I see recent sessions for that machine

  Scenario: Rename a machine
    Given I am on a machine detail screen
    When I choose to rename the machine
    And I enter a new name
    Then the machine name is updated

  Scenario: Stop the daemon
    Given I am on a machine detail screen
    When I choose to stop the daemon and confirm
    Then the daemon is stopped
    And I see a confirmation message

  Scenario: Start a session from a machine
    Given I am on a machine detail screen
    When I enter a path and start a session
    Then a new session is created for that machine

  Scenario: Path does not exist
    Given I enter a path that does not exist
    When I start a session
    Then I am asked to create the directory
    And the session starts only after I confirm
