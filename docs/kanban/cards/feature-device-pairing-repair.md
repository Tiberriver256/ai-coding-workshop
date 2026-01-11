# feature-device-pairing-repair

## Goal
Implement the BDD scenario "Re-pair a computer after forcing re-authentication" for device pairing.

## Why
Finish device-pairing-qr feature scenarios.

## Acceptance Criteria
- Behave scenario `Re-pair a computer after forcing re-authentication` passes in `tests/bdd/device-pairing-qr.feature`.
- CLI supports `unified auth login --force` and emits a re-auth pairing link.
- Mobile app re-pairs the device and shows the updated pairing status.
- Acceptance evidence captured.

## Owner
Delegate: BDD feature owner (red/green/refactor sub-delegates).

## Status
Done

## What I Changed
- Extended BDD feature + steps to cover forced re-auth pairing.
- Added `--force` handling in the CLI plus re-pair status updates in the mobile app.
- Captured Behave evidence in `docs/testing/acceptance/bdd-device-pairing-repair.md`.

## Links
- Evidence: `docs/testing/acceptance/bdd-device-pairing-repair.md`
