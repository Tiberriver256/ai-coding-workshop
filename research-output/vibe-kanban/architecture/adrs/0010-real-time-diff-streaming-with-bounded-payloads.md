# Real-Time Diff Streaming With Bounded Payloads

Status: Accepted

## Context
Users need live feedback on code changes produced during task execution, but diff data can become very large and expensive to transmit.

## Decision
Provide a WebSocket diff stream that:
- Watches filesystem and repository state to emit incremental diff updates.
- Supports a stats-only mode for lightweight updates.
- Omits full diff content after a cumulative payload threshold is reached.

## Consequences
- Enables responsive, real-time change visibility.
- Large diffs may be summarized rather than fully transmitted.
- Clients must handle omitted content and fall back to manual diff views when needed.
