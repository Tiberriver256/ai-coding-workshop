# CI Fix Evidence

## Date
January 12, 2026

## Summary
GitHub CI was failing in the Playwright acceptance suite due to missing DOM selectors, ambiguous submit button selection, and tasks not reloading from localStorage. The workflow now passes locally after restoring the task count element, tightening selectors, and reloading persisted tasks before rendering.

## Failure
- `npm run test:acceptance` failed with Playwright errors:
  - `#task-count` element not found.
  - `#task-form button[type="submit"]` resolved to two buttons (strict mode violation).
  - Task persistence test failed because reloaded view showed 0 cards.

## Root Cause
- The `#task-count` element was removed from `app/index.html`, but tests and tooling still expected it.
- The modal now has two submit buttons, and tests used a generic selector.
- The app initialized `tasks` once at script load; on reload, `tasks` could be stale even though localStorage had data, so `renderTasks()` showed empty lists.
- Demo seed tasks were always injected, conflicting with empty-board expectations after `localStorage.clear()`.

## Fix
- Restored a total task count element and updated render logic to populate it.
- Gated demo task seeding behind a `data-demo-seed` flag so clean loads stay empty.
- Reloaded `tasks` and `sessions` from localStorage before initial render.
- Updated acceptance tests to click `#create-task` explicitly.

## Evidence
```
npm run test:acceptance
```
Result: 4 passed (local run).
