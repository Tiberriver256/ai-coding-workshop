# Pages - Vibe Kanban

List of distinct screens/views with purpose and key elements.

## Projects list
Purpose: Entry point for all boards/projects.
Key elements: page title, create project button, project card grid, empty state card, loading/error alerts.

## Project detail
Purpose: Snapshot of a single project and quick actions.
Key elements: back button, project title, status badge, metadata cards, actions (view tasks, edit, delete).

## Project tasks (Kanban board)
Purpose: Core task management board for a project.
Key elements: global navbar, search, create task button, Kanban columns, task cards, empty state.

## Task detail view (panel state)
Purpose: Read-only task overview with history.
Key elements: breadcrumb header, task content, attempts table, create attempt action.

## Task attempt view (panel state)
Purpose: Execution logs and follow-up interactions for a task attempt.
Key elements: log stream, todo summary, follow-up composer, git error banner.

## Preview view (auxiliary panel state)
Purpose: Live preview of running app.
Key elements: toolbar, iframe preview, error/help alert, log drawer.

## Diffs view (auxiliary panel state)
Purpose: Code changes review for an attempt.
Key elements: diff header, collapse/expand controls, diff cards, optional git operations area.

## Full attempt logs (standalone)
Purpose: Fullscreen log viewing (webview-oriented).
Key elements: logs, follow-up composer, minimal chrome.

## Settings shell
Purpose: Configure system, projects, organizations, agents, and MCP.
Key elements: sticky header, sidebar navigation, form-based content panels.

## UI-new workspace views (alternate experience)
Purpose: New UI workspace landing and workspace view.
Key elements: workspace list, conversation/log views, supporting panels.
