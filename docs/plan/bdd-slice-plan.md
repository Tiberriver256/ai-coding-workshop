# BDD Slice Plan

## Inputs Reviewed
- Feature files: `docs/features/*.feature`.
- `docs/folder-structure.md`: not found in repo on January 11, 2026 (plan proceeds without it).

## Test Harness Legend
- Playwright: web app UI and browser-driven flows.
- Appium: mobile app UI flows.
- CLI: terminal-driven CLI flows (unified/Codex/Copilot).
- Hybrid: multi-surface flows that require more than one harness.

## Slice Index (Ordered)
- BDD-0001: Task creation baseline (board visible, create, validate, cancel) — Playwright.
- BDD-0002: Kanban board interactions (manual move, search) — Playwright.
- BDD-0003: Task attempts + status transitions — Playwright (agent stub OK).
- BDD-0004: Code review experience — Playwright.
- BDD-0005: Agent execution monitoring — Playwright.
- BDD-0006: GitHub PR integration — Playwright + CLI.
- BDD-0007: Azure DevOps PR integration — Playwright + CLI.
- BDD-0008: Copilot CLI integration + task prompt autocomplete — Playwright + CLI.
- BDD-0009: Codex CLI session start — CLI.
- BDD-0010: Device pairing via QR/link — Hybrid (CLI + Appium).
- BDD-0011: Encrypted session access + recovery — Hybrid (CLI + Appium).
- BDD-0012: Remote session access + approvals — Hybrid (Appium + Playwright + CLI/daemon).

## Selected Slice BDD-0001 (Anchor Scenario)
**Scenario**: Task orchestration → “Create a task without starting an agent.”

**Acceptance Criteria**
- When I open the Create Task dialog from the board, I can enter a title and description.
- When I choose “Create”, the task appears in the “To Do” column.
- No agent attempt starts as part of this action.
- The dialog closes and the task card shows the entered title/description.

**Tests (Harness: Playwright)**
- Automated: `tests/acceptance/slice-0001.spec.js` (create task, validation, cancel, persistence).
- Evidence: `docs/testing/acceptance/slice-0001.md`.

## Scenario-to-Slice Map
| Slice | Feature | Scenario | Harness |
| --- | --- | --- | --- |
| BDD-0005 | agent-execution-monitoring | View real-time execution logs | Playwright |
| BDD-0005 | agent-execution-monitoring | View all processes for an attempt | Playwright |
| BDD-0005 | agent-execution-monitoring | Abort a running attempt | Playwright |
| BDD-0005 | agent-execution-monitoring | No processes available | Playwright |
| BDD-0007 | azure-devops-support | Create a pull request on Azure DevOps (happy path) | Playwright + CLI |
| BDD-0007 | azure-devops-support | Azure CLI not configured | Playwright + CLI |
| BDD-0007 | azure-devops-support | Repository is not an Azure Repos project | Playwright |
| BDD-0004 | code-review | Open the diff view | Playwright |
| BDD-0004 | code-review | Add line-specific comments | Playwright |
| BDD-0004 | code-review | Submit review feedback | Playwright |
| BDD-0004 | code-review | No code changes yet | Playwright |
| BDD-0009 | codex-cli-support | Start Codex mode when authenticated | CLI |
| BDD-0009 | codex-cli-support | Prompt for authentication before starting Codex | CLI |
| BDD-0009 | codex-cli-support | Codex CLI is not installed locally | CLI |
| BDD-0008 | copilot-cli-support | Enable Copilot CLI integration (happy path) | Playwright + CLI |
| BDD-0008 | copilot-cli-support | Use Copilot CLI to autocomplete a task prompt | Playwright + CLI |
| BDD-0008 | copilot-cli-support | Copilot CLI is not installed | Playwright + CLI |
| BDD-0008 | copilot-cli-support | Copilot CLI is installed but not authenticated | Playwright + CLI |
| BDD-0010 | device-pairing-qr | Pair using a QR code (happy path) | Hybrid (CLI + Appium) |
| BDD-0010 | device-pairing-qr | Pair using a manual connection link | Hybrid (CLI + Appium) |
| BDD-0010 | device-pairing-qr | Reject a pairing request | Hybrid (CLI + Appium) |
| BDD-0010 | device-pairing-qr | Handle an invalid connection link | Appium |
| BDD-0010 | device-pairing-qr | Re-pair a computer after forcing re-authentication | Hybrid (CLI + Appium) |
| BDD-0011 | encrypted-point-to-point-connectivity | Session messages are readable only on paired devices | Hybrid (CLI + Appium) |
| BDD-0011 | encrypted-point-to-point-connectivity | New devices require a recovery secret to decrypt data | Appium |
| BDD-0011 | encrypted-point-to-point-connectivity | Logging out removes access to encrypted data on that device | Hybrid (CLI + Appium) |
| BDD-0006 | github-support | Create a pull request from a task attempt (happy path) | Playwright + CLI |
| BDD-0006 | github-support | Missing GitHub CLI authentication prevents PR creation | Playwright + CLI |
| BDD-0006 | github-support | Target branch does not exist on remote | Playwright |
| BDD-0001 | kanban-board | Tasks appear in status columns | Playwright |
| BDD-0003 | kanban-board | Task status updates from agent activity | Playwright |
| BDD-0002 | kanban-board | Manually move a task without triggering agent work | Playwright |
| BDD-0002 | kanban-board | Search tasks on the board | Playwright |
| BDD-0012 | remote-session-access | A session started on the computer appears remotely | Hybrid (Appium + Playwright + CLI/daemon) |
| BDD-0012 | remote-session-access | Start a session in a chosen directory from the mobile app | Hybrid (Appium + CLI/daemon) |
| BDD-0012 | remote-session-access | Start a session in a chosen directory from the web app | Hybrid (Playwright + CLI/daemon) |
| BDD-0012 | remote-session-access | Send a message from the mobile app to the session | Hybrid (Appium + CLI/daemon) |
| BDD-0012 | remote-session-access | Abort a running request from the web app | Hybrid (Playwright + CLI/daemon) |
| BDD-0012 | remote-session-access | Approve a permission request remotely | Hybrid (Appium + CLI/daemon) |
| BDD-0012 | remote-session-access | Daemon is offline when starting a session | Appium |
| BDD-0001 | task-orchestration | Create a task without starting an agent | Playwright |
| BDD-0003 | task-orchestration | Create and start a task attempt immediately | Playwright |
| BDD-0008 | task-orchestration | Autocomplete task instructions with an AI assistant | Playwright + CLI |
| BDD-0001 | task-orchestration | Task creation requires a title | Playwright |
| BDD-0001 | task-orchestration | Cancel task creation | Playwright |

## Dependencies and Gaps
- `docs/folder-structure.md` is missing; add or confirm location before implementation work starts.
- Hybrid slices assume mobile harness + CLI/daemon wiring is available.
