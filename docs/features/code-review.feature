Feature: Review code changes produced by agents
  As a user
  I want to review diffs and send feedback
  So that I can guide the agent before merging

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

  Scenario: Submit review feedback
    Given I have added one or more review comments
    When I click Send
    Then all comments are sent together to the agent
    And the task returns to In Progress
    And review evidence is recorded

  Scenario: No code changes yet
    Given a task attempt has produced no diffs
    When I open the diff view
    Then I see a message indicating no changes are available
