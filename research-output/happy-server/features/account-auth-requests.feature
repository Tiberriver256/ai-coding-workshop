Feature: Account authentication requests
  As a client app, I want to request account authorization and receive a token when the user approves.

  Scenario: Submit an account auth request
    Given I have a valid account public key
    When I POST /v1/auth/account/request with the publicKey
    Then the response state is "requested"

  Scenario: Request is rejected when the public key is invalid
    Given I have an invalid account public key
    When I POST /v1/auth/account/request with the invalid publicKey
    Then the response status is 401
    And the response contains an "Invalid public key" error

  Scenario: Approved account request returns a token and response payload
    Given an account auth request has been approved by a signed-in user
    When I POST /v1/auth/account/request with the same publicKey
    Then the response state is "authorized"
    And the response includes a token and response payload

  Scenario: User approves an account auth request
    Given I am an authenticated API client
    And an account auth request exists for a public key
    When I POST /v1/auth/account/response with the publicKey and response
    Then the response indicates success

  Scenario: Approving a missing account request fails
    Given I am an authenticated API client
    And no account auth request exists for the publicKey
    When I POST /v1/auth/account/response with the publicKey and response
    Then the response status is 404
    And the response contains a "Request not found" error
