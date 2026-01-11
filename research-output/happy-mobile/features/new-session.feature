Feature: Start a new session
  As a user
  I want to start a new session on a selected machine and path
  So that I can run a coding agent from my phone

  Scenario: Start a new session successfully
    Given I am signed in
    When I open the New Session screen
    And I enter a prompt
    And I select a machine
    And I select a project path
    And I tap Send
    Then a new session is created
    And I am taken to that session

  Scenario: Choose an agent type
    Given I am on the New Session screen
    When I tap the agent selector
    Then the agent cycles between available providers

  Scenario: Set a permission mode before starting
    Given I am on the New Session screen
    When I select a permission mode
    Then the mode is saved for the new session

  Scenario: Missing machine selection
    Given I am on the New Session screen
    And no machine is selected
    When I tap Send
    Then I see an error telling me to select a machine
    And the session is not created

  Scenario: Missing path selection
    Given I am on the New Session screen
    And no path is selected
    When I tap Send
    Then I see an error telling me to select a path
    And the session is not created

  Scenario: Worktree session creation (experiments enabled)
    Given experimental features are enabled
    And I am on the New Session screen
    When I choose the Worktree session type
    And I tap Send
    Then the app creates a worktree if possible
    And the session starts in that worktree

  Scenario: Session start fails
    Given I am on the New Session screen
    When I tap Send
    And the session cannot be started
    Then I see a failure message with guidance
    And I remain on the New Session screen
