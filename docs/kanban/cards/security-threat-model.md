# security-threat-model

## Goal
Document threat model and mitigations for Slice 0001 and planned architecture.

## Why
Security posture is a launch requirement.

## Acceptance Criteria
- `docs/security/threat-model.md` created with threats and mitigations.
- `docs/security/checks.md` documents dependency/auth/logging checks.
- Kanban card updated with summary and evidence link.

## Owner
Delegate: Security architect.

## Status
Done

## Links
- PR/commit: (pending)
- Evidence: docs/security/threat-model.md, docs/security/checks.md

## Summary
- Documented Slice 0001 local-only threats, mitigations, and assumptions.
- Added roadmap threat coverage for remote access, sync/streaming, and agent approvals.
- Captured dependency/auth/logging checks with current status and planned controls.

## Notes
- Keep files under 500 lines.
- Focus on current app + documented roadmap.
