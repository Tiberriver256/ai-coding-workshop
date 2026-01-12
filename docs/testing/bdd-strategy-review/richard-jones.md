# Richard Jones Review (2026-01-12)

## Summary
The strategy needs more engineering guardrails: alignment checks, execution prerequisites, and a clear boundary between BDD and other test levels. The current automation is likely to miss integration failures.

## Key Concerns
- BDD tests read static HTML/JS rather than running a built app, so runtime behavior is unverified.
- Feature files in `tests/bdd/` drift from `docs/features/` with no control mechanism.
- There is no explicit CI/run policy (when BDD runs, what tags are required).
- Repo hygiene: compiled artifacts like `__pycache__` appear under `tests/bdd/steps/`.
- No documented approach for error handling, reporting, or retry strategy in Behave runs.

## Recommendations
- Add a pre-run build or fixture step and clarify the test harness boundary.
- Add a drift check between `docs/features/` and `tests/bdd/` as part of the BDD run.
- Define CI targets (smoke on PR, regression nightly) and expected timing budgets.
- Enforce repo hygiene: ignore generated files and add a lint check if needed.
- Document reporting artifacts (log path, scenario list, tag summary).

## Questions
- Is there a plan to move toward headless browser coverage for critical flows?
- What level of flake tolerance and retry policy is acceptable?
