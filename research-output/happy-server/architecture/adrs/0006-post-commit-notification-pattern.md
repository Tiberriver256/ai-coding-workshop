# Title
Post-Commit Notifications for State Changes

# Status
Accepted

# Context
Real-time updates must reflect committed state. Emitting updates before a transaction commits can produce false positives or inconsistencies if the transaction later fails.

# Decision
Wrap state-changing operations in a transaction with strict isolation and retry on serialization conflicts. Defer update emission until after the transaction commits by registering post-commit callbacks. These callbacks publish updates to the real-time channel and are executed only when the transaction succeeds.

# Consequences
- Update streams reflect committed state, avoiding ghost updates.
- Serialization retries improve correctness under contention at the cost of possible added latency.
- Post-commit callbacks must be small and failure-tolerant because they run outside the transaction boundary.
