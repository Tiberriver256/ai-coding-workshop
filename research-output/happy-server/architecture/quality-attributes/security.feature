Feature: Security and privacy guarantees

  Scenario: Requests without authentication are rejected
    Given a client request without an authentication token
    When the request targets a protected API
    Then the response status should be 401

  Scenario: Invalid cryptographic proof cannot create a session
    Given a client submits an invalid signature for an authentication challenge
    When the authentication request is processed
    Then no account should be created
    And the response status should be 401

  Scenario: Encrypted payloads remain opaque to the server
    Given a client sends an encrypted message payload
    When the payload is stored and later retrieved
    Then the retrieved payload should match the original ciphertext
    And the server should not return plaintext content

  Scenario: Secrets stored by the server are encrypted at rest
    Given a client registers a vendor access token
    When the token is stored in the database
    Then the stored value should not equal the plaintext token
