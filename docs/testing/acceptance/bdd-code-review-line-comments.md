# BDD Acceptance: Code Review Line Comments

Date: 2026-01-12

## Scenario
- Add line-specific comments

## Command
```bash
source .venv/bin/activate && behave tests/bdd/code-review.feature
```

## Result
```
1 feature passed, 0 failed, 0 skipped
2 scenarios passed, 0 failed, 0 skipped
9 steps passed, 0 failed, 0 skipped
```

## Notes
- Verified the diff view still loads and supports inline/split toggles.
- Line comment UI and review comment list render in the review modal.
