# feature-agent-monitoring-stop

## Goal
Implement the BDD scenario "Abort a running attempt" for agent execution monitoring.

## Why
Continue agent execution monitoring scenarios.

## Acceptance Criteria
- Behave scenario "Abort a running attempt" passes in `tests/bdd/agent-execution-monitoring.feature`.
- Stop button halts work and status changes to Stopped.
- Evidence recorded in `docs/testing/acceptance/bdd-agent-monitoring-stop.md`.

## Owner
Delegate: BDD feature owner (red/green/refactor sub-delegates).

## Status
Done

## What I Changed
- Added Stop action coverage to the BDD feature and step definitions.
- Implemented Stop control behavior to halt streaming and update status/evidence.
- Captured Behave evidence in `docs/testing/acceptance/bdd-agent-monitoring-stop.md`.

## Links
- Evidence: `docs/testing/acceptance/bdd-agent-monitoring-stop.md`
