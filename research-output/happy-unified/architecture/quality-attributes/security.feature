Feature: Security
  To protect user content across devices
  As a security officer
  I want cross-component data flows to remain confidential and access-controlled

  Scenario: Server storage is zero-knowledge
    Given an encrypted session payload and no content data key
    When the server or an attacker attempts to decrypt stored blobs
    Then no plaintext content should be recovered

  Scenario: Real-time connections require authentication and scope validation
    Given a real-time connection attempt without a valid bearer token
    When the client attempts to open the update channel
    Then the server should reject the connection
    And no updates should be delivered

  Scenario: Device pairing responses are encrypted to the CLI public key
    Given a pairing request with an ephemeral public key
    When the mobile device submits its pairing response
    Then the response payload should be encrypted for that public key
    And intermediaries should not access the plaintext key material

