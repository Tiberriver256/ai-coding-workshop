Feature: Remote session access
  As a user
  I want sessions started on my computer to appear remotely
  So that I can pick them up on mobile or the web

  Background:
    Given my computer is paired to my account

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
