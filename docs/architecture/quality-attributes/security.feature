Feature: Security
  The system must protect user data and enforce secure remote access and integrations.

  Scenario: Service storage remains zero-knowledge
    Given an encrypted task payload and no wrapped data key
    When the service or an attacker attempts to decrypt stored data
    Then no plaintext content should be recovered

  Scenario: QR pairing responses are encrypted to the requester
    Given a pairing request with an ephemeral public key
    When a trusted device submits the pairing response
    Then the response should be encrypted for that key
    And intermediaries should not access plaintext credentials

  Scenario: Remote access requires scoped authentication
    Given a remote client without a valid scoped token
    When it attempts to open a control session
    Then the connection should be rejected
    And no control commands should be accepted

  Scenario: Sensitive agent actions require approval
    Given an agent action is marked as approval-required
    When approval is not granted before timeout
    Then the action should not execute
    And the audit trail should record the denial
