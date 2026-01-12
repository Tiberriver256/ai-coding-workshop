# Metrics Tracking

## Purpose
Define how success metrics are tracked for Slice 0001 and establish an initial baseline plan.

## Scope
- Slice 0001 only.
- Manual tracking is acceptable until instrumentation exists.

## Metrics (from `docs/product/metrics.md`)

| Metric | Target | Tracking method | Source | Owner |
| --- | --- | --- | --- | --- |
| Task creation success rate | >= 95% | Manual tally of successful vs failed task creations during scripted runs | Slice acceptance runs + exploratory sessions | Product manager |
| Time to create a task (median) | <= 60 seconds | Manual stopwatch timing from task start to save | Scripted run logs | Product manager |
| Slice acceptance pass rate | >= 90% | Count of passed checks / total checks in acceptance evidence | `docs/testing/acceptance/` | Product manager |
| Defect escape rate | <= 1 per slice | Count of defects found after acceptance sign-off | Defect notes + issue tracker if present | Product manager |
| Build/run/test repeatability | Documented and verified | Checklist of steps completed on a clean machine | `docs/setup/README.md` + run notes | Product manager |

## Tracking approach
- Use a single tracking sheet (manual) stored as a markdown table in `docs/product/metrics-tracking.md` (see Baseline log).
- Collect data during two sessions per release cycle: one scripted acceptance run and one exploratory run.
- Record any failures or defects with short notes and link to evidence artifacts in `docs/testing/`.
- Keep raw notes in `docs/testing/acceptance/` or `docs/testing/exploratory/` and summarize here.

## Baseline plan (initial)
- Baseline window: next acceptance run for Slice 0001.
- Sample size: 10 task creation attempts across scripted steps.
- Timing: measure each attempt with a stopwatch (start at "New task" and stop at save confirmation).
- Success definition: task saved and appears in list without error.
- Failure definition: validation error, save failure, or missing task after save.
- Defect escape: any bug found after acceptance evidence is recorded.

## Baseline log

| Date | Session type | Attempts | Successes | Failures | Median time (sec) | Notes | Evidence |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 2026-01-11 | Acceptance run (automated) | 10 | 10 | 0 | 0.3 | Playwright timing from automated create-task test (10 attempts). | `docs/testing/acceptance/metrics-baseline-2026-01-11.md` |

## Cadence
- Update after each acceptance run for Slice 0001.
- Review status in release checklist before release sign-off.

## Open items
- Decide if automated timing/instrumentation is needed after two manual baselines.
- Confirm where defects are tracked if an issue tracker is introduced.
