# Local-First Deployment With Optional Remote Sync

Status: Accepted

## Context
Vibe Kanban runs primarily as a local application but also supports shared tasks and a remote web experience. The system needs to work in single-user/offline scenarios while optionally synchronizing with a remote service for collaboration and sharing.

## Decision
Adopt a deployment abstraction that encapsulates core services (data store, filesystem, execution container, events, and sync) and supports:
- A local-first mode with an embedded data store and local assets.
- An optional remote sync path for shared tasks and collaboration via a remote service.

## Consequences
- Local usage works with minimal setup and can operate offline.
- Remote collaboration requires authentication and network connectivity.
- The system must manage eventual consistency between local and remote representations of shared tasks.
