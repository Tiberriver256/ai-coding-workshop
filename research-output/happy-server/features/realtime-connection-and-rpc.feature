Feature: Real-time connection and RPC
  As a client app, I want to connect to real-time updates and use lightweight RPC between my own devices.

  Scenario: Connect with a valid token
    Given I have a valid bearer token
    When I connect to the WebSocket at /v1/updates with auth token
    Then the connection is accepted

  Scenario: Missing token is rejected
    Given I do not provide a token
    When I connect to the WebSocket at /v1/updates
    Then the server rejects the connection with an authentication error

  Scenario: Session-scoped client requires a sessionId
    Given I connect as a session-scoped client without a sessionId
    When I connect to the WebSocket at /v1/updates
    Then the server rejects the connection with a sessionId required error

  Scenario: Machine-scoped client requires a machineId
    Given I connect as a machine-scoped client without a machineId
    When I connect to the WebSocket at /v1/updates
    Then the server rejects the connection with a machineId required error

  Scenario: Ping returns an acknowledgement
    Given I am connected to the WebSocket at /v1/updates
    When I emit "ping" with a callback
    Then the callback receives an empty response

  Scenario: Register and call an RPC method
    Given two WebSocket connections for the same user
    And one connection registers method "do-work" via "rpc-register"
    When the other connection emits "rpc-call" for method "do-work"
    Then the caller receives an ok response with the callee's result

  Scenario: RPC call fails when the method is not registered
    Given no connection has registered method "do-work"
    When I emit "rpc-call" for method "do-work"
    Then the callback receives ok: false and "RPC method not available"

  Scenario: RPC unregister removes the method
    Given I registered method "do-work"
    When I emit "rpc-unregister" for method "do-work"
    Then I receive "rpc-unregistered" for that method
