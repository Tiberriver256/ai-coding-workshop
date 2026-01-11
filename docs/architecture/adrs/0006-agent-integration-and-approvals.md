# Agent Integration and Human-in-the-Loop Approvals

Status: Accepted

## Context
The system integrates with external agents (e.g., Copilot and Codex CLI) to run tasks while keeping users in control of sensitive actions. The UI must surface progress and approvals in real time.

## Decision
Provide a capability-based agent interface with explicit approvals for sensitive actions:
- Each agent declares supported capabilities and required approval levels.
- Actions execute in isolated workspaces with a clear audit trail of inputs and outputs.
- Approval requests are emitted as events to the UI and time out if not granted.
- Approved actions resume execution with recorded provenance for later review.

## Consequences
- Users retain control over risky operations while still enabling automation.
- Execution latency increases for approval-gated actions.
- The UI must handle pending, approved, and denied states consistently.
