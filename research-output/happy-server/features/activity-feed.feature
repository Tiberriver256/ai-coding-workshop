Feature: User activity feed
  As an authenticated client, I want to fetch my feed with cursor-based pagination.

  Background:
    Given I am an authenticated API client

  Scenario: Fetch the newest feed items
    When I GET /v1/feed with limit 50
    Then the response includes feed items in newest-first order
    And the response includes hasMore

  Scenario: Paginate older items using a before cursor
    Given I have a feed cursor "0-123"
    When I GET /v1/feed with before "0-123"
    Then the response includes items older than that cursor

  Scenario: Paginate newer items using an after cursor
    Given I have a feed cursor "0-123"
    When I GET /v1/feed with after "0-123"
    Then the response includes items newer than that cursor
