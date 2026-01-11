Feature: Maintainability
  To evolve protocols without breaking clients
  As a system maintainer
  I want versioned payloads and scoped contracts

  Scenario: Versioned encryption payloads allow migration
    Given a client that supports a newer encryption version
    When it encounters an older versioned key bundle
    Then it should fall back to legacy decryption
    And continue to interoperate with older devices

  Scenario: Scoped protocols reduce coupling
    Given a machine-scoped connection
    When session updates are emitted
    Then the client should ignore session-specific RPC methods not in its scope

