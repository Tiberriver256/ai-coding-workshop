Feature: Security
  The system should protect data confidentiality and enforce safe execution.

  Scenario: Encrypted payload confidentiality
    Given a network observer captures session traffic
    When message, metadata, or agent-state payloads are transmitted
    Then no plaintext user content is visible in the captured payloads

  Scenario: Path traversal protection
    Given a remote request attempts to access a file outside the session working directory
    When the RPC file handler validates the path
    Then the request is rejected with an access denied error and no file content is returned

  Scenario: Permission gating for tool execution
    Given permission mode is "default"
    When a tool call is initiated by the agent
    Then execution is blocked until an explicit approval is received
    And a denial results in no tool output being applied
