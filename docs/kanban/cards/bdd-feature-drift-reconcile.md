# bdd-feature-drift-reconcile

## Goal
Reconcile drift between `docs/features/` and `tests/bdd/` feature files.

## Why
BDD specs and automated tests must match to keep acceptance evidence trustworthy.

## Acceptance Criteria
- `scripts/check-bdd-drift.sh` passes.
- Drift resolved for: `agent-execution-monitoring.feature`, `github-support.feature`, `remote-session-access.feature`, `task-orchestration.feature`, `code-review.feature`.
- Missing feature mirrored: `encrypted-point-to-point-connectivity.feature`.
- Any intentional exceptions documented in acceptance evidence.

## Owner
Delegate: QA lead + feature owners.

## Status
To Do

## Links
- Evidence: `scripts/check-bdd-drift.sh`, `docs/features/`, `tests/bdd/`

## Notes
- Use `docs/features/` as the source of truth unless explicitly documented.
- Keep refactors strictly within feature files (no step changes unless required).
