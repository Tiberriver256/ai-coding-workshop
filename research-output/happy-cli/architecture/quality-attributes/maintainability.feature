Feature: Maintainability
  The system should be easy to extend and safely evolve.

  Scenario: Add a new agent backend
    Given a new backend implements the common agent interface and is registered
    When the CLI starts a session for that agent
    Then session start, message streaming, and permission flow operate without modifying core orchestration

  Scenario: Extend RPC capabilities
    Given a new RPC handler is registered for a session scope
    When the client reconnects after a disconnect
    Then the handler is re-registered and available for remote invocation

  Scenario: Log isolation for interactive sessions
    Given an interactive session is running
    When debug logging occurs during agent output
    Then logs are written to file and do not appear on standard output
