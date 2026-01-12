# BDD Acceptance: Code Review Submit Feedback

Date: 2026-01-12

## Scenario
- Submit review feedback

## Command
```bash
source .venv/bin/activate && behave tests/bdd/code-review.feature
```

## Result
```
1 feature passed, 0 failed, 0 skipped
3 scenarios passed, 0 failed, 0 skipped
15 steps passed, 0 failed, 0 skipped
```

## Notes
- Send action bundles review comments, records evidence, and moves the task back to In Progress.
