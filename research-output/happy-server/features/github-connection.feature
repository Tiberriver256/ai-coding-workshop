Feature: GitHub account connection
  As an authenticated client, I want to connect and disconnect a GitHub account using OAuth.

  Background:
    Given I am an authenticated API client

  Scenario: Request GitHub OAuth parameters
    When I GET /v1/connect/github/params
    Then the response includes a GitHub authorization URL

  Scenario: OAuth params fail when GitHub is not configured
    Given GitHub OAuth is not configured on the server
    When I GET /v1/connect/github/params
    Then the response status is 400
    And the response contains a configuration error

  Scenario: OAuth callback with invalid state redirects with an error
    When GitHub redirects to /v1/connect/github/callback with an invalid state
    Then the client is redirected to the app with an error indicator

  Scenario: OAuth callback with valid code connects the account
    When GitHub redirects to /v1/connect/github/callback with a valid code and state
    Then the client is redirected to the app with a connected indicator

  Scenario: GitHub webhook is accepted when signature is valid
    When GitHub POSTs /v1/connect/github/webhook with a valid signature and payload
    Then the response confirms the webhook was received

  Scenario: GitHub webhook fails when the signature is invalid
    When GitHub POSTs /v1/connect/github/webhook with an invalid signature
    Then the response indicates an error

  Scenario: Disconnect a GitHub account
    When I DELETE /v1/connect/github
    Then the response indicates success
