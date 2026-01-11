Feature: Account settings with optimistic concurrency
  As an authenticated client, I want to read and update account settings with version checks so I do not overwrite newer changes.

  Background:
    Given I am an authenticated API client

  Scenario: Read account settings
    When I GET /v1/account/settings
    Then the response includes settings and settingsVersion

  Scenario: Update settings with the expected version
    Given I know the current settingsVersion
    When I POST /v1/account/settings with settings and expectedVersion
    Then the response indicates success
    And the response includes the next version number

  Scenario: Update fails when the version is stale
    Given I have an outdated expectedVersion
    When I POST /v1/account/settings with settings and the stale expectedVersion
    Then the response indicates a version-mismatch
    And the response includes the current version and settings
