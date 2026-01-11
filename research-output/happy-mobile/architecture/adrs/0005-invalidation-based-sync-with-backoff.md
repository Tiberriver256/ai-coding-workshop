# Invalidation-Based Sync With Retry and Backoff

## Status
Accepted

## Context
Multiple UI surfaces can trigger refreshes of sessions, machines, messages, and profile data. Network conditions are variable and reconnections can happen frequently. A naive approach can cause redundant fetches and thundering-herd behavior.

## Decision
Use an invalidation-based synchronization mechanism. Each resource type has an invalidation queue that coalesces repeated refresh requests, runs a single fetch at a time, and retries failed operations with exponential backoff. Reconnection events invalidate relevant resources to ensure convergence with server state.

## Consequences
- Avoids redundant network calls and smooths spikes during reconnects.
- Provides eventual consistency with bounded retry behavior.
- Adds asynchronous complexity and deferred refresh timing.
- Requires careful handling to avoid starvation or stale data.
