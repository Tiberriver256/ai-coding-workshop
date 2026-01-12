# Release Checklist (Definition of Done)

## Product
- [x] Core slices implemented end-to-end for critical journeys (Release 0001 scope = Slice 0001 only per `docs/plan/release-scope.md`; acceptance evidence in `docs/testing/acceptance/slice-0001.md`)
- [x] Personas and journeys validated (evidence in `docs/product/validation.md`; Journey 1 validated, Journey 2 pending future slice)
- [x] Success metrics defined and tracked (defined in `docs/product/metrics.md`; tracking plan in `docs/product/metrics-tracking.md`; baseline captured 2026-01-11)

## Architecture
- [x] ADRs for major decisions (`docs/architecture/adrs/`)
- [x] Quality attributes documented with scenarios and evidence (security, reliability, performance, maintainability) (`docs/architecture/quality-attributes/` + `docs/architecture/quality-attributes/evidence.md`)

## Testing
- [x] Test strategy documented (`docs/testing/strategy.md`)
- [x] Acceptance evidence for each slice (Slice 0001 evidence in `docs/testing/acceptance/`; future slices pending)
- [x] Exploratory testing notes (`docs/testing/exploratory/session-0001.md`)
- [x] Blind user test notes (`docs/testing/blind-user-tests/session-0001.md`; internal proxy session completed with limitation/waiver: true blind sessions deferred per `docs/testing/blind-user-tests/protocol.md`)

## Security
- [x] Threat model and mitigations (`docs/security/threat-model.md`)
- [x] Dependency/auth/logging checks documented (`docs/security/checks.md`)

## CI/CD and Ops
- [x] Repeatable build/run/test instructions aligned (`docs/setup/README.md`)
- [x] CI green or explicitly waived with rationale (waiver documented in `docs/plan/ci-status.md`)
- [x] Runbook + monitoring/alerts plan (minimal) (`docs/ops/runbook.md`, `docs/ops/monitoring.md`)

## Documentation
- [x] Setup/onboarding guide (`docs/setup/README.md`)
- [x] User-facing basics (`docs/user/README.md`)
- [x] Demo asset pack captured (registry at `docs/reviews/demo-assets-registry.md`)

## Hygiene
- [x] No file exceeds 500 lines (verified with `scripts/check-file-lengths.sh`)
- [x] Indexes updated for any splits (ADR index in `docs/architecture/adrs/INDEX.md`; quality attributes index in `docs/architecture/quality-attributes/INDEX.md`)
