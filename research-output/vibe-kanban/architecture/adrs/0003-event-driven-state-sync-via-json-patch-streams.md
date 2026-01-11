# Event-Driven State Sync Via JSON Patch Streams

Status: Accepted

## Context
The UI requires real-time updates for tasks, workspaces, execution processes, logs, and diffs without heavy polling. Updates must be incremental and efficient for large task boards.

## Decision
Adopt event-driven state synchronization with:
- A server-side message store that retains bounded history and broadcasts live updates.
- Streaming endpoints using Server-Sent Events for general state updates and WebSocket streams for session logs and diff updates.
- JSON Patch (RFC 6902) as the incremental update format, with an initial snapshot followed by patches and a ready signal.

## Consequences
- Clients receive efficient incremental updates and can recover state after reconnects.
- Client logic must apply JSON Patch and handle stream ordering/reconnect behavior.
- Stream history retention must be managed to control memory usage.
