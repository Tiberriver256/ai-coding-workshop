Feature: Azure DevOps support for pull requests
  As a user
  I want to create pull requests on Azure DevOps
  So that I can use the product with Azure Repos

  Background:
    Given my project repository is hosted on Azure Repos

  Scenario: Create a pull request on Azure DevOps (happy path)
    Given a task attempt has changes
    And the Azure CLI and DevOps extension are installed and authenticated
    When I click "Create PR"
    Then a pull request is created on Azure DevOps
    And the task shows the PR status
