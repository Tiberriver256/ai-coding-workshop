# feature-remote-session-mobile-start

## Goal
Implement the BDD scenario "Start a session in a chosen directory from the mobile app" for remote-session-access.

## Why
Continue the remote-session-access scenarios with mobile session initiation.

## Acceptance Criteria
- Behave scenario `Start a session in a chosen directory from the mobile app` passes in `tests/bdd/remote-session-access.feature`.
- Mobile project path input creates a new session and opens it on the phone.
- Acceptance evidence captured.

## Owner
BDD feature owner (red/green/refactor sub-delegates).

## Status
Done

## What I Changed
- Added BDD scenario coverage and step assertions for mobile path entry, session creation, and open-on-phone view.
- Implemented mobile session start UI, active session panel, and localStorage-backed session creation.
- Captured behave run output and acceptance evidence for the updated feature.

## Links
- Evidence: `docs/testing/acceptance/bdd-remote-session-mobile-start.md`
