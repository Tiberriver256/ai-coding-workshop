# Slice Plan

Smallest vertical slices in priority order. Each slice must be end-to-end and verifiable.

## Slice 0001 — Create a task on the Kanban board

**Outcome**: A user can create a task from the board UI and see it in the "To Do" column.

**Scope**
- In scope:
  - Board view renders status columns and includes "To Do".
  - Create Task dialog with fields for title and description.
  - "Create" action adds a task card to the "To Do" column.
  - Local persistence restores tasks after refresh.
  - "Cancel" closes the dialog without creating a task.
- Out of scope:
  - Agent execution or orchestration.
  - "Create & Start" behavior (may be hidden or disabled).
  - Search, drag-and-drop, or status transitions beyond initial "To Do".
  - Backend persistence or multi-user sync.

**Acceptance Criteria**
- Scenario: Tasks appear in status columns
  - When I open the project board, then I see a column labeled "To Do".
- Scenario: Create a task without starting an agent
  - Given I am on the project board, when I open the Create Task dialog, enter a title and description, and choose "Create", then the task appears in the "To Do" column.
- Scenario: Task creation requires a title
  - When I leave the title empty and submit, then I see a validation error and the task is not created.
- Scenario: Cancel task creation
  - When I choose "Cancel", then no task is created and the dialog closes.
- Scenario: Restore tasks after refresh
  - Given I create a task, when I reload the app, then the task appears in "To Do" from local persistence.
- Evidence captured in `docs/testing/acceptance/`.

**Related features**
- `docs/features/kanban-board.feature`
- `docs/features/task-orchestration.feature`

## Next Slices (placeholders)
- Slice 0002 — Start task attempt and show execution status (stubbed agent OK)
- Slice 0003 — Remote session access to agent run (minimal connectivity)
