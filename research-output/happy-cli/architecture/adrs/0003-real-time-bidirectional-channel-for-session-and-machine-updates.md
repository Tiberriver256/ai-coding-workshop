# Real-Time Bidirectional Channel for Session and Machine Updates

## Status
Accepted

## Context
Remote control requires low-latency updates between the CLI, server, and mobile client. Updates include streaming messages, state changes, and presence/heartbeat signals.

## Decision
Use a persistent, bidirectional real-time channel for session-scoped and machine-scoped communications. Maintain separate connections for session updates and machine/daemon control. Implement keep-alive signals and automatic reconnection with bounded backoff to preserve continuity across transient network failures.

## Consequences
- Enables near real-time UI updates and remote control.
- Requires connection management, reconnection logic, and heartbeat handling.
- Loss of connectivity can delay updates until reconnection completes.
