Feature: Codex CLI support for remote sessions
  As a user
  I want to start Codex CLI sessions through the product
  So that I can use Codex with remote access and orchestration

  Background:
    Given the unified CLI is installed on my computer

  Scenario: Start Codex mode when authenticated
    Given I am authenticated with the product
    When I run "unified codex"
    Then a Codex session starts
    And the session is connected for remote access
