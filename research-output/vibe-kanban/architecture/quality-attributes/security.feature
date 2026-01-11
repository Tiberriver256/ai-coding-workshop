Feature: Security
  The system should protect user data and enforce authentication and approvals.

  Scenario: Requests with expired access tokens are rejected
    Given an access token has expired
    When the client calls a protected API endpoint
    Then the response should be 401 Unauthorized

  Scenario: Inactive sessions are revoked
    Given a session has been inactive longer than the configured inactivity window
    When the client calls a protected API endpoint
    Then the response should be 401 Unauthorized

  Scenario: PKCE prevents token redemption without the verifier
    Given an OAuth handoff was initiated with a PKCE challenge
    When the client redeems the code with an invalid verifier
    Then the token exchange should be denied

  Scenario: Tool actions require approval
    Given a tool action requires approval
    When the approval is not granted before its timeout
    Then the action should be marked as timed out and not executed
