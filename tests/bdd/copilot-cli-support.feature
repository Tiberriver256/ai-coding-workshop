Feature: Copilot CLI support for command and prompt suggestions
  As a user
  I want to use Copilot CLI as an assistant
  So that I can get autocomplete suggestions while working on tasks

  Background:
    Given I am signed in to the product

  Scenario: Enable Copilot CLI integration (happy path)
    Given Copilot CLI is installed and authenticated
    When I enable Copilot CLI in Settings
    Then Copilot CLI is available as an assistant
    And I can select it for task prompt autocomplete

  Scenario: Use Copilot CLI to autocomplete a task prompt
    Given Copilot CLI is enabled
    When I request autocomplete while writing a task description
    Then I see Copilot suggestions
    And I can insert a suggestion into the task description
