Feature: View inbox updates and friend activity
  As a user
  I want to see updates and friend activity in one place
  So that I can respond quickly

  Scenario: View feed updates
    Given I am signed in
    When I open the Inbox tab
    Then I see recent updates in my feed

  Scenario: View friend requests in the inbox
    Given I have pending friend requests
    When I open the Inbox tab
    Then I see those requests listed

  Scenario: Empty inbox state
    Given I have no updates or friend activity
    When I open the Inbox tab
    Then I see an empty state message

  Scenario: Inbox loading state
    Given I open the Inbox tab
    When the data is still loading
    Then I see a loading indicator
