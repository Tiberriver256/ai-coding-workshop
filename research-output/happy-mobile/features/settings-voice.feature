Feature: Configure voice assistant language
  As a user
  I want to choose the voice assistant language
  So that voice interactions match my preference

  Scenario: View current voice language
    Given I am on Voice Settings
    Then I see the currently selected language

  Scenario: Search and select a language
    Given I am on the voice language selection screen
    When I search for a language
    And I select a language
    Then the voice assistant language is updated
    And I return to the previous screen

  Scenario: Clear a language search
    Given I have typed a search query in voice language selection
    When I clear the search
    Then I see the full language list again
