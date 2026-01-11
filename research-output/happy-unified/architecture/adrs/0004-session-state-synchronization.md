# Session State Synchronization Across Devices

## Status
Accepted

## Context
Session metadata and agent state can be updated by multiple devices (CLI, mobile, daemon). Updates must avoid lost writes, remain ordered, and converge after intermittent connectivity.

## Decision
Apply optimistic concurrency with ordered update streams:
- Mutable session and machine fields carry explicit version numbers.
- Clients submit updates with an expected version; the server performs compare-and-swap and returns a version-mismatch response when a concurrent update wins.
- The server allocates monotonically increasing sequence numbers for durable updates and emits them over the real-time channel.
- Clients apply idempotent reducers, retry on version mismatch, and invalidate and refetch state after reconnect to ensure convergence.
- Mobile clients can use state versions (e.g., agentStateVersion) to detect readiness of a remote session before sending commands.

## Consequences
- Prevents lost updates without global locks.
- Requires client retry logic and conflict handling for mismatched versions.
- Adds protocol complexity but yields deterministic ordering and eventual consistency.

