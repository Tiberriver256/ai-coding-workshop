Feature: Git operations from a task attempt
  As a user
  I want to manage git operations from Vibe Kanban
  So that I can complete work without leaving the app

  Scenario: Merge changes into the target branch
    Given a task attempt has changes ready to merge
    When I click "Merge"
    Then the changes are merged into the target branch
    And the task moves to Done

  Scenario: Rebase onto the latest target branch
    Given my task branch is behind the target branch
    When I click "Rebase" and confirm the target branch
    Then my branch is updated with the latest target changes

  Scenario: Change the target branch
    Given I am viewing git actions for an attempt
    When I change the target branch
    Then subsequent merge and rebase actions use the new target branch

  Scenario: Rename the task branch
    Given I am viewing a task attempt
    When I edit the branch name
    Then the branch is renamed

  Scenario: Branch rename is blocked when a PR is open
    Given the task attempt has an open pull request
    When I attempt to rename the branch
    Then I am prevented from renaming the branch

  Scenario: View PR status and link
    Given a pull request exists for the attempt
    When I open git actions
    Then I can see the PR status and open it in the browser
