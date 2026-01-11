Feature: Browse project files and diffs for a session
  As a user
  I want to browse project files and changes from my session
  So that I can inspect work without leaving the app

  Scenario: View git status summary
    Given I open the session files screen
    When the project is a git repository
    Then I see the current branch
    And I see counts of staged and unstaged changes

  Scenario: View staged and unstaged files
    Given I open the session files screen
    And there are staged or unstaged changes
    Then I see separate lists for staged and unstaged files
    And each file shows its change summary

  Scenario: Search files
    Given I open the session files screen
    When I enter a search term
    Then I see matching files
    And I can open a file from the results

  Scenario: Project is not a git repository
    Given I open the session files screen
    And the project is not under git
    Then I see a message explaining that git status is unavailable

  Scenario: Open a file and view diff
    Given I select a file from the session files screen
    When a diff is available
    Then I can switch between Diff and File views

  Scenario: Open a binary file
    Given I select a binary file
    Then I see a message that the file cannot be displayed

  Scenario: File cannot be loaded
    Given I select a file
    When the file fails to load
    Then I see an error message
