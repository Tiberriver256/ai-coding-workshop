# Testing Strategy

## Goals
- Verify each slice end-to-end with explicit evidence.
- Catch regressions with lightweight automated checks where feasible.

## Levels
- Unit: core logic and pure functions; fastest feedback; owned by feature dev.
- Integration: component/service boundaries and API contracts; owned by feature dev with QA review.
- BDD (Behave): Gherkin scenario automation aligned to `docs/features/` (source of truth); owned by QA with slice owners.
- End-to-end: critical journeys in slices; owned by QA lead with product sign-off.

## Evidence
- Acceptance evidence per slice in `docs/testing/acceptance/`.
- Exploratory sessions in `docs/testing/exploratory/`.
- Blind user tests in `docs/testing/blind-user-tests/`.
- Demo asset packs captured during acceptance runs and registered in `docs/reviews/demo-assets-registry.md`.

## Evidence Expectations (concise)
- Unit: test list or references in PR/commit + any notable gaps.
- Integration: contract notes + fixtures/mocks used + results summary.
- BDD: scenario list + run output summary + links to feature files executed + tag summary + traceability check to `docs/features/`.
- End-to-end: step-by-step run log + screenshots/recording links if available + pass/fail call.

## Behave Automation
- Source of truth: `docs/features/` defines behavior; `tests/bdd/` mirrors those features for automation.
- Drift control: if a `tests/bdd/*.feature` diverges from `docs/features/*.feature`, fix or document the exception in acceptance evidence.
- Drift check: run `scripts/check-bdd-drift.sh` (or `npm run check:bdd-drift`) before BDD runs to enforce alignment.
- Coverage rule: new `docs/features/*.feature` files are either automated or explicitly deferred with rationale.
- Structure: features stay aligned by name; steps live in `tests/bdd/steps/`; shared helpers go in `tests/bdd/steps/support/` (planned).
- Repo hygiene: generated artifacts (for example `__pycache__`) must not be committed; add ignores/lints as needed.
- Tagging: use `@slice-####`, `@smoke`, `@regression`, `@wip` to enable selective runs.
- Execution prep: run against built UI artifacts where possible; avoid brittle DOM-only assertions in favor of user intent checks.
- Install: `python3 -m venv .venv && source .venv/bin/activate && pip install -r requirements.txt`
- Run: `behave tests/bdd` or `behave -t @smoke tests/bdd`
- Evidence: capture tag set + feature list + run summary in `docs/testing/acceptance/`.

## Ownership Notes
- QA lead maintains this strategy, BDD alignment, and evidence folder structure.
- Feature owners supply unit/integration proof with their slice work and review scenario wording.
- Product owner signs off on end-to-end acceptance evidence and feature intent wording.

## Acceptance Evidence Template (suggested)
- Date, tester, environment
- Steps executed
- Observed results
- Screenshots/logs references (if any)
- Pass/Fail summary

## Open Decisions
- Define CI cadence for BDD runs (smoke on PR, regression on schedule).
- Decide on headless UI execution vs. static artifact inspection for critical flows.
- Document retry/flake policy and test data setup expectations.
