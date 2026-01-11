Feature: Account profile retrieval
  As an authenticated client, I want to fetch my profile so I can display user identity and connected services.

  Background:
    Given I am an authenticated API client

  Scenario: Retrieve account profile
    When I GET /v1/account/profile
    Then the response includes my id, name, and username
    And the response includes an avatar with a public URL when available
    And the response includes connected services and GitHub profile when linked

  Scenario: Missing authentication is rejected
    Given I am not authenticated
    When I GET /v1/account/profile
    Then the response status is 401
    And the response contains an authentication error
