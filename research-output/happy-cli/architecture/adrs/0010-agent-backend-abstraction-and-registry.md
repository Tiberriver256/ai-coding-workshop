# Agent Backend Abstraction and Registry

## Status
Accepted

## Context
The CLI integrates multiple AI agents and transports, each with distinct protocols and session behaviors. The rest of the system should not depend on provider-specific details.

## Decision
Define a uniform agent backend interface and a registry that maps agent identifiers to backend factories. Normalize agent output to a consistent event model (messages, tool calls, permission requests, status). Select transport (native, MCP, ACP) through configuration while keeping the core session/daemon flows unchanged.

## Consequences
- Simplifies adding new agents and transports.
- Encourages separation of concerns between core orchestration and provider adapters.
- Requires adapter implementations to translate provider-specific semantics into the common event model.
