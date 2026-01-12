# feature-agent-monitoring-processes

## Goal
Implement the BDD scenario "View all processes for an attempt" for agent execution monitoring.

## Why
Continue agent execution monitoring scenarios.

## Acceptance Criteria
- Behave scenario `View all processes for an attempt` passes in `tests/bdd/agent-execution-monitoring.feature`.
- Task view shows a process list with status and timestamps plus a log viewer.
- Evidence recorded in `docs/testing/acceptance/bdd-agent-monitoring-processes.md`.

## Owner
Delegate: BDD feature owner (red/green/refactor sub-delegates).

## Status
Done

## What I Changed
- Added the process list scenario and step checks in the BDD feature/steps.
- Implemented the task view processes panel, list rendering, and log viewer UI.
- Captured Behave evidence in `docs/testing/acceptance/bdd-agent-monitoring-processes.md`.

## Links
- Evidence: `docs/testing/acceptance/bdd-agent-monitoring-processes.md`
