# Templates

Page-level layout structures that support core workflows.

## Board view template
- Top navigation bar.
- Main board canvas with horizontal scroll.
- Optional right-side detail panel (collapsed by default on compact screens).

## Split-view detail template
- Left: board (collapsible).
- Right: task detail with tabs.
- Resizable divider between panes.

## Split-view with auxiliary panel
- Detail panel + auxiliary (diffs/preview/logs).
- Auxiliary can be docked or full height.

## Remote session template
- Header with device + path.
- Session stream content.
- Docked composer or action bar.
- Optional floating approvals tray.

## Review template
- File list rail on left.
- Diff viewer center.
- Comments panel right (optional in compact).

## Settings template
- Persistent left navigation.
- Right content area with grouped sections.
- Sticky save/confirm actions when needed.

## Onboarding / pairing template
- Centered instructions.
- QR or link display.
- Progress status and retry controls.

## Mobile templates
- Stacked single-column view.
- Bottom sheet for quick actions.
- Fullscreen modal for approvals and pairing.

## Mobile task detail template
- Sticky header with task title and status chip.
- Tabbed or segmented content: Overview, Attempts, Diffs, Audit.
- Primary action bar anchored to bottom (start/stop, review, comment).
- Collapsible sections to reduce scroll length.

## Mobile approval flow template
- Fullscreen modal with decision context at top.
- Permission scope summary card (files, tools, commands).
- Approve/Deny buttons with optional rationale input.
- Persistent safety note and link to audit history.

## Mobile session control template
- Compact header with device status and connection type.
- Message stream with large tap targets.
- Floating quick actions (abort, pause, approve) within thumb reach.
- Latency and encryption indicators visible without scrolling.
