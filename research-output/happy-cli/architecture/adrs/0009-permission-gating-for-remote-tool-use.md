# Permission Gating for Remote Tool Use

## Status
Accepted

## Context
Remote agents can execute powerful tools (filesystem, shell, network). Users need explicit control over potentially destructive actions, especially when requests originate from a mobile device or automated flow.

## Decision
Intercept tool calls and route them through a permission handler that enforces a configurable approval policy. Emit permission requests to the mobile client, record pending requests in agent state, and resolve approvals/denials via encrypted RPC responses. Support multiple permission modes (default, auto-approve edits, bypass, plan) and per-tool allowlists.

## Consequences
- Improves safety and user control for remote execution.
- Introduces additional latency for approval workflows.
- Requires state tracking for pending/completed requests and robust handling of aborted requests.
