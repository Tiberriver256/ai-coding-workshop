Feature: Notifications
  As a user
  I want to control notification settings
  So that I am alerted when tasks finish

  Scenario: Enable sound notifications and select a sound
    Given I am on the Settings page
    When I enable sound notifications and choose a sound
    Then Vibe Kanban plays the selected sound when a task attempt finishes

  Scenario: Enable push notifications
    Given I am on the Settings page
    When I enable push notifications
    Then Vibe Kanban shows system notifications when task attempts finish

  Scenario: Disable notifications
    Given I am on the Settings page
    When I disable sound and push notifications
    Then no completion sounds or system notifications are shown
