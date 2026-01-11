# feature-device-pairing-invalid-link

## Goal
Implement the BDD scenario "Handle an invalid connection link" for device pairing.

## Why
Continue device-pairing-qr scenarios.

## Acceptance Criteria
- Behave scenario `Handle an invalid connection link` passes in `tests/bdd/device-pairing-qr.feature`.
- Mobile app shows an invalid link error and blocks pairing approval.
- Acceptance evidence captured.

## Owner
Delegate: BDD feature owner (red/green/refactor sub-delegates).

## Status
Done

## What I Changed
- Extended BDD feature + steps with invalid link coverage.
- Added invalid link validation + UI error state in the mobile app.
- Captured Behave evidence in `docs/testing/acceptance/bdd-device-pairing-invalid-link.md`.

## Links
- Evidence: `docs/testing/acceptance/bdd-device-pairing-invalid-link.md`
