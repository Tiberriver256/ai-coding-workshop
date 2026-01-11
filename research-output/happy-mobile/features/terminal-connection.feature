Feature: Approve a terminal connection
  As a user
  I want to approve or reject a terminal connection request
  So that I control which computer can connect to my account

  Scenario: Scan a QR code to connect a terminal
    Given I am signed in
    And I am on Settings
    When I tap "Scan QR Code to Authenticate"
    Then the app opens the scanner
    And the app waits for a terminal connection request

  Scenario: Paste a connection URL manually
    Given I am signed in
    And I am on Settings
    When I choose to enter a URL manually
    And I paste a valid connection link
    Then the app shows a connection approval screen

  Scenario: Approve a connection request
    Given I opened a valid connection link
    When I tap "Accept Connection"
    Then the terminal is connected
    And I return to the previous screen

  Scenario: Reject a connection request
    Given I opened a valid connection link
    When I tap "Reject"
    Then the connection is denied
    And I return to the previous screen

  Scenario: Invalid connection link
    Given I open a connection link without a valid key
    Then I see an invalid connection message
    And I cannot approve the connection
