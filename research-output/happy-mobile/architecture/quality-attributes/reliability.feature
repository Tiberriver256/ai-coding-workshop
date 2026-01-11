Feature: Reliability
  To ensure consistent behavior across network disruptions and invalid inputs
  As a user
  I want the client to recover and maintain correct state

  Scenario: Reconnect and resync after network loss
    Given the client is connected and has an active session list
    When the network connection is lost for 30 seconds and then restored
    Then the client should reconnect within 15 seconds
    And a full resync should complete within 30 seconds
    And the latest session sequence numbers should match the server

  Scenario: Offline startup with cached data
    Given the device is offline and cached sessions exist
    When the user launches the app
    Then the cached session list should be displayed without error
    And background sync should start automatically once connectivity is restored

  Scenario: Invalid update payloads
    Given the client receives a malformed update payload
    When the update is processed
    Then the update should be rejected
    And the client should continue processing subsequent valid updates
