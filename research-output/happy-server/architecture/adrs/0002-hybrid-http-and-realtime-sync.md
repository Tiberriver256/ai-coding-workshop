# Title
Hybrid HTTP + Real-Time Sync Channels

# Status
Accepted

# Context
Clients need both durable data access (initial sync, pagination, CRUD) and low-latency propagation of updates across multiple devices. Polling alone would be wasteful and delay state convergence.

# Decision
Use HTTP APIs for durable CRUD operations and initial data retrieval, and a persistent real-time channel for update propagation. The real-time channel delivers two categories of events:
- Persistent updates that represent durable state changes (e.g., new or updated entities).
- Ephemeral updates for transient signals (e.g., presence and activity).

# Consequences
- Clients implement a two-phase sync: initial state via HTTP followed by real-time updates.
- The system can provide low-latency multi-device consistency without excessive polling.
- Ephemeral events can be dropped without affecting durable state, simplifying recovery logic.
