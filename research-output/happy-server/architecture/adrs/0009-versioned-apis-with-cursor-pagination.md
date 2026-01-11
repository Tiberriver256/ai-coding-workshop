# Title
Versioned APIs with Cursor-Based Pagination

# Status
Accepted

# Context
Clients evolve over time and require backward-compatible interfaces. Large datasets must be retrievable efficiently without offset-based pagination pitfalls.

# Decision
Expose versioned HTTP endpoints and use cursor-based pagination for list retrieval. Cursors encode the last seen entity identifier, and optional change filters allow clients to request only recently updated items.

# Consequences
- Older clients can continue to use stable endpoints while newer clients adopt enhanced behaviors.
- Cursor pagination scales better for large datasets and avoids inconsistent results under concurrent writes.
- Clients must store and manage cursors for incremental sync.
