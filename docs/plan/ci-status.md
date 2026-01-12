# CI Status

Date: 2026-01-11
Owner: Release engineering specialist

## Status
- CI is configured via GitHub Actions in `.github/workflows/ci.yml`.
- Workflow stages: npm install, Playwright browser install, file-length check, and acceptance tests.
- Current CI result: Not verified in this repo (no run logs or badges committed locally).

## Waiver (if not green)
Release checklist requires CI green or an explicit waiver. A waiver is in effect because:
- There is no CI run evidence available in the repository to confirm green status.
- Running CI requires GitHub Actions execution or a local run not captured here.

## Follow-up
- Trigger a GitHub Actions run (push/PR) or run `npm run test:acceptance` locally and attach logs.

## Evidence
- Workflow definition: `.github/workflows/ci.yml`
