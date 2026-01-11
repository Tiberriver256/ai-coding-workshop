Feature: Connect AI vendor API keys to Happy
  Users can securely link their AI vendor accounts so Happy can access them.

  Scenario: Show connect help
    Given Happy CLI is installed
    When I run "happy connect --help"
    Then I see usage instructions for connecting Codex, Claude, and Gemini
    And I see that authentication with Happy is required first

  Scenario Outline: Connect a vendor account
    Given I am authenticated with Happy
    When I run "happy connect <vendor>"
    Then Happy opens a browser-based authentication flow for <vendor>
    And Happy registers my <vendor> token in the Happy cloud
    And I see a success confirmation

    Examples:
      | vendor |
      | codex  |
      | claude |
      | gemini |

  Scenario: Reject connection when not authenticated with Happy
    Given I am not authenticated with Happy
    When I run "happy connect codex"
    Then Happy tells me to run "happy auth login" first
    And the connection does not proceed

  Scenario: Reject an unknown vendor name
    Given I am authenticated with Happy
    When I run "happy connect unknown"
    Then Happy shows an error about the unknown connect target
    And I see the connect help message
