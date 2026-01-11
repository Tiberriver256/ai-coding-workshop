Feature: Azure Repos integration
  As a user
  I want to create pull requests on Azure Repos
  So that I can use Vibe Kanban with Azure DevOps

  Scenario: Create a PR on Azure Repos
    Given my repository is hosted on Azure Repos
    And the Azure CLI and DevOps extension are installed and authenticated
    When I click "Create PR" from a task attempt
    Then a pull request is created on Azure Repos
    And the task shows the PR status

  Scenario: Azure CLI not configured
    Given my repository is hosted on Azure Repos
    And the Azure CLI is not installed or authenticated
    When I attempt to create a PR
    Then I see instructions to install and authenticate the Azure CLI
