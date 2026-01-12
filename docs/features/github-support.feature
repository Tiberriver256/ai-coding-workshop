Feature: GitHub support for pull requests
  As a user
  I want to create pull requests on GitHub
  So that I can merge agent changes through my normal workflow

  Background:
    Given my project repository is hosted on GitHub

  Scenario: Create a pull request from a task attempt (happy path)
    Given a task attempt has changes
    And the GitHub CLI is installed and authenticated
    When I click "Create PR"
    Then the PR title and description are prefilled from the task
    And I can select a base branch
    And a pull request is created on GitHub
    And the task shows the PR status

  Scenario: Missing GitHub CLI authentication prevents PR creation
    Given a task attempt has changes
    And the GitHub CLI is not installed or authenticated
    When I attempt to create a PR
    Then I see instructions to install and authenticate the GitHub CLI
    And the PR is not created

  Scenario: Target branch does not exist on remote
    Given I selected a base branch that does not exist on GitHub
    When I attempt to create a PR
    Then I see an error indicating the target branch is missing
