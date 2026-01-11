# File-Based Logging to Avoid Terminal Interference

## Status
Accepted

## Context
Interactive agent sessions rely on terminal UI behavior. Emitting debug logs to stdout/stderr can corrupt the user experience and break interactive flows.

## Decision
Write diagnostic logs to rotating session log files by default. Reserve console output for user-facing messages only, with optional developer-only console logging gated behind a debug flag. Support optional remote log forwarding only when explicitly enabled.

## Consequences
- Preserves interactive terminal UX while retaining diagnostics.
- Requires users to locate log files for debugging.
- Remote logging must be explicitly enabled and treated as sensitive.
