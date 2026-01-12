# Delegate Documentation

Reference guide for the `delegate.sh` workflow. This index points to focused docs and keeps each file under the 500-line limit.

## Start Here
- Overview and quick start: `utilities/delegate.how-to.md`
- CLI reference and roles: `docs/delegate/cli.md`
- Running tasks and sessions: `docs/delegate/usage.md`
- Role and task templates: `docs/delegate/templates.md`
- Troubleshooting and best practices: `docs/delegate/troubleshooting.md`

## Core Concepts (Short)
- Delegation runs through a structured prompt with a role plus task details.
- By default, tasks run in tmux and write logs to `/tmp/delegate-logs/`.
- Use `delegate.sh --status` and related commands to monitor or continue work.
