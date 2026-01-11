Feature: Send push notifications to devices
  Users can send notifications from the CLI to their connected Happy devices.

  Scenario: Send a notification with the default title
    Given I am authenticated with Happy
    When I run "happy notify -p \"Deployment complete!\""
    Then Happy sends a push notification to all my devices
    And the notification title is "Happy"
    And the notification message is "Deployment complete!"

  Scenario: Send a notification with a custom title
    Given I am authenticated with Happy
    When I run "happy notify -t \"Server Status\" -p \"All systems healthy\""
    Then Happy sends a push notification to all my devices
    And the notification title is "Server Status"
    And the notification message is "All systems healthy"

  Scenario: Require a message parameter
    Given I am authenticated with Happy
    When I run "happy notify -t \"Alert\""
    Then Happy shows an error that a message is required
    And the notification is not sent

  Scenario: Reject unknown notify arguments
    Given I am authenticated with Happy
    When I run "happy notify --unknown"
    Then Happy shows an error about the unknown argument

  Scenario: Prevent notification when not authenticated
    Given I am not authenticated with Happy
    When I run "happy notify -p \"Hello\""
    Then Happy tells me to run "happy auth login" first
    And the notification is not sent

  Scenario: Show notify help
    Given Happy CLI is installed
    When I run "happy notify --help"
    Then I see usage instructions for sending notifications
