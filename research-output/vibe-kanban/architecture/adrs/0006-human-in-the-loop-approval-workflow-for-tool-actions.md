# Human-In-The-Loop Approval Workflow For Tool Actions

Status: Accepted

## Context
Some coding-agent tool actions require explicit human approval to reduce risk. The system needs to pause execution safely and resume based on user decision.

## Decision
Introduce an approval workflow that:
- Creates approval requests for selected tool actions.
- Streams approval status updates through the same event/log channels.
- Supports timeouts and updates task state when approval is granted or denied.

## Consequences
- Improves safety and auditability for sensitive actions.
- Adds execution latency and requires UI support for pending approvals.
- Timeouts and retries must be handled consistently to avoid stuck states.
