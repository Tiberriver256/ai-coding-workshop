# File Search Caching With Prewarm And Invalidation

Status: Accepted

## Context
File search needs to be fast across large repositories while avoiding full scans on every request.

## Decision
Implement a file search cache that:
- Builds an indexed representation per repository.
- Uses a time-to-live and size limits to bound memory usage.
- Validates cache entries against repository head state.
- Prewarms caches for the most active projects on startup.

## Consequences
- Significantly faster search responses on cache hits.
- Background indexing work and memory overhead.
- Occasional cache misses leading to deferred indexing and slower first-query responses.
