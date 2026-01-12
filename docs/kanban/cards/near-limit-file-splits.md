# near-limit-file-splits

## Goal
Reduce risk of >500-line violations by splitting near-limit files.

## Why
Several files are within 10% of the 500-line cap, making future changes risky.

## Acceptance Criteria
- Split plan created for each near-limit file (target <350 lines per file).
- At least one split completed without behavior changes.
- `docs/plan/file-length-audit.md` updated with new counts.

## Owner
Delegate: Tech debt wrangler.

## Status
To Do

## Links
- Evidence: `docs/plan/file-length-audit.md`

## Notes
- Current near-limit list: `app/app.part2.js`, `app/app.part1.js`, `app/mobile/app.js`, `app/styles.part2.css`, `tests/bdd/steps/task_orchestration_steps.py`.
- Keep refactors surgical; avoid feature changes.
