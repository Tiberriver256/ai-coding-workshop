# Benno Rice Review (2026-01-12)

## Summary
Good foundation, but the current structure and step design will become brittle. Tighten the boundaries of what BDD should prove and make selective execution easier.

## Key Concerns
- Step definitions repeat HTML parsing and selectors across files, increasing maintenance cost.
- Scenarios are written as UI assertions without clear business intent, which defeats BDD’s purpose.
- There is no tagging strategy to run small, fast subsets (smoke vs. full regression).
- The strategy does not state how test data/state is prepared or how environments are reset.
- BDD evidence expectations are light on traceability and do not describe expected artifacts.

## Recommendations
- Introduce shared helpers or a lightweight page-object layer to reduce duplication.
- Require each scenario to state user goal and value in its wording, not just UI actions.
- Establish tag conventions: `@slice-####`, `@smoke`, `@regression`, `@wip`.
- Define test data/setup rules (fixtures, known states) for Behave runs.
- Expand evidence expectations to include feature list, tag set, and run summary.

## Questions
- Which scenarios are critical enough for smoke coverage each commit?
- How will you prevent UI refactors from breaking a large volume of step definitions?
