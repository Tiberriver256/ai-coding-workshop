# commitlint-hooks

## Goal
Add commitlint configuration and enforce commit message checks via a local git hook.

## Why
Consistent commit messages are required for the auto-changelog pipeline.

## Acceptance Criteria
- Commitlint config added with Conventional Commits rules.
- Commit-msg hook runs commitlint locally.
- Setup docs updated with install + hook instructions.
- Kanban board updated with status + evidence links.

## Owner
Delegate: Release engineer.

## Status
Done

## Summary
Added commitlint config, local commit-msg hook wiring via `.githooks`, and setup instructions for hook activation.

## Links
- PR/commit: (pending)
- Evidence: `commitlint.config.cjs`
- Evidence: `.githooks/commit-msg`
- Evidence: `scripts/setup-githooks.sh`
- Evidence: `docs/setup/README.md`

## Notes
- No file may exceed 500 lines.
