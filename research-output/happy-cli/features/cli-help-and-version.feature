Feature: View CLI help and version information
  Users can display Happy CLI usage details and version information from the command line.

  Scenario: Show Happy CLI help
    Given Happy CLI is installed
    When I run "happy --help"
    Then I see usage instructions and the list of Happy subcommands

  Scenario: Show Claude help when Claude CLI is available
    Given Happy CLI is installed
    And the Claude CLI is installed and available in my PATH
    When I run "happy --help"
    Then I see Happy help output
    And I also see the Claude CLI help output

  Scenario: Warn when Claude CLI help cannot be retrieved
    Given Happy CLI is installed
    And the Claude CLI is not installed or not available in my PATH
    When I run "happy --help"
    Then Happy warns that it could not retrieve Claude help

  Scenario: Show Happy CLI version
    Given Happy CLI is installed
    When I run "happy --version"
    Then I see the installed Happy CLI version
