# Organisms - Vibe Kanban

Organisms are complex, multi-component sections.

## Global navigation bar
- Left: logo, external community badge
- Center: search input (contextual to project)
- Right: project actions (open in IDE, create task), settings, overflow menu
- Optional toggle for showing shared tasks

## Kanban board
- Horizontal scrollable grid of columns
- Column header with status dot, title, and add action
- Sticky column header with lightly tinted background
- Column body with stacked cards and visible drop targets

## Task card (standard)
- Title line with optional avatar
- Inline status icons (running, failed)
- Actions menu and contextual buttons (e.g., parent link)
- Optional description excerpt
- Selected state uses an inset highlight ring

## Task card (shared)
- Distinct left accent strip to indicate shared ownership
- Read-only or drag-disabled behavior for non-owners
- Avatar indicating assigned user

## Task detail panel
- Header with breadcrumb and action cluster
- Read-only rich text for title and description
- Attempts table with sortable timestamps
- Action to create new attempt

## Attempt panel (logs + follow-up)
- Log stream area with virtualized list
- Collapsible todo summary section
- Follow-up composer with rich text, attachments, and actions
- Inline alerts for conflicts or errors

## Preview panel
- Toolbar with URL, refresh/copy/open, stop controls
- Preview iframe area
- Empty or error states with guidance
- Optional logs drawer for server output

## Diffs panel
- Header with file counts and collapse/expand control
- Diff cards with expand/collapse behavior
- Optional git operations toolbar

## Settings shell
- Top header with title and close action
- Left navigation list with icons and labels
- Right content area for settings forms

## Modal dialogs
- Centered overlay with scrim
- Header, content, and footer action row
- Close icon in top-right
- Used for create/edit forms, confirmations, and sharing

## Context menus and dropdowns
- Triggered by icon buttons
- Sectioned lists with separators and destructive items
