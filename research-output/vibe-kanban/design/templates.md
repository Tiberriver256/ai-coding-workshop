# Templates - Vibe Kanban

Templates describe page-level layout structures without binding to content.

## Board view layout
- Global navigation bar on top
- Main canvas below with horizontal scrolling board
- Empty state card centered when no tasks
- Search and filters applied at board level

## Split-view board + detail layout
- Left: Kanban board
- Right: detail panel
- Resizable vertical divider between panes
- Detail panel includes sticky header and scrollable body

## Split-view detail + auxiliary layout
- Used when preview or diffs are active
- Right side splits into two panes: details and auxiliary (preview/diffs)
- Resizable divider between detail and auxiliary
- Kanban board collapses when auxiliary is active

## Mobile board layout
- Single-column stack
- When a card is selected, board hides and detail view takes focus
- Auxiliary (preview/diffs) replaces detail view on demand

## Detail panel layout
- Header with breadcrumbs and action buttons
- Main content area with editor or logs
- Optional secondary sections (todos, follow-up)

## Settings layout
- Sticky header with title and close action
- Left sidebar navigation
- Right scrollable content area

## Modal layout
- Centered dialog with scrim
- Title + description + form fields
- Primary and secondary actions at footer
