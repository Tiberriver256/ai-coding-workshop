Feature: Start a session on a paired computer from the mobile app
  As a user
  I want to start a coding session from my phone
  So that I can begin work on my computer remotely

  Background:
    Given my computer is paired with my Happy mobile app
    And the Happy daemon is running on my computer

  Scenario: Start a session in a chosen directory
    Given I am viewing my computer in the app
    When I enter a project path
    And I start a new session
    Then a new session is created on my computer
    And the session opens on my phone

  Scenario: Directory does not exist
    Given I am viewing my computer in the app
    When I enter a path that does not exist
    And I start a new session
    Then I am asked to create the directory
    When I confirm directory creation
    Then the session starts in the new directory

  Scenario: Daemon is offline
    Given my computer is offline or the daemon is stopped
    When I try to start a session from the app
    Then I see an error indicating the daemon is not running
    And no session is created

  Scenario: Stop the daemon from the phone
    Given I am viewing my computer in the app
    When I choose to stop the daemon
    Then the daemon stops on my computer
    And the app shows the computer as offline
