Feature: Real-time machine updates
  As an authenticated client, I want to send machine heartbeats and update machine metadata/state over WebSocket.

  Background:
    Given I am connected to the WebSocket at /v1/updates with a valid token

  Scenario: Send a machine heartbeat
    Given I own machine {machineId}
    When I emit "machine-alive" with machineId and a recent timestamp
    Then the server marks the machine as active

  Scenario: Update machine metadata with version control
    Given I know the current machine metadata version
    When I emit "machine-update-metadata" with machineId, metadata, and expectedVersion
    Then the acknowledgement result is "success"
    And the acknowledgement includes the new metadata version

  Scenario: Machine metadata update fails on version mismatch
    Given the machine metadata version has advanced
    When I emit "machine-update-metadata" with a stale expectedVersion
    Then the acknowledgement result is "version-mismatch"
    And the acknowledgement includes the current metadata and version

  Scenario: Update machine daemon state with version control
    Given I know the current machine daemon state version
    When I emit "machine-update-state" with machineId, daemonState, and expectedVersion
    Then the acknowledgement result is "success"
    And the acknowledgement includes the new daemon state version
