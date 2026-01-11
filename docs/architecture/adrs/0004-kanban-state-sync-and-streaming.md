# Kanban Orchestration State Sync and Streaming

Status: Accepted

## Context
The kanban orchestration UI needs real-time visibility into tasks, attempts, logs, and diffs without heavy polling. Clients must recover after disconnects and avoid full reloads on every update.

## Decision
Adopt event-driven state synchronization with snapshot + patch streams and bounded high-volume channels:
- Clients fetch an initial snapshot of task and project state, then subscribe to an incremental patch stream.
- The service retains a bounded history of patches to allow reconnection within a retention window.
- Data mutations emit patch events as they commit, ensuring ordered, idempotent replay on clients.
- High-volume streams (logs, diffs) use separate channels with payload limits and a stats-only fallback once thresholds are exceeded.
- Clients invalidate caches and refresh snapshots when reconnecting outside the retention window.

## Consequences
- The UI stays responsive with incremental updates instead of full reloads.
- Clients require patch-application logic, ordering guarantees, and reconnect handling.
- Large diffs may be summarized, requiring fallback views for full detail.
