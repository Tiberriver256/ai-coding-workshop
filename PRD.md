# ai-coding-workshop PRD

## Summary
A kanban-first agent orchestration workspace with secure remote access from web and mobile, QR-based onboarding, and end-to-end encrypted point-to-point connectivity (relay fallback). The product focuses on coding workflows with built-in review tooling and DevOps integrations (GitHub, Azure DevOps), plus Copilot CLI and Codex CLI support.

## Goals
- Provide a kanban board that orchestrates multi-agent workstreams (tasks, lanes, dependencies).
- Enable remote web UI and mobile access to local sessions with QR onboarding and end-to-end encryption.
- Keep remote control responsive with P2P connectivity and relay fallback.
- Provide coding-focused tooling (diff review, approvals, prompt autocomplete) inside task workflows.
- Integrate with GitHub and Azure DevOps for PR creation and status tracking.
- Support Copilot CLI and Codex CLI for agent execution and prompt assistance.
- Make agent execution reproducible, auditable, and configurable.

## Non-Goals (initial)
- General-purpose chat app.
- Public multi-tenant SaaS (initial release is self-hosted / single-tenant).
- Fully automated code changes without human review.
- Full IDE replacement (the product orchestrates and reviews work, it does not replace an editor).

## Target Users
- Individual developers managing multiple AI agents across devices.
- Small teams coordinating AI-assisted coding tasks.

## User Stories
- As a developer, I can create a kanban task that spawns one or more agents with defined scopes.
- As a developer, I can monitor agent progress, logs, and diffs across desktop and mobile.
- As a developer, I can approve/deny agent actions before they affect my codebase.
- As a developer, I can connect remotely without exposing my local machine publicly.
- As a developer, I can start or control a session from the web or mobile app.
- As a developer, I can create PRs to GitHub or Azure DevOps from a task attempt.
- As a developer, I can use Copilot CLI for prompt autocomplete and Codex CLI for session execution.

## Core Features
- Kanban board with lanes, cards, dependencies, and agent assignments.
- Agent orchestration (start/stop/pause, scopes, tools, permissions).
- Remote web UI and mobile app connectivity for session control.
- QR-based device pairing with end-to-end encryption.
- Encrypted, point-to-point transport where possible; fallback relays as needed.
- Coding-focused tooling: diff review, approvals, and prompt autocomplete.
- GitHub and Azure DevOps support for PR creation and status.
- Copilot CLI and Codex CLI integrations.
- Audit log of agent actions and decisions.

## Connectivity & Security
- Device pairing with QR or code-based handshake.
- End-to-end encryption for all message channels.
- Mutual authentication between devices.
- Optional relay for NAT traversal; relay must not access plaintext.

## Architecture (high-level)
- Local host service (agent runtime + orchestration API).
- Web client (desktop/remote).
- Mobile client.
- Secure transport layer (P2P + relay fallback).
- DevOps connectors for GitHub and Azure DevOps.
- Agent adapters for Copilot CLI and Codex CLI.

## Milestones (draft)
- M0: PRD + architecture sketch.
- M1: Kanban board + basic task lifecycle + mock agent runs.
- M2: QR pairing + encrypted P2P messaging (relay fallback stub).
- M3: Remote web access + mobile client connection.
- M4: Code review UI + approvals + audit logs.
- M5: GitHub/Azure DevOps PR creation and status tracking.
- M6: Copilot CLI + Codex CLI integrations.

## Open Questions
- Primary agent runtime (Codex, Copilot CLI, other local tools)?
- Preferred tech stack for web/mobile?
- Hosting model (self-hosted only vs optional hosted)?
- Security requirements (key storage, rotation, recovery)?
- CLI command naming and packaging (single "workshop" CLI vs adapters)?

## Success Metrics
- Time-to-first-QR-pairing across devices.
- Remote control latency from mobile/web to local session.
- PR creation success rate for GitHub and Azure DevOps.
- Median task completion time with agents vs baseline.
- User-reported trust in security and control.
