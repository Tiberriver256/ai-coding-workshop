# Integration Notes

## Execution
- `./delegate.sh` is the standard execution entrypoint (wrapper to `utilities/delegate.sh`).

## Environments
- Local dev environment details: Bash + coreutils, `tmux`, and the Codex CLI (`codex`) available in `PATH`. Script writes logs to `/tmp/delegate-logs/`.
- CI environment details: GitHub Actions workflow at `.github/workflows/ci.yml` (ubuntu-latest, Node 20, Playwright browsers installed in job).

## Build/Run/Test
- Build: No build step defined; install dependencies with `npm ci` when running tests.
- Run: Use `./delegate.sh` (wrapper for `utilities/delegate.sh`) to launch Codex tasks. Requires `tmux` + `codex` CLI. Example sanity check: `./delegate.sh --help`.
- Run (Slice 0001 app): `./bin/task-board.js --port 4173` then open `http://127.0.0.1:4173` (ready message logs the URL).
- Run (Mobile review): After starting the app server, open `http://127.0.0.1:4173/mobile/` (uses the same localStorage on that device).
- Test: `./scripts/check-file-lengths.sh`, `npm run test:cli`, and `npm run test:acceptance` (run `npx playwright install --with-deps` once to install browsers).

## Known Constraints
- All text files must remain under 500 lines.
- Plan for parallel work by non-overlapping paths.
- Slice 0001 is local-first with no backend or multi-user sync.
- Persist tasks immediately on create/update so reloads reconstruct board state.
- Use globally unique task identifiers to enable future reconciliation.
