Feature: Pair a computer with the Happy mobile app
  As a user
  I want to pair my computer with the Happy mobile app
  So that I can control coding sessions from my phone

  Background:
    Given I am signed in on the Happy mobile app
    And Happy CLI is installed on my computer

  Scenario: Pair using a QR code
    When I run "happy auth login" on my computer
    And I choose the mobile authentication method
    Then Happy shows a QR code and a connection link
    When I scan the QR code in the Happy mobile app
    And I approve the connection request
    Then the computer is paired to my account
    And the computer appears in the app's machine list

  Scenario: Pair using a manual connection link
    When I run "happy auth login" on my computer
    And I copy the connection link
    And I paste the link into the Happy mobile app
    And I approve the connection request
    Then the computer is paired to my account
    And the computer appears in the app's machine list

  Scenario: Reject a pairing request
    When I open a valid connection link in the Happy mobile app
    And I reject the connection request
    Then the computer is not paired to my account
    And the CLI shows that the request was rejected

  Scenario: Handle an invalid connection link
    When I open an invalid connection link in the Happy mobile app
    Then I see an invalid link message
    And I cannot approve the connection

  Scenario: Re-pair a computer after forcing re-authentication
    Given my computer is already paired
    When I run "happy auth login --force" on my computer
    And I approve the new connection request on my phone
    Then the computer is re-paired
    And the app shows the updated pairing status
