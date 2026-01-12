# Dan North Review (2026-01-12)

## Summary
Strong intent to capture behavior, but the current automation reads more like UI markup checks than executable specs. The strategy needs a clearer single source of truth for features and an explicit drift control plan.

## Key Concerns
- BDD is intended to be a shared language of outcomes; tests that parse HTML/JS risk missing the real behavior.
- Feature files exist in both `docs/features/` and `tests/bdd/`, and they diverge today, which undermines trust in the specs.
- A documented feature (`encrypted-point-to-point-connectivity`) has no automated counterpart.
- Scenarios lack tagging or slice traceability, so it is hard to know what is covered per release slice.
- Strategy does not specify how evidence connects to business outcomes, only to test execution.

## Recommendations
- Declare `docs/features/` as the single source of truth and enforce a sync or drift check for `tests/bdd/`.
- Add scenario tagging (slice, smoke, regression) and require tag-based reporting for acceptance evidence.
- Raise the abstraction level of steps to user intent; push DOM details into helpers or lower-level tests.
- Add a coverage checkpoint so new features are either automated or explicitly deferred with rationale.
- Clarify ownership: product/QA jointly approve feature language, QA owns automation alignment.

## Questions
- Should BDD run against a built UI (headless) instead of static asset inspection?
- What is the minimum evidence needed to prove a slice is behavior-complete?
