# Local Persistence with Atomic Updates and Locking

## Status
Accepted

## Context
The CLI must retain credentials, settings, and daemon state across restarts while supporting concurrent CLI/daemon processes. Corruption or partial writes can break authentication and control.

## Decision
Persist local state to user-scoped files and update them atomically (write-to-temp + rename). Use lock files with retries to serialize writes and detect stale locks. Store daemon state separately to support process discovery and cleanup.

## Consequences
- Ensures durable local state with reduced corruption risk.
- Requires lock recovery and stale state cleanup logic.
- Local files become a critical dependency and must be protected by filesystem permissions.
