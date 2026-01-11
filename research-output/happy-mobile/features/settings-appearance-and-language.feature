Feature: Customize appearance and app language
  As a user
  I want to customize how the app looks and reads
  So that it matches my preferences

  Scenario: Change theme preference
    Given I am on Appearance Settings
    When I tap Theme
    Then the theme cycles between Adaptive, Light, and Dark

  Scenario: Change app language
    Given I am on Language Settings
    When I choose a new language
    Then I am asked to restart the app
    And the language is applied after restart

  Scenario: Toggle display preferences
    Given I am on Appearance Settings
    When I change display toggles like compact view or line numbers
    Then the app uses my new display preferences

  Scenario: Change avatar style
    Given I am on Appearance Settings
    When I tap Avatar Style
    Then the avatar style cycles to the next option
