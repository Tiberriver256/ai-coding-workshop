# feature-device-pairing-reject

## Goal
Implement the BDD scenario "Reject a pairing request" for device pairing.

## Why
Continue device-pairing-qr scenarios.

## Acceptance Criteria
- Behave scenario `Reject a pairing request` passes in `tests/bdd/device-pairing-qr.feature`.
- Mobile app supports rejecting a pending pairing request.
- CLI and web UI surface rejection status and the computer remains unpaired.
- Acceptance evidence captured.

## Owner
Delegate: BDD feature owner (red/green/refactor sub-delegates).

## Status
Done

## What I Changed
- Extended BDD feature + steps for rejection flow coverage.
- Added rejection handling in the mobile UI plus CLI/web status messaging.
- Captured Behave evidence in `docs/testing/acceptance/bdd-device-pairing-reject.md`.

## Links
- Evidence: `docs/testing/acceptance/bdd-device-pairing-reject.md`
