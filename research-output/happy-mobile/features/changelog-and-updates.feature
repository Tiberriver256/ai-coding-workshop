Feature: View updates and what's new
  As a user
  I want to know about app updates and changes
  So that I can stay up to date

  Scenario: Native app update available
    Given I am on the Sessions or Inbox screen
    When a native app update is available
    Then I see an update banner
    And I can tap it to open the app store

  Scenario: Over-the-air update available
    Given I am on the Sessions or Inbox screen
    When an OTA update is available
    Then I see an update banner
    And I can tap it to apply the update

  Scenario: View changelog
    Given I open "What's New"
    Then I see a list of versions and changes

  Scenario: No changelog entries
    Given I open "What's New"
    And there are no changelog entries
    Then I see an empty state message
