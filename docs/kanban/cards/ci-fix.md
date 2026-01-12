# ci-fix

## Goal
Fix GitHub CI failures in acceptance tests.

## Why
CI failures block release confidence and require a clear resolution path.

## Acceptance Criteria
- Root cause identified and corrected in workflow/app/tests.
- `npm run test:acceptance` passes locally.
- Evidence captured in `docs/testing/acceptance/ci-fix.md`.

## Owner
DevOps engineer

## Status
Done

## Links
- Evidence: `docs/testing/acceptance/ci-fix.md`

## Notes
- Restored `#task-count`, gated demo seeding, refreshed tasks before render, and tightened test selectors.
