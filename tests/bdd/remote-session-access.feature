Feature: Remote access to coding sessions from mobile and web
  As a user
  I want to start and control sessions from my phone or the web app
  So that I can work remotely on my paired computer

  Background:
    Given my computer is paired to my account
    And the unified daemon is running on my computer

  Scenario: A session started on the computer appears remotely
    When I start a new session on my computer
    Then the session appears in the mobile app sessions list
    And the session appears in the web app sessions list
    And the session shows as online

  Scenario: Start a session in a chosen directory from the mobile app
    Given I am viewing my computer in the mobile app
    When I enter a project path
    And I start a new session
    Then a new session is created on my computer
    And the session opens on my phone

  Scenario: Start a session in a chosen directory from the web app
    Given I am viewing my computer in the web app
    When I enter a project path
    And I start a new session
    Then a new session is created on my computer
    And the session opens in the web app

  Scenario: Send a message from the mobile app to the session
    Given I am viewing an active session on my phone
    When I send a message
    Then the message appears in the session chat
    And the agent responds in the same session
    And the response appears on my phone

  Scenario: Abort a running request from the web app
    Given the agent is working on a request in my session
    When I click Abort in the web app
    Then the agent stops the current work
    And the session returns to an idle state

  Scenario: Approve a permission request remotely
    Given a permission request appears in my session
    When I approve the request in the mobile app
    Then the agent proceeds with the requested action
    And the decision is reflected in the session history

  Scenario: Daemon is offline when starting a session
    Given my computer is offline or the daemon is stopped
    When I try to start a session from the mobile app
    Then I see an error indicating the daemon is not running
    And no session is created
