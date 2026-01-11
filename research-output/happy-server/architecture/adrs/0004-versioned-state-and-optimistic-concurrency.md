# Title
Versioned State with Optimistic Concurrency and Ordered Updates

# Status
Accepted

# Context
Multiple devices can update the same logical entities concurrently. The system must prevent lost updates while allowing offline/near-concurrent edits and retries.

# Decision
Use explicit version numbers on mutable fields (e.g., metadata, state, access keys). Clients submit an expected version; the server applies a compare-and-swap update and returns a version-mismatch response on conflict. In addition, allocate monotonically increasing per-user update sequence numbers (and per-entity sequences where needed) to provide ordering of updates across devices.

# Consequences
- Clients can detect conflicts deterministically and reconcile based on server-provided current values.
- Retries are safe because version mismatches do not overwrite newer data.
- Update streams can be ordered and replayed consistently using per-user sequences.
