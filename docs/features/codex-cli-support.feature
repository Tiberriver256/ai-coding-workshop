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

  Scenario: Prompt for authentication before starting Codex
    Given I am not authenticated with the product
    When I run "unified codex"
    Then the product starts the authentication flow
    And the Codex session starts after authentication completes

  Scenario: Codex CLI is not installed locally
    Given I am authenticated with the product
    And Codex CLI is not installed
    When I run "unified codex"
    Then I see an error indicating Codex CLI is required
    And the session does not start
