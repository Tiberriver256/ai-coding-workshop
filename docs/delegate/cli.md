# Delegate CLI Reference

Command-line options and role management for `delegate.sh`.

## Command Line Options

| Option | Long Form               | Description                                         |
| ------ | ----------------------- | --------------------------------------------------- |
| `-r`   | `--role`                | Role description of the ideal person for this task  |
| `-c`   | `--common-role`         | Use a predefined role from `utilities/common-roles/<name>.md` |
| `-g`   | `--goal`                | The goal/objective of the task                      |
| `-a`   | `--acceptance-criteria` | Success criteria for task completion                |
| `-w`   | `--why`                 | The reasoning behind the task                       |
| `-t`   | `--task-detail`         | Detailed task instructions                          |
| `-n`   | `--name`                | Task name (used in log filenames)                   |
| `-f`   | `--foreground`          | Run in foreground instead of tmux session           |
| `-l`   | `--list-roles`          | List available common roles                         |
| `-s`   | `--status`              | Show detailed status of running sessions            |
|        | `--check`               | Quick check if a specific session is running/done   |
|        | `--check-all`           | Quick status check of all delegate sessions         |
|        | `--continue`            | Send follow-up message to continue a conversation   |
| `-k`   | `--kill`                | Kill a specific running session                     |
|        | `--clean`               | Kill all idle sessions (completed, waiting on read) |
|        | `--clean-all`           | Kill ALL delegate sessions (including running)      |
|        | `--purge [name]`        | Kill session(s) AND delete their log files          |
| `-h`   | `--help`                | Show help message                                   |

## Common Roles

Predefined roles are stored in `utilities/common-roles/` as markdown files. Use them with `-c` or `--common-role`:

```bash
# List available roles
./delegate.sh --list-roles

# Use a common role
./delegate.sh -c feature-analyst -g "Extract auth features" -t "..."
./delegate.sh --common-role architect -g "Document API patterns" -t "..."
```

### Available Roles

| Role Name                | Description                                           |
| ------------------------ | ----------------------------------------------------- |
| `feature-analyst`        | BDD/Gherkin expert for user-facing feature extraction |
| `architect`              | ADR writer focusing on patterns, not tech stack       |
| `code-reviewer`          | Identifies bugs, security issues, and improvements    |
| `technical-writer`       | Creates clear documentation with examples             |
| `refactoring-specialist` | Incremental improvements with backward compatibility  |

### Adding Custom Roles

Create a markdown file in `utilities/common-roles/`:

```markdown
# My Custom Role

Description of the role's expertise, focus areas, and approach.
Keep it to 2-3 sentences that set the right mindset.
```

Then use it: `./delegate.sh -c my-custom-role -g "..." -t "..."`
