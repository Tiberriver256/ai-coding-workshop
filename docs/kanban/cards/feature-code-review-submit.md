# feature-code-review-submit

## Goal
Implement the BDD scenario "Submit review feedback" for code review.

## Why
Continue code-review scenarios.

## Acceptance Criteria
- Behave scenario `Submit review feedback` passes in `tests/bdd/code-review.feature`.
- Send posts review comments and moves the task back to In Progress.
- Evidence recorded in `docs/testing/acceptance/bdd-code-review-submit.md`.

## Owner
Delegate: BDD feature owner (red/green/refactor sub-delegates).

## Status
Done

## What I Changed
- Added BDD coverage for submitting review feedback and evidence logging.
- Implemented the send action to bundle comments, record evidence, and return the task to In Progress.
- Captured Behave evidence in `docs/testing/acceptance/bdd-code-review-submit.md`.

## Links
- Evidence: `docs/testing/acceptance/bdd-code-review-submit.md`
