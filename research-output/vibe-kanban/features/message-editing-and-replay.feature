Feature: Edit previous messages and replay
  As a user
  I want to edit a previous message in the conversation
  So that I can correct or refine instructions

  Scenario: Edit a previous message
    Given a task attempt has a conversation history
    When I edit a previous message and save
    Then the conversation rewinds to that point
    And the agent replays the conversation from the edited message

  Scenario: Editing warns about lost work
    Given I am editing a previous message
    When I review the warning about reverting later work
    Then I can decide to continue or cancel the edit
