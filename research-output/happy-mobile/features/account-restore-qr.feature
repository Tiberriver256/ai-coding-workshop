Feature: Restore or link an account using a QR code
  As a user with an existing account
  I want to scan a QR code to link my device
  So that I can access my account securely

  Scenario: Show QR code for linking
    Given I open the restore screen
    When the app is ready to link my device
    Then I see a QR code to scan
    And I see instructions that tell me how to scan it from my other device

  Scenario: Successful QR link
    Given I am on the restore screen
    And a QR code is displayed
    When my other device scans the QR code and approves the link
    Then I am signed in on this device
    And I return to the previous screen

  Scenario: QR link fails
    Given I am on the restore screen
    When the link attempt fails
    Then I see an authentication failed message
    And I can try again

  Scenario: Choose secret key instead
    Given I am on the restore screen
    When I tap "Restore with Secret Key Instead"
    Then I am taken to the secret key restore screen
