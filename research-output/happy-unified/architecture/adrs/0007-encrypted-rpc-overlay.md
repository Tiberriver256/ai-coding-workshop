# Encrypted RPC Overlay for Remote Control

## Status
Accepted

## Context
Mobile clients must invoke remote operations (spawn session, stop session, permission responses) on the CLI/daemon with low latency and strong confidentiality. These operations need request/response semantics over the same real-time channel used for updates.

## Decision
Layer a scoped RPC protocol over the real-time update channel:
- Clients register RPC handlers identified by scoped method names (sessionId:method or machineId:method).
- Callers send `rpc-call` requests with encrypted parameters; the server routes the request to the socket that registered the method.
- The target device handles the request locally and replies with an encrypted result via an acknowledgement callback.
- Handlers are re-registered on reconnect to restore capabilities after transient disconnects.

## Consequences
- Enables secure, low-latency remote control without adding a separate transport.
- Requires consistent method naming conventions and handler lifecycle management.
- RPC availability depends on the scoped socket being connected; callers must handle timeouts and retries.

