# Standard JSON API Envelope And Shared Contracts

Status: Accepted

## Context
The system exposes many API endpoints for tasks, workspaces, execution processes, and configuration. Clients need consistent error handling and a stable contract between backend and frontend.

## Decision
Use a uniform JSON response envelope with explicit success/data/error/message fields and generate shared type definitions and schemas from server models for client consumption.

## Consequences
- Clients can implement a single error-handling and parsing strategy across endpoints.
- Contract drift is minimized when types are regenerated as part of builds or CI checks.
- Responses include wrapper metadata, adding a small payload overhead.
