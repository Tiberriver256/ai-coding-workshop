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
