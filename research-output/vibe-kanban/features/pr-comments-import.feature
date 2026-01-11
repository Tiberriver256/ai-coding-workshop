Feature: Import pull request comments
  As a user
  I want to import PR comments into Vibe Kanban
  So that I can address external feedback

  Scenario: Select PR comments to include
    Given a task attempt has a linked pull request
    When I open the PR comments dialog
    And I select one or more comments
    Then the selected comments are added to my feedback

  Scenario: Select all and deselect all
    Given multiple PR comments are available
    When I choose "Select All"
    Then all comments are selected
    When I choose "Deselect All"
    Then no comments are selected

  Scenario: No PR comments found
    Given a pull request has no comments
    When I open the PR comments dialog
    Then I see a message indicating there are no comments to import
