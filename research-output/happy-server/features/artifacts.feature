Feature: Artifact storage and synchronization
  As an authenticated client, I want to create, update, list, and delete encrypted artifacts.

  Background:
    Given I am an authenticated API client

  Scenario: Create a new artifact
    Given no artifact exists with id "artifact-001"
    When I POST /v1/artifacts with id, header, body, and dataEncryptionKey
    Then the response includes the created artifact and version numbers

  Scenario: Creating an existing artifact is idempotent for the same account
    Given an artifact with id "artifact-001" already exists for my account
    When I POST /v1/artifacts with id "artifact-001"
    Then the response returns the existing artifact

  Scenario: Artifact id conflict across accounts is rejected
    Given an artifact with id "artifact-001" exists for a different account
    When I POST /v1/artifacts with id "artifact-001"
    Then the response status is 409
    And the response contains a conflict error

  Scenario: List artifacts
    When I GET /v1/artifacts
    Then the response includes my artifacts with headers and metadata

  Scenario: Retrieve a single artifact
    Given an artifact exists with id "artifact-001"
    When I GET /v1/artifacts/artifact-001
    Then the response includes the artifact header and body

  Scenario: Update artifact header or body with version checks
    Given an artifact exists with header version 2 and body version 5
    When I POST /v1/artifacts/artifact-001 with updated header and expectedHeaderVersion 2
    Then the response indicates success and returns the new header version

  Scenario: Update is rejected when versions do not match
    Given an artifact exists with header version 2 and body version 5
    When I POST /v1/artifacts/artifact-001 with expectedHeaderVersion 1
    Then the response indicates version-mismatch
    And the response includes the current header version and data

  Scenario: Delete an artifact
    Given an artifact exists with id "artifact-001"
    When I DELETE /v1/artifacts/artifact-001
    Then the response indicates success

  Scenario: Read an artifact over WebSocket
    Given I am connected to the WebSocket at /v1/updates with a valid token
    When I emit "artifact-read" with artifactId "artifact-001"
    Then the acknowledgement returns the artifact details

  Scenario: Update an artifact over WebSocket
    Given I am connected to the WebSocket at /v1/updates with a valid token
    And an artifact exists with header version 2
    When I emit "artifact-update" with the header data and expectedVersion 2
    Then the acknowledgement result is "success"

  Scenario: Delete an artifact over WebSocket
    Given I am connected to the WebSocket at /v1/updates with a valid token
    And an artifact exists with id "artifact-001"
    When I emit "artifact-delete" with artifactId "artifact-001"
    Then the acknowledgement result is "success"
