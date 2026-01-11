Feature: Voice session token issuance
  As an authenticated client, I want to request a voice session token when my subscription allows it.

  Background:
    Given I am an authenticated API client

  Scenario: Voice token is issued in development
    Given the server is running in development mode
    And the ElevenLabs API key is configured
    When I POST /v1/voice/token with agentId
    Then the response indicates allowed: true
    And the response includes a voice token

  Scenario: Production requires RevenueCat key
    Given the server is running in production mode
    And no RevenueCat public key is provided
    When I POST /v1/voice/token with agentId
    Then the response status is 400
    And the response indicates the RevenueCat key is required

  Scenario: Subscription is required in production
    Given the server is running in production mode
    And a RevenueCat public key is provided
    And the user does not have an active subscription
    When I POST /v1/voice/token with agentId
    Then the response indicates allowed: false

  Scenario: Missing ElevenLabs configuration prevents token issuance
    Given the ElevenLabs API key is not configured
    When I POST /v1/voice/token with agentId
    Then the response status is 400
    And the response indicates the server is missing the ElevenLabs key
