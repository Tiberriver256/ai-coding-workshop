# Title
Connection-Scoped Event Routing

# Status
Accepted

# Context
A single user can have multiple concurrent devices and connection types (e.g., per-session clients, per-user clients, and device/daemon clients). Not all updates are relevant to every connection, and indiscriminate broadcasting increases bandwidth and client-side filtering.

# Decision
Categorize connections by scope (user-scoped, session-scoped, machine-scoped) and apply recipient filters when emitting events. Routing rules determine which connections should receive each update type (e.g., session updates only to interested sessions and user-scoped clients; machine updates only to the matching machine plus user-scoped clients).

# Consequences
- Bandwidth and client processing costs are reduced by targeted delivery.
- Update semantics are clearer because each update has an explicit audience.
- Routing logic becomes a core responsibility and must be kept consistent with data ownership rules.
