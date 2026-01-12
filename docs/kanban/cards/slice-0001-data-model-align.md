# slice-0001-data-model-align

## Goal
Align Slice 0001 app task model with ADR canonical fields.

## Why
Prevent drift between documented architecture and implementation.

## Acceptance Criteria
- Tasks include `status`, `createdAt`, `updatedAt` fields (default status "todo").
- Backward compatibility for existing localStorage data.
- Kanban card updated with summary and evidence link.

## Owner
Delegate: Frontend engineer.

## Status
Done

## Summary
Aligned task persistence with ADR fields by adding `status` and `updatedAt`, plus defaults for legacy tasks.

## Links
- PR/commit: (pending)
- Evidence: [app/app.js](../../../app/app.js)

## Notes
- Keep files under 500 lines.
- Minimal UI changes; no new features beyond data model alignment.
