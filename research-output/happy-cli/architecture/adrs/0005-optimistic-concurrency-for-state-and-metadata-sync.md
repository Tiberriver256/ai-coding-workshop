# Optimistic Concurrency for State and Metadata Sync

## Status
Accepted

## Context
Session metadata and agent state can be updated by multiple clients (CLI, mobile, daemon). Concurrent writes must avoid overwriting newer data while supporting offline or delayed updates.

## Decision
Version all mutable state objects and require clients to submit the expected version with updates. If a version mismatch occurs, clients refresh to the latest state and retry using exponential backoff. Serialize local updates with lightweight locks to prevent conflicting writes within a single process.

## Consequences
- Prevents lost updates without global locks.
- Requires retry logic and conflict handling in clients.
- Update latency may increase under high contention.
