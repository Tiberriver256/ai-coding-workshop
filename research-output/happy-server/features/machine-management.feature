Feature: Machine registration and lookup
  As an authenticated client, I want to register and fetch machine records for device sync.

  Background:
    Given I am an authenticated API client

  Scenario: Register a new machine
    Given no machine exists with id "machine-001"
    When I POST /v1/machines with id, metadata, and optional daemonState
    Then the response includes the newly created machine record

  Scenario: Registering an existing machine returns the current record
    Given a machine already exists with id "machine-001"
    When I POST /v1/machines with id "machine-001" and metadata
    Then the response includes the existing machine and its versions

  Scenario: List machines
    When I GET /v1/machines
    Then the response includes all machines owned by my account

  Scenario: Get a machine by id
    Given a machine exists with id "machine-001"
    When I GET /v1/machines/machine-001
    Then the response includes the machine record

  Scenario: Get a missing machine returns not found
    Given no machine exists with id "machine-404"
    When I GET /v1/machines/machine-404
    Then the response status is 404
    And the response contains a "Machine not found" error
