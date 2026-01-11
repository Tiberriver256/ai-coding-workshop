Feature: Receive push notifications from Happy CLI
  As a user
  I want to receive notifications from my computer on my phone
  So that I can stay informed when I am away

  Background:
    Given my computer is paired with my Happy mobile app
    And I have enabled notifications on my phone

  Scenario: Register the phone for notifications
    When I open the Happy mobile app
    Then my device is registered for push notifications

  Scenario: Send a notification from the CLI
    Given I am authenticated in the Happy CLI
    When I run "happy notify -p \"Deployment complete!\""
    Then a push notification is sent to my devices
    And I receive the notification on my phone

  Scenario: Send a notification with a custom title
    Given I am authenticated in the Happy CLI
    When I run "happy notify -t \"Server Status\" -p \"All systems healthy\""
    Then I receive a notification titled "Server Status" on my phone

  Scenario: Prevent notification when not authenticated
    Given I am not authenticated in the Happy CLI
    When I try to send a notification
    Then I am prompted to sign in
    And no notification is sent
