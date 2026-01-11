# Hybrid Real-Time Update Channel With REST Bootstrap

## Status
Accepted

## Context
The client must stay in near-real-time sync with remote sessions and machines while also supporting initial data load, recovery after disconnects, and occasional full refreshes. Update traffic includes both durable state changes (messages, sessions, machines, artifacts, profiles) and transient activity signals. A single interaction style does not efficiently cover all needs.

## Decision
Use a persistent, bidirectional update channel to stream validated update events and support request/response operations. Use REST-style HTTP endpoints for initial bootstrap, list fetches, and resource CRUD. On reconnect, invalidate cached views and trigger refreshes to ensure eventual consistency. Separate durable updates from ephemeral activity updates to keep the durable stream stable and replayable.

## Consequences
- Achieves low-latency updates for active sessions while preserving a reliable bootstrap path.
- Requires connection lifecycle management and reconnection resync logic.
- Introduces two data flows (stream + REST) that must converge on a single state model.
- Enables server-driven updates without client polling, reducing network overhead.
