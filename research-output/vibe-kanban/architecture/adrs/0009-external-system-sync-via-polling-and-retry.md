# External System Sync Via Polling And Retry

Status: Accepted

## Context
Task status can depend on external systems (e.g., pull request state) and shared task services. These systems are not guaranteed to push events to the local instance.

## Decision
Use periodic polling to refresh external state (e.g., PR merge status) and update local tasks. For remote service interactions, use bounded retries with exponential backoff and timeouts to tolerate transient failures.

## Consequences
- External updates are eventually consistent rather than instantaneous.
- Polling and retries introduce additional external traffic that must be rate-limited.
- Outages degrade functionality gracefully but still require user-visible error handling.
