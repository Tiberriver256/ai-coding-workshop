Feature: Run diagnostics and cleanup
  Users can diagnose configuration issues and clean up runaway processes.

  Scenario: Run full diagnostics
    Given Happy CLI is installed
    When I run "happy doctor"
    Then I see basic system and version information
    And I see Happy configuration and authentication status
    And I see daemon status and any related processes
    And I see a list of recent log files when available

  Scenario: Run daemon-only diagnostics
    Given Happy CLI is installed
    When I run "happy daemon status"
    Then I see daemon status details without the full system report

  Scenario: Clean up runaway Happy processes
    Given Happy CLI is installed
    And there are runaway Happy processes on my machine
    When I run "happy doctor clean"
    Then Happy terminates the runaway processes
    And I see how many processes were cleaned up

  Scenario: Clean command reports errors it cannot fix
    Given Happy CLI is installed
    And at least one runaway process cannot be terminated
    When I run "happy doctor clean"
    Then I see an error message for each process that could not be killed
