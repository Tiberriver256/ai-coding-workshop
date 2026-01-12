# ci-pipeline-minimal

## Goal
Add a minimal CI workflow to run acceptance tests and checks.

## Why
Launch readiness requires repeatable automated verification.

## Acceptance Criteria
- CI workflow added (GitHub Actions or equivalent) to run `npm run test:acceptance` and file-length check.
- File-length check script added under `scripts/`.
- `docs/plan/integration-notes.md` updated with CI instructions.
- Kanban card updated with summary and evidence link.

## Owner
Delegate: CI/CD specialist.

## Status
Done

## Links
- PR/commit: (pending)
- Evidence: `.github/workflows/ci.yml`

## Summary
- Added GitHub Actions CI to run file-length enforcement and Playwright acceptance tests.
- Documented CI/test commands in integration notes.

## Notes
- Keep files under 500 lines.
- Avoid touching app code.
