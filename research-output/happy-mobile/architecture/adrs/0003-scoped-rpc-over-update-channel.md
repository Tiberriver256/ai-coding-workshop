# Scoped RPC Over the Update Channel

## Status
Accepted

## Context
The client needs to execute remote operations (e.g., session control, command execution, spawn actions) against specific sessions or machines. These operations require low latency, strict scoping, and confidentiality of parameters.

## Decision
Provide an RPC-style interface over the persistent update channel. Scope methods by session or machine identifier, encrypt parameters with the corresponding entity key, and require acknowledgments for operation results. Keep REST endpoints for coarse-grained resource CRUD while routing interactive operations through the update channel.

## Consequences
- Enables fast, interactive control flows without repeated HTTP setup.
- Keeps operation payloads encrypted end-to-end.
- Requires stable connectivity; operations need retry/timeout handling.
- Adds coupling between transport channel health and control-plane actions.
