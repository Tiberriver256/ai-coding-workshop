# Title
Idempotent Write Operations and De-duplication Keys

# Status
Accepted

# Context
Clients may retry requests due to network failures or timeouts. Without idempotency, retries can create duplicate sessions, messages, or feed items and break ordering.

# Decision
Introduce idempotent identifiers and uniqueness constraints for write operations:
- Session creation is deduplicated by a client-provided tag.
- Messages can carry a client local identifier to prevent duplicates.
- Feed items and notifications use a repeat key to overwrite or coalesce repeats.

# Consequences
- Safe retries reduce client-side complexity and improve resilience.
- The server enforces uniqueness at the data layer to ensure consistency.
- Clients must manage stable idempotency keys for write requests.
