Feature: Inspect project files and diffs from the mobile app
  As a user
  I want to inspect project files and changes from my phone
  So that I can review work done on my computer

  Background:
    Given my computer is paired with my Happy mobile app
    And an active session is running on my computer

  Scenario: View git status and change summaries
    When I open the session files screen on my phone
    Then I see the current branch and change counts
    And I see staged and unstaged files grouped separately

  Scenario: Open a file and view its diff
    Given I am viewing the session files screen
    When I select a changed file
    Then I can switch between the file view and the diff view

  Scenario: Search for files in the project
    Given I am viewing the session files screen
    When I search for a filename
    Then I see matching files from the session's project

  Scenario: Project is not a git repository
    Given I open the session files screen
    And the project is not under git
    Then I see a message explaining that git status is unavailable

  Scenario: File cannot be displayed
    Given I select a file that cannot be rendered on the phone
    Then I see an error or unsupported file message
