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

  Scenario: Azure CLI not configured
    Given a task attempt has changes
    And the Azure CLI is not installed or authenticated
    When I attempt to create a PR
    Then I see instructions to install and authenticate the Azure CLI
    And the Azure DevOps PR is not created

  Scenario: Repository is not an Azure Repos project
    Given my project is not hosted on Azure Repos
    When I attempt to create a PR with Azure DevOps
    Then I see a message that the repository is unsupported
    And the Azure DevOps PR is not created
