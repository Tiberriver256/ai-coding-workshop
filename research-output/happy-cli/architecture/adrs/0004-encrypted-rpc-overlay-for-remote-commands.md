# Encrypted RPC Overlay for Remote Commands

## Status
Accepted

## Context
Remote operations (file access, process control, permission responses) require request/response semantics over the real-time channel. These calls must be scoped to a session or machine and protected by end-to-end encryption.

## Decision
Implement an RPC layer that registers named handlers with a scope prefix (session or machine ID). RPC requests and responses are encrypted end-to-end and transported over the real-time channel. Handlers are re-registered on reconnect to restore capabilities after transient disconnects.

## Consequences
- Provides a uniform, extensible control plane for remote commands.
- Requires method naming conventions and handler lifecycle management.
- Adds protocol complexity but simplifies feature expansion.
