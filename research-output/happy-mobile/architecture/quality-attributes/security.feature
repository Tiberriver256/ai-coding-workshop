Feature: Security
  To protect user data and credentials
  As a security officer
  I want client data to remain confidential and access-controlled

  Scenario: Encrypted content cannot be decrypted without keys
    Given a ciphertext message and no session data key
    When a decryption attempt is made
    Then the operation should fail and return no plaintext

  Scenario: Encrypted transport payloads
    Given a known plaintext test message "HELLO-SECRET" in a session
    When the message is transmitted over the update channel
    Then the payload should not contain the plaintext string

  Scenario: Secure credential storage
    Given valid authentication credentials
    When the client stores the credentials locally
    Then the credentials should be stored in a secure, OS-backed storage mechanism
    And the credentials should never be written to application logs
