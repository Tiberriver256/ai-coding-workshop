Feature: Push notification tokens
  As an authenticated client, I want to register and manage push tokens for notifications.

  Background:
    Given I am an authenticated API client

  Scenario: Register a push token
    When I POST /v1/push-tokens with a device token
    Then the response indicates success

  Scenario: List registered push tokens
    When I GET /v1/push-tokens
    Then the response includes my registered tokens with timestamps

  Scenario: Delete a push token
    Given a push token is registered
    When I DELETE /v1/push-tokens/{token}
    Then the response indicates success
