# Database Change Hooks For Event Generation

Status: Accepted

## Context
Real-time UI updates should reflect changes in tasks, workspaces, and execution processes as soon as the data store changes, without polling every table.

## Decision
Use database change hooks to detect inserts, updates, and deletes, and translate them into JSON Patch events pushed into the message store. Deletions are handled with pre-update hooks to capture identifiers reliably.

## Consequences
- Near real-time propagation of state changes to streaming clients.
- Event generation depends on database hook capabilities and must be kept compatible across environments.
- Debugging may require tracing both data mutations and hook-generated events.
