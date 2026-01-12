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
