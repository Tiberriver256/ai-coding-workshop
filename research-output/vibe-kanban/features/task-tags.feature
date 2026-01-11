Feature: Task tags (reusable snippets)
  As a user
  I want to manage task tags and insert them quickly
  So that I can reuse common task instructions

  Scenario: Create a task tag
    Given I am on the Settings page
    When I add a tag with a snake_case name and content
    Then the tag is saved and available for use

  Scenario: Edit a task tag
    Given a task tag exists
    When I update its name or content
    Then the updated tag is saved

  Scenario: Delete a task tag
    Given a task tag exists
    When I delete the tag
    Then the tag is removed from the list
    And existing tasks remain unchanged

  Scenario: Insert a task tag in a description
    Given a task tag exists
    When I type "@" in a task description
    And I select the tag from autocomplete
    Then the tag content is inserted at the cursor

  Scenario: Use task tags in follow-up messages
    Given a task tag exists
    When I type "@" in a follow-up message
    And I select the tag from autocomplete
    Then the tag content is inserted into the message

  Scenario: Invalid tag names are rejected
    Given I am creating a task tag
    When I enter a name with spaces
    Then I see a validation error
    And the tag is not saved
