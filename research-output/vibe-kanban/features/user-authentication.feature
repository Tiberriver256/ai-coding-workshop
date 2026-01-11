Feature: User authentication
  As a user
  I want to sign in and sign out
  So that I can access organization features and shared tasks

  Scenario: Sign in with a supported provider
    Given I am signed out
    When I choose to sign in with GitHub or Google
    And I complete the provider login flow
    Then I see a confirmation that authentication succeeded
    And my account is connected in Vibe Kanban

  Scenario: Authentication fails
    Given I am attempting to sign in
    When the provider returns an error
    Then I see an authentication failed message
    And I can retry the sign-in flow

  Scenario: Sign out
    Given I am signed in
    When I choose "Sign out"
    Then I am signed out of Vibe Kanban
    And organization-only actions are no longer available
