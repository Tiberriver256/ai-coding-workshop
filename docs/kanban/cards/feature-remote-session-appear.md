# feature-remote-session-appear

## Goal
Implement the BDD scenario "A session started on the computer appears remotely" for remote-session-access.

## Why
Begin the remote-session-access scenarios with shared session visibility.

## Acceptance Criteria
- Behave scenario `A session started on the computer appears remotely` passes in `tests/bdd/remote-session-access.feature`.
- New sessions appear in mobile and web session lists with online status.
- Acceptance evidence captured.

## Owner
Delegate: BDD feature owner (red/green/refactor sub-delegates).

## Status
Done

## What I Changed
- Added BDD feature and steps for remote session visibility and online status.
- Implemented session list sync via localStorage for desktop and mobile, plus start-session control.
- Added web/mobile session list UI with online status badges and updated acceptance evidence.

## Links
- Evidence: `docs/testing/acceptance/bdd-remote-session-appear.md`
