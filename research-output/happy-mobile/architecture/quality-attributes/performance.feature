Feature: Performance
  To keep the client responsive under active usage
  As a user
  I want updates, decryption, and rendering to stay within defined latency targets

  Scenario: Real-time update latency
    Given the client has an active session subscription and a stable network connection
    When a new message update is received from the update channel
    Then the message should appear in the session view within 500 ms for the 95th percentile

  Scenario: Decryption and normalization throughput
    Given 100 encrypted messages for a session are fetched in a single batch
    When the client decrypts and normalizes the messages
    Then the batch should complete within 750 ms on the reference device

  Scenario: Cold start with cached data
    Given locally cached sessions and settings exist
    When the user launches the app from a cold start
    Then the home screen should render a usable session list within 2 seconds
