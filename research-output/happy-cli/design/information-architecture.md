# Happy CLI Information Architecture

Scope: Command hierarchy, help system, configuration surface, and exit-code conventions.

## Command hierarchy (flattened command paths)
- happy
- happy auth
- happy auth login
- happy auth logout
- happy auth status
- happy auth help
- happy connect
- happy connect codex
- happy connect claude
- happy connect gemini
- happy connect help
- happy notify
- happy daemon
- happy daemon start
- happy daemon stop
- happy daemon status
- happy daemon list
- happy daemon logs
- happy daemon stop-session
- happy daemon install
- happy daemon uninstall
- happy doctor
- happy doctor clean
- happy codex
- happy gemini
- happy gemini model set
- happy gemini model get
- happy logout (deprecated alias that forwards to auth logout)

## Help system structure
- Root help describes primary usage, top-level commands, and examples.
- Subcommand help follows a consistent structure: Usage, Options, Examples, Notes.
- Help is reachable via `-h`, `--help`, or a `help` subcommand on several routes.
- Errors for unknown subcommands echo the invalid input and then re-display help.
- The root help also surfaces upstream agent help to preserve full flag visibility.

## Configuration file patterns
- Default data root is `~/.happy` (overridable via `HAPPY_HOME_DIR`).
- Key files live under the data root:
  - `settings.json` for local preferences and machine ID.
  - `access.key` for authentication credentials.
  - `daemon.state.json` and `daemon.state.json.lock` for background service state.
  - `logs/` for timestamped log files.
- Gemini model selection is stored in user-level config files at `~/.gemini/config.json` or `~/.config/gemini/config.json`.
- A single environment variable can relocate all Happy-managed files by changing the data root.

## Environment variable conventions
- HAPPY_SERVER_URL: overrides the API server base URL.
- HAPPY_WEBAPP_URL: overrides the web app URL used in authentication and support messaging.
- HAPPY_HOME_DIR: overrides the default data directory.
- HAPPY_DISABLE_CAFFEINATE: disables sleep-prevention behavior on supported platforms.
- HAPPY_EXPERIMENTAL: enables experimental features.
- DEBUG and NODE_ENV are honored for diagnostics and debug visibility.
- Additional diagnostic-only environment variables may appear in doctor output.

## Exit code conventions
- 0 indicates success or a user-canceled action that exits cleanly.
- 1 indicates invalid arguments, missing prerequisites, or runtime failures.
- Subcommands exit early on validation errors to avoid partial state changes.
