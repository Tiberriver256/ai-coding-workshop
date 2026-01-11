# Title
Throttled Presence and Activity Updates

# Status
Accepted

# Context
Clients send frequent heartbeat signals for sessions and devices. Writing every heartbeat to durable storage would create unnecessary load and cost.

# Decision
Maintain an in-memory activity cache with a time-to-live per session/device. Heartbeats are validated against the cache, and database writes are throttled and batched based on an update threshold. Presence updates are emitted as ephemeral events for real-time UX, while durable activity timestamps are persisted in periodic batches.

# Consequences
- Database write volume is reduced significantly under high heartbeat rates.
- Presence events remain low-latency without requiring every heartbeat to be persisted.
- Activity state can be stale by a bounded window (batch interval and threshold).
