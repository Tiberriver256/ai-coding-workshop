# ci-sanity-check

## Goal
Verify build/run/test instructions and identify CI blockers.

## Why
Ensure we can repeatedly build and test the product for launch.

## Acceptance Criteria
- `docs/plan/integration-notes.md` updated with build/test steps and blockers.
- If CI config exists, document current status and required fixes.
- Card updated with summary and evidence links.

## Owner
Delegate: CI/CD specialist.

## Status
Done

## Links
- PR/commit: (pending)
- Evidence: `docs/plan/integration-notes.md`

## Notes
- Prefer minimal doc updates; avoid broad code changes.
- No file may exceed 500 lines.
- Summary: No build/test tooling or CI config found; documented `./delegate.sh` as the only runnable path and listed blockers for build/test definition.
