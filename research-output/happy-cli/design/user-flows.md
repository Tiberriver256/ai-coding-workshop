# Happy CLI User Flows

Scope: Key CLI workflows and how users move through them. The emphasis is on user intent, system feedback, and recovery paths.

## Initial setup and first run
Entry point: running the base command with no prior credentials.

1. User runs the primary command.
2. CLI checks for stored credentials and machine registration.
3. If missing, CLI launches an authentication method selector.
4. User chooses Mobile or Web authentication.
5. CLI presents the chosen flow:
   - Mobile: QR code + deep link, with a fallback URL the user can copy.
   - Web: browser auto-open, plus a visible fallback URL.
6. CLI shows a live "waiting" indicator while polling for approval.
7. On success, CLI confirms authentication and registers the machine.
8. CLI ensures background service availability, then starts the session.

## Authentication flows
### Login
Entry point: `happy auth login`.

1. If already authenticated, CLI reports the existing status and how to re-authenticate.
2. With a force flag, CLI explains the consequences, then clears credentials and machine ID and stops the daemon.
3. CLI runs the same auth selector used in first run.
4. On success, CLI confirms authentication and prints the new machine ID.

### Logout
Entry point: `happy auth logout`.

1. CLI warns that logout will remove access and require re-authentication.
2. CLI requests confirmation with a default of "No".
3. If confirmed, CLI stops background services, removes local auth data, and confirms completion.
4. If declined, CLI reports that logout was canceled.

### Status
Entry point: `happy auth status`.

1. CLI prints a status header.
2. CLI reports authentication status, masked token preview, machine registration, and host name.
3. CLI reports data directory location and daemon status.
4. If not authenticated, CLI suggests the login command.

## Connect vendor keys
Entry point: `happy connect <vendor>`.

1. CLI checks for existing Happy authentication.
2. If missing, CLI stops and instructs the user to log in first.
3. CLI starts an OAuth flow for the selected vendor:
   - Announces flow start.
   - Selects or discovers an available callback port, reporting any fallback.
   - Opens the browser and provides a manual URL if needed.
4. On success, CLI confirms tokens were received and registered.
5. On failure, CLI reports the error and exits with a non-zero code.

## Core command workflows
### Start a session (default)
Entry point: `happy`.

1. CLI performs authentication checks and machine setup.
2. CLI auto-starts or validates the background daemon.
3. CLI starts a session and surfaces a QR code for mobile pairing.
4. CLI streams messages in a chat-style transcript or TUI view.
5. When the session ends, CLI prints a summary and usage stats.

### Start Codex or Gemini mode
Entry point: `happy codex` or `happy gemini`.

1. CLI validates authentication.
2. CLI ensures background service availability.
3. CLI enters a dedicated live display for the agent mode.
4. Exit requires a confirm gesture (double key press) to avoid accidental termination.

### Set or check Gemini model
Entry point: `happy gemini model set <model>` or `happy gemini model get`.

1. CLI validates the model name against a known list.
2. On success, CLI saves the selection and confirms the active model.
3. On error, CLI prints available models and exits non-zero.

### Send push notification
Entry point: `happy notify -p <message> [-t <title>]`.

1. CLI validates required message input.
2. CLI checks authentication and stops if missing.
3. CLI prints a sending status line.
4. CLI confirms delivery and echoes title and message as a receipt.

## Remote mode controls
Entry point: session running in remote mode UI.

1. The interface shows a log area and a persistent control bar.
2. A single key press triggers a confirmation state.
3. A second press within a timeout confirms exit or mode switch.
4. Any other key cancels the confirmation state.

## Diagnostics and cleanup
### Doctor
Entry point: `happy doctor`.

1. CLI prints a diagnostic header.
2. CLI reports version, platform, configuration, environment, and settings.
3. CLI reports authentication and daemon status.
4. CLI lists active processes and log files.
5. CLI ends with a "diagnosis complete" confirmation.

### Doctor clean
Entry point: `happy doctor clean`.

1. CLI searches for runaway processes.
2. CLI reports kills and any errors.
3. CLI confirms the cleanup result.

### Daemon management
Entry point: `happy daemon <subcommand>`.

1. CLI validates the subcommand and prints help on error.
2. Start/stop/status provide short confirmations.
3. List returns active sessions (structured output).
4. Logs returns the latest log path.

## Error recovery patterns
- Missing authentication triggers a clear call to action (run auth login).
- Missing required arguments yields an explicit error plus help suggestion.
- Browser launch failures fall back to displaying the URL.
- Port conflicts are handled by selecting a new port and informing the user.
- Cancellations are safe and explicit; the CLI confirms when an action is aborted.

## Help discovery patterns
- `-h` and `--help` are supported globally and on subcommands.
- Help content is grouped into sections: Usage, Options, Examples, Notes.
- Some commands accept a `help` subcommand alias.
- The main help view also surfaces upstream agent help for full flag coverage.
