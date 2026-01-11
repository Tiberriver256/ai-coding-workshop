# Session Identity Tracking via Hook Callbacks

## Status
Accepted

## Context
Agent sessions can fork or resume, producing new session identifiers. File-based discovery is error-prone when multiple CLI processes are running, causing race conditions and misattribution of sessions.

## Decision
Start a local HTTP hook server per CLI process and configure the agent to call back on session start events. On receiving a hook event, update local session identity and synchronize it to remote metadata. Avoid file system polling for session discovery.

## Consequences
- Provides accurate, per-process session identity tracking.
- Requires a local HTTP listener and temporary hook configuration.
- Adds dependency on agent hook support and local loopback networking.
