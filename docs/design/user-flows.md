# User Flows

Key journeys for the kanban-first agent orchestration experience.

## Onboarding and QR pairing
1. User installs the unified CLI on their computer.
2. User opens mobile app and signs in.
3. User runs pairing on CLI and selects QR option.
4. CLI displays QR + fallback link.
5. User scans QR in mobile app.
6. Mobile shows pairing request details (device name, location, timestamp).
7. User approves or rejects.
8. Success: device appears in Devices list with connection status.
9. Failure: invalid/expired link shows recovery guidance.

## Create task and start agent
1. User opens project board.
2. User selects Create Task.
3. User enters title, description, scope, and optional agent config.
4. User chooses Create or Create & Start.
5. Task appears in To Do or In Progress based on choice.
6. If started, attempt begins and status transitions to Running.

## Agent monitoring and control
1. User opens task attempt view.
2. Live log stream appears with streaming highlights.
3. User opens Processes to view running subprocesses.
4. User can Stop or Pause; confirmation required.
5. Attempt status updates to Stopped or Paused and is logged in audit trail.

## Approval workflow
1. Agent requests permission (tool, file, or command).
2. System surfaces approval card in task and remote session.
3. User reviews scope details and rationale.
4. User approves or denies with optional comment.
5. Decision is recorded in audit log and reflected in task status.
6. Agent proceeds or halts based on decision.

## Remote session access
1. User opens Remote Sessions on web or mobile.
2. User selects device and chooses a project path.
3. Session starts remotely; connection status shows P2P or relay.
4. User sends messages; agent responds in real time.
5. User can abort a request or end session.

## Copilot CLI integration (connect + autocomplete)
1. User opens Settings > Integrations.
2. User selects Copilot CLI and chooses Connect.
3. System checks for local installation and authentication.
4. If missing, user sees install/auth instructions and a retry action.
5. On success, Copilot is marked Connected and available for prompts.
6. User opens Create Task or Edit Task description.
7. User triggers Autocomplete and selects a suggestion.
8. Suggestion inserts into the task description and is editable.

## Codex CLI integration (session execution)
1. User opens Settings > Integrations and verifies Codex CLI status.
2. If not installed, user sees install instructions and a recheck action.
3. User starts a task attempt with Codex as the selected agent.
4. System starts a Codex session and binds it to the task attempt.
5. Live logs and status appear in the attempt view.
6. User can pause/stop; session ends with status and audit entry.

## Connection fallback (P2P to relay)
1. User starts a remote session; connection status shows P2P.
2. Connectivity degrades (NAT change or network loss).
3. Status organism indicates “Reconnecting” with latency and encryption indicator.
4. System attempts P2P retries; if unsuccessful, falls back to relay.
5. Status updates to Relay with increased latency and a brief explanation.
6. If P2P becomes available again, user can “Try P2P” to return.

## Multi-agent workstreams (dependencies + parallel execution)
1. User creates a task with dependent subtasks or linked tasks.
2. User assigns multiple agents to parallel tasks or lanes.
3. System visualizes dependencies (blocked/ready indicators).
4. Agents execute in parallel where dependencies allow.
5. Completion of a dependency unblocks downstream tasks automatically.
6. User monitors all agents in a combined execution panel.

## Code review and feedback loop
1. Task moves to In Review after attempt completes.
2. User opens Diff Review.
3. User reviews file list and opens a diff.
4. User adds line comments and summary feedback.
5. User submits review; task returns to In Progress with feedback attached.

## PR creation (GitHub/Azure DevOps)
1. User opens a task with completed changes.
2. User selects Create PR and chooses provider.
3. System validates CLI authentication status.
4. User selects base branch and confirms title/description.
5. PR is created and task shows PR status badge.
6. If provider is not configured, user sees setup instructions.
