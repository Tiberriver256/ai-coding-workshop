Feature: Code review diff view
  As a user
  I want to inspect file changes in a diff view
  So that I can review agent work before merging

  Background:
    Given a task is in the In Review column

  Scenario: Open the diff view
    When I open the task and select the diff view
    Then I see the list of files changed
    And I can switch between inline and split view

  Scenario: Add line-specific comments
    Given I am viewing a file diff
    When I click the comment icon next to a line
    And I enter a comment
    Then the comment is added to my review
