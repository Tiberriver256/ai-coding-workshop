# Release 0001 Scope

## Decision
Release 0001 launch scope is limited to **Slice 0001** only.

## In Scope
- Slice 0001 — Create a task on the Kanban board.
  - Board renders status columns including "To Do".
  - Create Task dialog with title + description.
  - "Create" adds a task card to "To Do".
  - Validation requires a title.
  - "Cancel" closes without creating a task.
  - Local persistence restores tasks after refresh.

## Out of Scope
- Slices 0002+ (execution status, remote session access).
- Agent execution/orchestration.
- Search, drag-and-drop, or status transitions beyond initial "To Do".
- Backend persistence or multi-user sync.

## Rationale
- Slice 0001 is the smallest vertical, end-to-end slice that validates the core board flow.
- Acceptance evidence exists for Slice 0001, enabling a clear "core slices" definition for Release 0001.
- Deferring later slices reduces scope risk while preserving a usable baseline for readiness checks.

## Evidence
- Slice definition: `docs/plan/slice-plan.md`.
- Acceptance evidence: `docs/testing/acceptance/slice-0001.md` (January 11, 2026).

## Implications
- Release readiness should be evaluated against Slice 0001 only.
- Checklist items tied to "core slices" should reference this scope.
