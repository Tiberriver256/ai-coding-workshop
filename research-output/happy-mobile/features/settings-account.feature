Feature: Manage account settings
  As a user
  I want to manage my account and privacy settings
  So that I can secure and control my data

  Scenario: View account status and IDs
    Given I am signed in
    When I open Account Settings
    Then I see my account status
    And I can copy my anonymous and public IDs

  Scenario: Link a new device from Account Settings
    Given I am on Account Settings
    When I tap "Link New Device"
    Then the app starts the device linking flow

  Scenario: Reveal and copy secret key
    Given I am on Account Settings
    When I tap "Secret Key" to reveal it
    Then I see my formatted secret key
    And I can tap to copy it

  Scenario: Toggle analytics opt-out
    Given I am on Account Settings
    When I disable analytics
    Then analytics collection is turned off

  Scenario: Disconnect a connected account
    Given I am on Account Settings
    And a connected account is listed
    When I tap to disconnect and confirm
    Then the account is disconnected

  Scenario: Log out
    Given I am on Account Settings
    When I tap "Log Out" and confirm
    Then I am signed out
    And I return to the welcome screen
