Feature: Consistency
  To prevent conflicting cross-device updates
  As a system designer
  I want deterministic ordering and conflict detection

  Scenario: Optimistic concurrency prevents lost updates
    Given two devices updating the same session metadata
    When the second update uses a stale expected version
    Then the server should reject it with a version-mismatch response

  Scenario: Ordered update sequences enable deterministic replay
    Given a stream of updates for a user
    When a client replays updates after reconnect
    Then updates should be applied in sequence order

