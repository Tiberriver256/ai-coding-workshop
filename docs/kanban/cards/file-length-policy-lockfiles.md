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
To Do

## Links
- Evidence: `docs/plan/file-length-audit.md`, `scripts/check-file-lengths.sh`

## Notes
- Keep the 500-line rule for hand-edited source/docs.
- Ensure any exception is explicit and auditable.
