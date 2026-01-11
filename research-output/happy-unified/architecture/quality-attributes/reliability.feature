Feature: Reliability
  To ensure stable synchronization and messaging
  As a system engineer
  I want retries and failures to avoid corrupting state

  Scenario: Message retries do not create duplicates
    Given a client retries sending the same message with the same local identifier
    When the server receives the duplicated request
    Then only one durable message should be persisted
    And only one update should be emitted to other devices

  Scenario: Updates are emitted only after durable commits
    Given a state-changing operation in progress
    When the transaction fails before commit
    Then no real-time update should be emitted

