# Local Persistence and Decryption Cache

## Status
Accepted

## Context
The client must start quickly, remain usable offline, and avoid repeated expensive decryption work for frequently accessed data. Settings, drafts, and user preferences should survive restarts and logouts.

## Decision
Persist local settings, drafts, and lightweight account data in a device-local key-value store. Maintain an in-memory cache of decrypted content keyed by entity and version, with size limits and eviction of least-recently-used entries. Cache user lookups (including negative results) to avoid repeated network fetches.

## Consequences
- Faster startup and better offline experience.
- Reduced CPU usage from repeated decryption and parsing.
- Requires cache invalidation and memory management policies.
- Local storage introduces potential staleness until a sync refresh occurs.
