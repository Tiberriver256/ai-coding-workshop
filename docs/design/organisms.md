# Organisms

Complex sections composed of multiple molecules, tailored to agent orchestration and coding workflows.

## Global navigation
- Top app bar with project switcher, search, create task, notifications, user menu.
- Secondary rail for devices/sessions on wide screens.
- Connection status strip (P2P/relay/offline).

## Connection status organism
- Compact status bar or pill shown globally and inside session headers.
- States: P2P, Relay, Reconnecting, Offline.
- Indicators: connection type icon, encryption lock icon, latency value, last heartbeat time.
- Inline actions: “Try P2P”, “Copy diagnostics”, “View network status”.
- Error states show brief guidance and a retry action.

## Kanban board
- Horizontal columns with sticky headers and status tint.
- Drag-and-drop task cards with drop targets.
- Column-level add action and filters.

## Task card (agent-aware)
- Title + description excerpt.
- Status icons (running, awaiting-approval, failed).
- Assignee/agent avatars and attempt count.
- Inline actions (open, start attempt, stop).

## Task detail panel
- Breadcrumb header and status chip.
- Tabs: Overview, Attempts, Diffs, Approvals, Audit.
- Attempt timeline with start/stop events.

## Agent execution monitoring panel
- Live log stream with streaming highlight.
- Process list with status and timestamps.
- Control bar: stop, pause, retry, open terminal.

## Multi-agent execution panel
- Parallel agent list with per-agent status chips and progress.
- Shared timeline showing concurrent steps and dependency gates.
- Aggregate controls: stop all, pause all, retry failed.
- Per-agent detail drawer with logs, tools used, and permissions requested.
- Conflict banner when agents touch overlapping files.

## Diff review panel
- File list with change counts.
- Inline/split diff viewer.
- Commenting lane with line anchors.
- Review composer with summary and submit.

## Approval workflow panel
- Permission request card (scope, tools, files).
- Approve/deny controls with rationale input.
- Audit trail of approvals and denials.

## QR pairing UI
- QR code display with fallback link.
- Pairing request card on mobile (approve/reject).
- Timeout and retry state with guidance.

## Remote session view
- Session header (device, path, agent mode).
- Message thread + tool cards.
- Permission prompts embedded inline.
- Abort / stop controls.

## Notification center
- Stream of system notifications, agent alerts, and approvals.
- Grouped by project and time (Today, Earlier).
- Severity badges (info/warn/error) and read/unread state.
- Quick actions: view task, approve, retry, dismiss.
- Empty state with guidance on enabling notifications.

## PR creation panel
- PR summary (title, description, base branch).
- Provider picker (GitHub, Azure DevOps).
- Status feedback with error guidance if CLI missing.

## Settings shell
- Left navigation list with sections.
- Right content with forms and toggles.
- Subsections: Integrations, Agents, Security, Devices, Appearance.
