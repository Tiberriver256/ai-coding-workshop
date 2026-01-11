Feature: Availability
  The system should provide continuous service via the daemon.

  Scenario: Single-instance daemon enforcement
    Given a daemon instance is already running
    When another daemon start is attempted
    Then the second instance exits without starting
    And the existing daemon continues to serve requests

  Scenario: Daemon restart on version mismatch
    Given the installed CLI version differs from the running daemon version
    When the daemon detects the mismatch
    Then it restarts within 60 seconds and reports the updated version in its state

  Scenario: Stale daemon state cleanup
    Given a daemon state file exists but the recorded PID is not running
    When the CLI checks daemon status
    Then the stale state is removed and a new daemon can be started
