# Delegate Troubleshooting

Monitoring, debugging, and common fixes.

## Monitoring and Debugging

### Watch a Running Task

```bash
# Follow stderr (verbose output)
tail -f /tmp/delegate-logs/*my-task*_stderr.log

# Follow stdout (final output)
tail -f /tmp/delegate-logs/*my-task*_stdout.log
```

### Check if Tasks are Running

```bash
ps aux | grep "codex exec" | grep -v grep
```

### Search Past Logs

```bash
# Find tasks that created certain files
grep -r "created.*\.feature" /tmp/delegate-logs/

# Find errors
grep -r "error\|failed\|Error" /tmp/delegate-logs/*stderr.log
```

### Kill a Running Task

```bash
# Find the PID
ps aux | grep "codex exec" | grep -v grep

# Kill it
kill <PID>
```

## Troubleshooting

### Task Hangs

```bash
# Check if codex is waiting for input
tail -20 /tmp/delegate-logs/*task-name*_stderr.log

# May need to kill and restart with more specific instructions
```

### No Output Files Created

- Check the task detail has correct output paths.
- Verify the agent has write permissions.
- Look for errors in stderr logs.

### Agent Goes Off Track

- Make acceptance criteria more specific.
- Add explicit "DO NOT" instructions in task detail.
- Break into smaller, more focused tasks.

## Best Practices

### 1. Be Specific in Task Details

Bad:
```
-t "Document the code"
```

Good:
```
-t "Create API documentation for /src/api/*.ts files. Include:
- Function signatures with parameter descriptions
- Return value documentation
- Usage examples for each endpoint
- Error codes and their meanings
Output to /docs/api/"
```

### 2. Set Clear Acceptance Criteria

Bad:
```
-a "Code should be good"
```

Good:
```
-a "All functions have JSDoc comments, README.md exists with setup instructions, no TypeScript errors"
```

### 3. Use Meaningful Task Names

Bad:
```
-n "task1"
```

Good:
```
-n "auth-module-docs"
```

### 4. Provide Context with The Why

```
-w "We're onboarding 5 new developers next month and need documentation
    to reduce ramp-up time from 2 weeks to 3 days"
```

### 5. Break Large Tasks into Smaller Ones

Instead of one massive task, create focused parallel tasks:
- Features extraction (one per module)
- Architecture extraction (separate from features)
- Documentation (separate from code changes)
