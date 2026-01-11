Feature: External model provider tokens
  As an authenticated client, I want to store and retrieve tokens for supported AI vendors.

  Background:
    Given I am an authenticated API client
    And the vendor is one of "openai", "anthropic", or "gemini"

  Scenario: Register a vendor token
    When I POST /v1/connect/{vendor}/register with a token
    Then the response indicates success

  Scenario: Retrieve a vendor token
    Given I have previously registered a token for {vendor}
    When I GET /v1/connect/{vendor}/token
    Then the response includes the token

  Scenario: Retrieve a vendor token when none is registered
    Given I have not registered a token for {vendor}
    When I GET /v1/connect/{vendor}/token
    Then the response includes token: null

  Scenario: Delete a vendor token
    Given I have previously registered a token for {vendor}
    When I DELETE /v1/connect/{vendor}
    Then the response indicates success

  Scenario: List all stored vendor tokens
    When I GET /v1/connect/tokens
    Then the response includes all vendor tokens for my account
