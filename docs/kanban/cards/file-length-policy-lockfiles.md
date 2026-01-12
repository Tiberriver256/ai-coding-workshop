# file-length-policy-lockfiles

## Goal
Decide how generated lockfiles (ex: `package-lock.json`) should be handled by the 500-line rule.

## Why
The file-length rule currently flags lockfiles, blocking automated checks.

## Acceptance Criteria
- Policy decision documented (exempt lockfiles or change tooling).
- `scripts/check-file-lengths.sh` updated to match the decision.
- `docs/plan/file-length-audit.md` updated with the chosen policy.

## Owner
Delegate: Tech debt wrangler.

## Status
Done

## Decision (2026-01-12)
- Keep the 500-line rule absolute for tracked files.
- Do not track npm lockfiles; `.npmrc` disables `package-lock.json` and the file is ignored.
- `scripts/check-file-lengths.sh` remains unchanged (no exceptions added).

## Links
- Evidence: `docs/plan/file-length-audit.md`, `scripts/check-file-lengths.sh`, `.npmrc`, `.gitignore`

## Notes
- Keep the 500-line rule for hand-edited source/docs.
- Ensure any exception is explicit and auditable.
