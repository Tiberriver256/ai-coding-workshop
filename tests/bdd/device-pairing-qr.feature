Feature: Pair a computer using QR onboarding
  As a user
  I want to pair my computer with the mobile app using a QR code
  So that I can securely enable remote access

  Background:
    Given I am signed in on the mobile app
    And the unified CLI is installed on my computer

  Scenario: Pair using a QR code (happy path)
    When I run "unified auth login" on my computer
    And I choose the mobile QR pairing option
    Then the CLI shows a QR code and a fallback connection link
    When I scan the QR code in the mobile app
    And I approve the pairing request
    Then the computer is paired to my account
    And the computer appears in the app's device list

  Scenario: Pair using a manual connection link
    When I run "unified auth login" on my computer
    And I copy the connection link
    And I paste the link into the mobile app
    And I approve the pairing request
    Then the computer is paired to my account
    And the computer appears in the app's device list

  Scenario: Reject a pairing request
    When I open a valid connection link in the mobile app
    And I reject the pairing request
    Then the computer is not paired to my account
    And the CLI shows that the request was rejected
