# feature-device-pairing-manual-link

## Goal
Implement the BDD scenario "Pair using a manual connection link" for device pairing.

## Why
Continue device-pairing-qr scenarios.

## Acceptance Criteria
- Behave scenario `Pair using a manual connection link` passes in `tests/bdd/device-pairing-qr.feature`.
- Mobile app supports manual connection link entry and approval.
- Device appears in the device list after approval.
- Acceptance evidence captured.

## Owner
Delegate: BDD feature owner (red/green/refactor sub-delegates).

## Status
Done

## What I Changed
- Extended BDD feature + steps for manual connection link flow.
- Added mobile UI and parsing logic for manual link entry and pending pairing requests.
- Captured Behave evidence in `docs/testing/acceptance/bdd-device-pairing-manual-link.md`.

## Links
- Evidence: `docs/testing/acceptance/bdd-device-pairing-manual-link.md`
