Feature: Browse and open sessions
  As a user
  I want to see my sessions and their status
  So that I can jump back into any conversation

  Scenario: View sessions list with status
    Given I am signed in
    When I open the Sessions tab
    Then I see my sessions grouped by recency
    And each session shows its name, path, and status

  Scenario: Open a session from the list
    Given I am viewing the Sessions tab
    When I tap a session
    Then the session chat opens

  Scenario: Empty sessions state
    Given I am signed in
    And I have no sessions
    When I open the Sessions tab
    Then I see an empty state with a call to start a new session

  Scenario: Delete a session from the list
    Given I am viewing the Sessions tab
    And a session is eligible for deletion
    When I swipe left on the session and confirm delete
    Then the session is removed from the list

  Scenario: Update banner appears when updates are available
    Given I am viewing the Sessions tab
    When an app update or changelog is available
    Then I see a banner that takes me to update or view what is new
