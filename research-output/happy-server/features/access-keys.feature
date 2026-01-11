Feature: Session-machine access keys
  As an authenticated client, I want to store and retrieve per-session access keys for machines.

  Background:
    Given I am an authenticated API client

  Scenario: Read an access key when none exists
    Given I own session {sessionId} and machine {machineId}
    When I GET /v1/access-keys/{sessionId}/{machineId}
    Then the response contains accessKey: null

  Scenario: Create an access key
    Given I own session {sessionId} and machine {machineId}
    When I POST /v1/access-keys/{sessionId}/{machineId} with data
    Then the response indicates success
    And the accessKey version is 1

  Scenario: Creating a duplicate access key fails
    Given an access key already exists for session {sessionId} and machine {machineId}
    When I POST /v1/access-keys/{sessionId}/{machineId} with data
    Then the response status is 409
    And the response contains an "Access key already exists" error

  Scenario: Update an access key with the expected version
    Given an access key exists with version 3
    When I PUT /v1/access-keys/{sessionId}/{machineId} with data and expectedVersion 3
    Then the response indicates success
    And the response returns version 4

  Scenario: Update fails on version mismatch
    Given an access key exists with version 3
    When I PUT /v1/access-keys/{sessionId}/{machineId} with expectedVersion 2
    Then the response indicates a version-mismatch
    And the response includes the current version and data

  Scenario: Retrieve an access key over WebSocket
    Given I am connected to the WebSocket at /v1/updates with a valid token
    When I emit "access-key-get" with sessionId and machineId
    Then the acknowledgement returns the access key data or null
