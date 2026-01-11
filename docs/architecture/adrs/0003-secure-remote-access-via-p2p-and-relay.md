# Secure Remote Access via Encrypted P2P With Relay Fallback

Status: Accepted

## Context
The kanban UI and mobile clients must remotely control local agents and view live state, even across NATs and firewalls. Remote control must be confidential and access-controlled.

## Decision
Provide a secure remote access plane with encrypted P2P sessions and relay fallback:
- Clients authenticate with scoped bearer tokens and declare the scope of access (user, workspace, session, or machine).
- Devices attempt direct P2P connectivity using mutual key exchange; if unavailable, they connect through a relay.
- All control and data messages are end-to-end encrypted; the relay only forwards ciphertext.
- An RPC overlay provides request/response semantics for remote commands, with handler registration on connect and re-registration on reconnect.
- Callers handle timeouts, retries, and offline status when no active scoped connection is available.

## Consequences
- Low-latency control when P2P succeeds; relay ensures reachability for restricted networks.
- Relay capacity and connection management become operational concerns.
- Clients must manage reconnection and handler lifecycle to ensure reliable control.
