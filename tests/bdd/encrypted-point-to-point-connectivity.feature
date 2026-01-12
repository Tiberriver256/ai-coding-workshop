Feature: Encrypted point-to-point connectivity between paired devices
  As a user
  I want session data to be encrypted end-to-end
  So that only my paired devices can read it

  Background:
    Given my computer is paired with my mobile app

  Scenario: Session messages are readable only on paired devices
    When I send a message in a session from my phone
    Then the message is readable on my paired computer
    And the message is not readable on unpaired devices

  Scenario: New devices require a recovery secret to decrypt data
    Given I install the mobile app on a new phone
    When I restore my account with my recovery secret or recovery QR
    Then the new phone can read my encrypted sessions
    And without the recovery secret the phone cannot read my encrypted data

  Scenario: Logging out removes access to encrypted data on that device
    Given my computer is paired
    When I log out of the unified CLI on that computer
    Then the computer can no longer access my encrypted session data
    And I must re-pair to regain access
