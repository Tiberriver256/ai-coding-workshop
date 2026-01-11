Feature: File mentions in task text
  As a user
  I want to mention files from the project in task text
  So that agents can locate the right files quickly

  Scenario: Insert a file reference with @ autocomplete
    Given I am editing a task description or follow-up message
    When I type "@" and search for a file
    And I select a file from the list
    Then the file name is inserted inline
    And the full file path is added to the text for reference

  Scenario: No matching files or tags
    Given I am using the @ autocomplete
    When there are no matching results
    Then I see a "no results" message

  Scenario: Prevent duplicate file path entries
    Given I already inserted a file path in the text
    When I insert the same file again
    Then the file path is not duplicated in the document
