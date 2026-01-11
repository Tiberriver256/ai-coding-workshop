# Hybrid Real-Time Sync Architecture

## Status
Accepted

## Context
Happy requires low-latency state propagation across multiple devices while still supporting initial bootstrap, pagination, and recovery after network interruptions. Update traffic includes durable changes (messages, sessions, machines, artifacts) and transient signals (presence, activity, usage). A single transport cannot efficiently satisfy all of these needs.

## Decision
Use a hybrid synchronization model:
- HTTP APIs provide initial bootstrap, list fetches, and CRUD operations for durable entities.
- A persistent, bidirectional real-time channel delivers updates after bootstrap, using authenticated connections that include a scope declaration (user-scoped, session-scoped, or machine-scoped).
- The server routes updates based on connection scope, emitting targeted durable updates (`update` events) and lightweight ephemeral updates (`ephemeral` events) for presence/activity.
- Clients treat real-time updates as incremental and idempotent, and invalidate cached views on reconnect to ensure eventual convergence.
- Heartbeat/keep-alive signals advertise activity and drive presence UX without writing every pulse to durable storage.

## Consequences
- Provides near real-time multi-device synchronization with reduced polling.
- Introduces dual data paths that must converge in client state stores.
- Requires reconnection handling, invalidation-based refresh, and scoped routing logic.
- Ephemeral signals are best-effort and may be dropped without compromising durable state.

