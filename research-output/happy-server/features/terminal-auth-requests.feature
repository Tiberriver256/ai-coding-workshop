Feature: Terminal authentication requests
  As a client app, I want to request terminal authorization and poll its status so I can receive a token when the user approves.

  Scenario: Submit a terminal auth request
    Given I have a valid terminal public key
    When I POST /v1/auth/request with the publicKey and supportsV2 flag
    Then the response state is "requested"

  Scenario: Request is rejected when the public key is invalid
    Given I have an invalid terminal public key
    When I POST /v1/auth/request with the invalid publicKey
    Then the response status is 401
    And the response contains an "Invalid public key" error

  Scenario: Polling returns pending status for an unapproved request
    Given I have a valid terminal public key with a pending request
    When I GET /v1/auth/request/status with the publicKey
    Then the response status is "pending"
    And the response indicates whether the request supports V2

  Scenario: Polling returns not_found for an unknown or invalid public key
    Given I have a public key with no request on record
    When I GET /v1/auth/request/status with the publicKey
    Then the response status is "not_found"
    And the response supportsV2 is false

  Scenario: Approved terminal request returns a token and response payload
    Given a terminal auth request has been approved by a signed-in user
    When I POST /v1/auth/request with the same publicKey
    Then the response state is "authorized"
    And the response includes a token and response payload

  Scenario: User approves a terminal auth request
    Given I am an authenticated API client
    And a terminal auth request exists for a public key
    When I POST /v1/auth/response with the publicKey and response
    Then the response indicates success

  Scenario: Approving a missing request fails
    Given I am an authenticated API client
    And no terminal auth request exists for the publicKey
    When I POST /v1/auth/response with the publicKey and response
    Then the response status is 404
    And the response contains a "Request not found" error
