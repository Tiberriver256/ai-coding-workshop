Feature: Find and manage friends
  As a user
  I want to find other users and manage friend requests
  So that I can connect with collaborators

  Scenario: Search for users by username
    Given I am signed in
    When I open Friend Search
    And I enter a username
    Then I see matching users

  Scenario: No user found
    Given I am on Friend Search
    When I search for a username with no matches
    Then I see a "no user found" message

  Scenario: Send a friend request
    Given I see a user in search results
    When I tap "Add Friend"
    Then a friend request is sent
    And the user shows a pending status

  Scenario: Prevent adding myself
    Given I am on Friend Search
    When I try to add my own account
    Then I see a message that I cannot add myself

  Scenario: Accept a friend request
    Given I have an incoming friend request
    When I accept the request
    Then the user becomes a friend

  Scenario: Deny or cancel a friend request
    Given I have an incoming or outgoing request
    When I choose to deny or cancel
    Then the request is removed

  Scenario: Remove a friend
    Given I am viewing a friend profile
    When I choose to remove the friend and confirm
    Then the friend is removed from my list

  Scenario: Open a user's GitHub profile
    Given I am viewing a user profile
    When I tap the GitHub link
    Then the user's GitHub page opens
