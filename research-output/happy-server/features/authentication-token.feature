Feature: Signature-based authentication
  As an API client, I want to exchange a signed challenge for an access token so I can call protected endpoints.

  Scenario: Successful authentication returns a bearer token
    Given I have a public key and a matching private key
    And I sign the provided challenge with my private key
    When I POST /v1/auth with publicKey, challenge, and signature
    Then the response is successful
    And the response includes a non-empty token

  Scenario: Invalid signature is rejected
    Given I have a public key
    And I send a signature that does not match the challenge
    When I POST /v1/auth with the invalid signature
    Then the response status is 401
    And the response contains an "Invalid signature" error
