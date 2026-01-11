Feature: Start a Claude session with Happy
  Happy starts a Claude Code session that can be controlled from a mobile device.
  It also auto-starts the background daemon when needed and forwards Claude CLI flags.

  Scenario: Start a session when already authenticated
    Given I am authenticated with Happy
    And the Claude CLI is installed and available in my PATH
    When I run "happy"
    Then a Claude session starts from my current working directory
    And Happy connects the session to the Happy service for remote control

  Scenario: Automatically start the daemon when it is not running
    Given I am authenticated with Happy
    And the Happy daemon is not running
    When I run "happy"
    Then Happy starts the daemon in the background
    And the Claude session starts successfully

  Scenario: Prompt for authentication when credentials are missing
    Given I am not authenticated with Happy
    When I run "happy"
    Then Happy starts the authentication flow before starting the session

  Scenario: Pass through standard Claude options
    Given I am authenticated with Happy
    And the Claude CLI is installed and available in my PATH
    When I run "happy --resume"
    Then Happy forwards the "--resume" option to Claude
    And the session resumes using Claude's own behavior

  Scenario: Use the yolo alias to bypass Claude permissions
    Given I am authenticated with Happy
    When I run "happy --yolo"
    Then Happy forwards "--dangerously-skip-permissions" to Claude

  Scenario: Provide a custom environment variable for Claude
    Given I am authenticated with Happy
    When I run "happy --claude-env ANTHROPIC_BASE_URL=http://127.0.0.1:3456"
    Then Happy passes the environment variable to the Claude process

  Scenario: Reject an invalid --claude-env format
    Given I am authenticated with Happy
    When I run "happy --claude-env NOT_A_KEY_VALUE"
    Then Happy shows an error explaining the required KEY=VALUE format
    And the session does not start
