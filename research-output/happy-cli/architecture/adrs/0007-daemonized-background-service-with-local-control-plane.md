# Daemonized Background Service with Local Control Plane

## Status
Accepted

## Context
Remote control and push-triggered sessions should work even when the CLI is not actively running. A long-lived service is needed to maintain machine presence and spawn sessions on demand.

## Decision
Run a background daemon that registers the machine with the server, maintains a real-time machine channel, and spawns agent sessions upon request. Expose a local-only HTTP control plane for the CLI to list, spawn, and stop sessions. Enforce single-instance behavior via a lock file and write heartbeats for liveness checks. Allow version-based self-restart to keep the daemon aligned with the installed CLI.

## Consequences
- Improves availability and responsiveness for mobile-triggered actions.
- Introduces an additional process and a local control interface that must be secured.
- Requires lifecycle management (locks, heartbeats, graceful shutdown).
