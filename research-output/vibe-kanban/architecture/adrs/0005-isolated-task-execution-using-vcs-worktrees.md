# Isolated Task Execution Using VCS Worktrees

Status: Accepted

## Context
Multiple task attempts can run concurrently and should not interfere with each other or the user's main working directory. The system needs repeatable, isolated workspaces for each attempt.

## Decision
Create an isolated version-control worktree for each task attempt, with lifecycle management and cleanup after execution. Use synchronization to prevent race conditions when creating or recreating worktrees.

## Consequences
- Concurrent task attempts are isolated, reducing merge conflicts and interference.
- Additional disk usage and lifecycle management are required.
- Cleanup and recovery paths must handle interrupted or partially created worktrees.
