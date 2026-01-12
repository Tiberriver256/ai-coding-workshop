# Testing Strategy

## Goals
- Verify each slice end-to-end with explicit evidence.
- Catch regressions with lightweight automated checks where feasible.

## Levels
- Unit: core logic and pure functions; fastest feedback; owned by feature dev.
- Integration: component/service boundaries and API contracts; owned by feature dev with QA review.
- BDD (Behave): Gherkin scenario automation aligned to `docs/features/`; owned by QA with slice owners.
- End-to-end: critical journeys in slices; owned by QA lead with product sign-off.

## Evidence
- Acceptance evidence per slice in `docs/testing/acceptance/`.
- Exploratory sessions in `docs/testing/exploratory/`.
- Blind user tests in `docs/testing/blind-user-tests/`.
- Demo asset packs captured during acceptance runs and registered in `docs/reviews/demo-assets-registry.md`.

## Evidence Expectations (concise)
- Unit: test list or references in PR/commit + any notable gaps.
- Integration: contract notes + fixtures/mocks used + results summary.
- BDD: scenario list + run output summary + links to feature files executed.
- End-to-end: step-by-step run log + screenshots/recording links if available + pass/fail call.

## Behave Automation
- Features live under `tests/bdd/` and are sourced from `docs/features/`.
- Install: `python3 -m venv .venv && source .venv/bin/activate && pip install -r requirements.txt`
- Run: `behave tests/bdd`

## Ownership Notes
- QA lead maintains this strategy and evidence folders' structure.
- Feature owners supply unit/integration proof with their slice work.
- Product owner signs off on end-to-end acceptance evidence for launch readiness.

## Acceptance Evidence Template (suggested)
- Date, tester, environment
- Steps executed
- Observed results
- Screenshots/logs references (if any)
- Pass/Fail summary
