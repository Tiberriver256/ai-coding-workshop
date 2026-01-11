Feature: Control a coding session from the mobile app
  As a user
  I want to control a coding session from my phone
  So that I can guide work without sitting at my computer

  Background:
    Given my computer is paired with my Happy mobile app
    And the Happy daemon is running on my computer

  Scenario: A session started on the computer appears on the phone
    When I start a new Happy session on my computer
    Then the session appears in the app's sessions list
    And the session shows as online

  Scenario: Send a message from the phone to the session
    Given I am viewing an active session on my phone
    When I send a message
    Then the message appears in the session chat
    And the agent responds in the same session
    And the response appears on my phone

  Scenario: Abort a running request from the phone
    Given the agent is working on a request in my session
    When I tap Abort on the phone
    Then the agent stops the current work
    And the session returns to an idle state

  Scenario: Approve a permission request from the phone
    Given a permission request appears in my session
    When I approve the request on my phone
    Then the agent proceeds with the requested action
    And the decision is reflected in the session history

  Scenario: Deny a permission request from the phone
    Given a permission request appears in my session
    When I deny the request on my phone
    Then the agent does not perform the requested action
    And the decision is reflected in the session history

  Scenario: Switch control back to the computer
    Given I am controlling the session from my phone
    When I choose to return control to the computer
    Then the session accepts input from the computer again
    And the phone shows that the session is in local control
