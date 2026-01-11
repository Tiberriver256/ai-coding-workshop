Feature: Component selection via web companion
  As a user
  I want to select UI components in preview mode
  So that I can give precise feedback to the agent

  Scenario: Install the web companion automatically
    Given I am in Preview mode
    When I click "Install companion automatically"
    Then a task is created to install the web companion package

  Scenario: Select a component in preview
    Given the web companion is installed
    And a preview is running
    When I activate selection mode and click a UI element
    Then Vibe Kanban shows component depth options
    And I can choose the correct component level

  Scenario: Send targeted feedback for a selected component
    Given I selected a component in preview
    When I send a follow-up message
    Then the agent receives the exact component context and selector info

  Scenario: Companion not installed
    Given the web companion is not installed
    When I try to use click-to-edit selection
    Then I see guidance to install the companion first
