# External DevOps Integration and Reconciliation

Status: Accepted

## Context
Tasks must create and track pull requests in external systems such as GitHub and Azure DevOps. These systems may not push events to local deployments and can be temporarily unavailable.

## Decision
Use connector adapters with reconciliation and retry semantics:
- Each external system is integrated through a connector interface that maps tasks to external identifiers and status fields.
- Operations (create PR, update status) are idempotent and include correlation identifiers to avoid duplicates.
- Status is reconciled via scheduled polling with exponential backoff and rate limits; results update local task state.
- Authentication is validated before actions and surfaced to the user when missing or expired.

## Consequences
- External state remains eventually consistent with local task status.
- Polling introduces latency and must respect provider rate limits.
- Clear error reporting is required for authentication and connectivity failures.
