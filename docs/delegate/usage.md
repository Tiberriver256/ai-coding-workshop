# Delegate Usage Guide

How to run tasks, monitor progress, and manage sessions.

## Running Tasks in Parallel with tmux

Tasks run in tmux sessions by default. This means:
- Jobs persist even if your terminal disconnects.
- Monitoring is available via `delegate.sh --status`.
- Session management is built into the script.

### Starting Tasks

```bash
# Start a background task (default - uses tmux)
./delegate.sh -c feature-analyst -g "Extract features" -n "my-features"

# Start multiple parallel tasks
./delegate.sh -c feature-analyst -g "Extract features from auth" -n "auth-features"
./delegate.sh -c architect -g "Document API patterns" -n "api-arch"
./delegate.sh -c technical-writer -g "Write README" -n "docs"

# Run in foreground (blocks until complete)
./delegate.sh -f -c feature-analyst -g "Quick task" -n "quick"
```

## Logging

All output is logged to `/tmp/delegate-logs/`:

| File                            | Contains                                                    |
| ------------------------------- | ----------------------------------------------------------- |
| `<timestamp>_<name>_stdout.log` | Agent's final communications/summary                        |
| `<timestamp>_<name>_stderr.log` | Verbose output, command executions, debugging information   |

Logs are tee'd so you see output live while it is also saved.

## Monitoring Tasks

```bash
# Check all running delegate sessions
./delegate.sh --status

# Quick check if tasks are running or done
./delegate.sh --check-all

# Check a specific task
./delegate.sh --check my-features

# Filter by name pattern
./delegate.sh --status features

# Attach to watch a session live (Ctrl+B, D to detach)
tmux attach -t delegate-my-features

# Tail the logs directly
tail -f /tmp/delegate-logs/*my-features*_stderr.log
```

## Continuing a Conversation

If a task completes but you want to give follow-up instructions without starting fresh:

```bash
# Continue an existing session with a new message
./delegate.sh --continue my-features "Now also add edge case scenarios for authentication failures"
```

The continuation will:
- Find the original codex session ID from logs.
- Wait if the previous task is still running (exponential backoff).
- Send your message to continue that conversation.
- Preserve all context from the original task.

This is useful when:
- The agent finished but missed something.
- You want to refine or extend the output.
- You have follow-up tasks that build on previous work.
- You want to queue the next instruction while the current task runs.

## Managing Sessions

```bash
# Kill a specific session
./delegate.sh --kill my-features

# Clean up all idle sessions (completed tasks still open)
./delegate.sh --clean

# Kill ALL delegate sessions (including running ones)
./delegate.sh --clean-all

# Delete a session AND its log files completely
./delegate.sh --purge my-features

# Delete ALL sessions and ALL logs (with confirmation prompt)
./delegate.sh --purge
```

## Session States

The `--check-all` command shows three possible states:

| State   | Meaning                                         |
| ------- | ----------------------------------------------- |
| Running | Task is actively processing (codex running)     |
| Idle    | Task complete, tmux session still open           |
| Done    | Session closed, only logs remain                 |

## Batch Jobs Pattern

```bash
#!/bin/bash
# run-research-jobs.sh

REPOS=("repo1" "repo2" "repo3")

for repo in "${REPOS[@]}"; do
    ./delegate.sh -c feature-analyst \
        -g "Extract features from $repo" \
        -n "${repo}-features"

    ./delegate.sh -c architect \
        -g "Extract architecture from $repo" \
        -n "${repo}-arch"

    sleep 1  # Brief pause between starts
done

echo "Started all jobs. Monitor with: ./delegate.sh --status"
```

## Waiting for Jobs to Complete

```bash
#!/bin/bash
# wait-for-jobs.sh

TASKS=("auth-features" "api-arch" "docs")

while true; do
    running=0
    for task in "${TASKS[@]}"; do
        if tmux has-session -t "delegate-$task" 2>/dev/null; then
            ((running++))
            echo "[running] $task still running..."
        else
            echo "[done] $task completed"
        fi
    done

    if [[ $running -eq 0 ]]; then
        echo "All jobs complete."
        break
    fi

    echo "--- $running jobs running, checking again in 60s ---"
    sleep 60
done
```
