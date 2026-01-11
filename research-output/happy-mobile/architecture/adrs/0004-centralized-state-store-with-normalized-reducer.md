# Centralized State Store With Normalized Message Reducer

## Status
Accepted

## Context
The client consumes a continuous stream of updates for sessions, messages, tool calls, permissions, and sidechains. Updates can arrive out of order or be repeated. The UI requires a consistent, deduplicated representation across multiple screens.

## Decision
Maintain a single client-side state store that owns canonical session and message data. Normalize incoming records and process them through a message reducer that handles deduplication, ordering, tool-call lifecycle, and sidechain association in an idempotent manner. Expose read-only selectors for UI views and apply updates through controlled store methods.

## Consequences
- Provides a consistent source of truth for all UI surfaces.
- Simplifies reasoning about update processing and idempotency.
- Reducer logic becomes complex and must be carefully tested.
- Enables separation between transport concerns and view rendering.
