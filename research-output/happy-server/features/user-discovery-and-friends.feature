Feature: User discovery and friendships
  As an authenticated client, I want to look up users and manage friend relationships.

  Background:
    Given I am an authenticated API client

  Scenario: Get a user profile
    Given a user exists with id "user-123"
    When I GET /v1/user/user-123
    Then the response includes the user's profile and relationship status

  Scenario: Search users by username prefix
    When I GET /v1/user/search with query "al"
    Then the response includes up to 10 matching users
    And each user includes relationship status

  Scenario: Send a friend request
    Given a user exists with id "user-456"
    When I POST /v1/friends/add with uid "user-456"
    Then the response includes the user's profile
    And the relationship status is "requested" or "friend" depending on prior state

  Scenario: Remove or decline a relationship
    Given a relationship exists with user "user-456"
    When I POST /v1/friends/remove with uid "user-456"
    Then the response includes the user's profile
    And the relationship status reflects the removal outcome

  Scenario: List friends
    When I GET /v1/friends
    Then the response includes my current friends list
