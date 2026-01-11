# Happy CLI UX Patterns

Scope: This document abstracts the user-facing interaction patterns of the Happy CLI. It focuses on what users see and how they act, not on implementation details.

## Command structure and naming conventions
- Single entry command with a short name; most functionality is expressed as subcommands.
- Subcommands are plain-language verbs or nouns (auth, connect, notify, daemon, doctor).
- Some commands expose deeper, task-specific verbs (for example, auth login/logout/status; daemon start/stop/status/list/logs).
- Hyphenated subcommands are used for internal or advanced flows (for example, stop-session).
- A compatibility alias is accepted for the underlying agent command; the wrapper treats it as the primary command.
- Unknown flags are intentionally passed through to the underlying agent CLI to preserve upstream compatibility.

## Argument and flag patterns
- Global flags use both short and long forms for help and version.
- Subcommands often accept their own help flags, plus a help subcommand variant.
- Required flag values are positional after the flag (for example, -p <message>).
- Validation is explicit: invalid values prompt a list of allowed options.
- Wrapper-specific flags use a long form and are validated locally (for example, environment overrides, permission shortcuts).
- When a flag is malformed, the CLI stops immediately with a clear error and non-zero exit.

## Output formatting
- Help output uses labeled sections: Usage, Options, Examples, Notes. Spacing and blank lines create visual grouping.
- Diagnostic output is sectioned with headings and grouped key-value lines.
- Lists use indentation and line prefixes to differentiate primary items from metadata.
- Long data (settings, process lists) is printed in a readable, structured form with indentation.
- Session/event output is formatted as a chat transcript with role labels and icons.
- When output is too long, it is truncated with an explicit "truncated" indicator.
- QR codes are framed with horizontal rules and a short instruction line, with the code itself indented for clarity.
- Full-screen TUI panels use bordered regions and a persistent status bar to separate live logs from controls.

## Color usage and semantic meaning
- Green is consistently used for success states (completed actions, authenticated status, running services).
- Yellow indicates warnings, non-blocking issues, and deprecations.
- Red signals errors and failed operations.
- Blue and cyan are used for informational status and section headings.
- Gray (dim) is used for secondary details, metadata, and guidance hints.
- Role-based coloring distinguishes message types in transcripts (user, assistant, system, tool, result).

## Interactive prompts and confirmations
- Selection prompts are presented as numbered lists with a visible focus indicator.
- Keyboard navigation supports arrow keys plus numeric shortcuts; Enter confirms.
- Escape or Ctrl-C cancels and returns to a safe exit path.
- Destructive actions require explicit confirmation with a yes/no prompt and a default of "No".
- In live remote mode, high-risk actions (exit or switch modes) require a double key press within a timeout.

## Error message formatting
- Errors are prefixed with a clear label (for example, "Error:") and color emphasis.
- Unknown subcommands echo the invalid input and re-display help guidance.
- Missing required arguments produce a direct instruction and a follow-up hint to run help.
- When environment or dependency issues occur (such as missing tools), the CLI describes the dependency and next step.

## Success and failure feedback patterns
- Success is acknowledged with affirmative language and a visual success marker.
- Follow-up details are indented under the success line (for example, IDs, file paths).
- Failures include a short description and, when available, a recovery hint.

## Loading states and progress indicators
- Long waits display a single-line status that updates in place (for example, animated dots).
- Actions that involve external systems show a "starting" line before the action and a "done" line after completion.
- Live session views show an explicit "waiting for messages" placeholder when idle.

## Verbose and quiet mode patterns
- Normal mode is concise and user-focused.
- Debug mode reveals additional details such as stack traces or log paths.
- Some commands suppress non-essential logging when used in automated contexts (for example, version checks).
