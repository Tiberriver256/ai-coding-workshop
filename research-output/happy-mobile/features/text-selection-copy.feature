Feature: View and copy full text
  As a user
  I want to open long text in a dedicated view and copy it
  So that I can reuse output easily

  Scenario: Open text selection view
    Given I tap a text selection link in a message
    When the text is available
    Then I see the full text in a scrollable view

  Scenario: Copy all text
    Given I am viewing full text
    When I tap the Copy button
    Then the full text is copied to my clipboard

  Scenario: No text provided
    Given I open the text selection view without a valid text reference
    Then I see an error message
    And I return to the previous screen
