Feature: Manage the Happy background daemon
  Users can start, stop, and inspect the background service that manages sessions.

  Scenario: Start the daemon in the background
    Given Happy CLI is installed
    When I run "happy daemon start"
    Then the daemon starts in the background
    And I see a success message if it starts within a few seconds

  Scenario: Fail to start the daemon
    Given Happy CLI is installed
    When I run "happy daemon start"
    And the daemon does not start successfully
    Then I see a failure message

  Scenario: Stop the daemon
    Given the Happy daemon is running
    When I run "happy daemon stop"
    Then the daemon stops

  Scenario: Check daemon status
    Given Happy CLI is installed
    When I run "happy daemon status"
    Then I see whether the daemon is running
    And I see daemon state details when available

  Scenario: List active sessions known to the daemon
    Given the Happy daemon is running
    When I run "happy daemon list"
    Then I see a list of active sessions

  Scenario: Handle daemon list when no daemon is running
    Given the Happy daemon is not running
    When I run "happy daemon list"
    Then I see a message that no daemon is running

  Scenario: Stop a specific daemon session
    Given the Happy daemon is running
    And a session with ID "SESSION_ID" exists
    When I run "happy daemon stop-session SESSION_ID"
    Then the session is stopped

  Scenario: Require a session ID for stop-session
    Given Happy CLI is installed
    When I run "happy daemon stop-session"
    Then I see an error that a session ID is required

  Scenario: Show the latest daemon log file path
    Given Happy CLI is installed
    When I run "happy daemon logs"
    Then I see the path to the most recent daemon log file
    Or I see a message that no daemon logs were found

  Scenario: Install the daemon as a system service on macOS
    Given I am running on macOS
    And I have sudo privileges
    When I run "sudo happy daemon install"
    Then the daemon is installed as a system service

  Scenario: Reject daemon installation on unsupported platforms
    Given I am running on a non-macOS system
    When I run "happy daemon install"
    Then I see an error stating installation is only supported on macOS

  Scenario: Uninstall the daemon as a system service on macOS
    Given I am running on macOS
    And I have sudo privileges
    When I run "sudo happy daemon uninstall"
    Then the daemon service is removed

  Scenario: Require sudo privileges for daemon install/uninstall
    Given I am running on macOS
    And I do not have sudo privileges
    When I run "happy daemon install"
    Then I see an error that sudo privileges are required
    When I run "happy daemon uninstall"
    Then I see an error that sudo privileges are required
