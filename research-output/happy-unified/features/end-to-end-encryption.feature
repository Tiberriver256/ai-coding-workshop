Feature: End-to-end encrypted collaboration across devices
  As a user
  I want my session data to be end-to-end encrypted
  So that only my paired devices can read it

  Background:
    Given my computer and phone are paired in Happy

  Scenario: Session messages are readable only on paired devices
    When I send a message in a session from my phone
    Then the message is readable on my paired computer
    And the message is not readable to unpaired devices

  Scenario: New devices require my recovery secret to access data
    Given I install Happy on a new phone
    When I restore my account with my secret key or recovery QR code
    Then the new phone can read my sessions
    And without the recovery secret the phone cannot read my encrypted data

  Scenario: Logging out removes access to encrypted data on that device
    Given my computer is paired
    When I log out of Happy CLI on that computer
    Then the computer can no longer access my encrypted session data
    And I must re-pair to regain access
