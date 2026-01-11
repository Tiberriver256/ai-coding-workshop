# User Flows - Vibe Kanban

Key journeys described in product language (no implementation detail).

## Board creation / setup
1. User enters Projects list.
2. Selects "Create project".
3. Completes project form (name, repo linking if applicable).
4. Project appears in grid; user opens it to reach the Kanban board.

## Task creation and management
1. User clicks "Create task" from the navbar or empty state.
2. Task form dialog opens with fields for title, description, status, and optional execution settings.
3. User submits; task appears in "To Do" column.
4. User can open the task card to view details or edit from actions menu.
5. User can duplicate, delete, or create a subtask from task actions.

## Drag-and-drop interaction
1. User clicks and drags a task card.
2. Card follows cursor and snaps into columns.
3. Dropping in a new column updates status.
4. Shared or read-only tasks disable drag behavior.

## Task detail editing
1. User clicks a task card to open the detail panel.
2. Breadcrumb header shows task and attempt context.
3. Task content and attempts list are visible.
4. User creates a new attempt from the attempts table action.

## Attempt follow-up
1. User opens an attempt in the detail panel.
2. Logs stream in the main area.
3. User writes follow-up message in the composer and submits.
4. Status indicators show running or completed state.

## Preview and diffs
1. User switches to Preview or Diffs via toolbar toggles.
2. Board collapses; detail and auxiliary panels split.
3. User interacts with preview toolbar or expands/collapses diffs.

## Collaboration and sharing
1. User selects "Share" from task actions.
2. Shared task appears with an accent strip and assignee avatar.
3. Owners can reassign or stop sharing; non-owners view read-only.
4. Users can toggle visibility of shared tasks in the navbar.
