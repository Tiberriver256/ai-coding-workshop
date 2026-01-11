Feature: Create and update pull requests
  As a user
  I want to create and update pull requests from Vibe Kanban
  So that I can integrate changes with my git host

  Scenario: Create a pull request with prefilled details
    Given a task attempt has changes
    When I click "Create PR"
    Then the PR title and description are prefilled from the task
    And I can select a base branch
    And a pull request is created

  Scenario: Create a draft pull request
    Given I am creating a PR
    When I mark the PR as draft
    Then the PR is created in draft mode

  Scenario: Auto-generate the PR description
    Given I am creating a PR
    When I enable "Auto-generate PR description"
    Then the agent generates and updates the PR title and description

  Scenario: Push updates to an existing PR
    Given a PR already exists for the task attempt
    And I make additional changes
    When I click "Push"
    Then the latest changes are pushed to the PR

  Scenario: Missing CLI authentication prevents PR creation
    Given the git host CLI is not installed or authenticated
    When I attempt to create a PR
    Then I see a setup prompt or error message
    And the PR is not created

  Scenario: Target branch does not exist on remote
    Given I selected a base branch that does not exist remotely
    When I attempt to create a PR
    Then I see an error indicating the target branch is missing
