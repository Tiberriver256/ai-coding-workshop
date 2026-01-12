# Slice 0001 Local Task Creation and Persistence

Status: Accepted

## Context
Slice 0001 delivers the first end-to-end Kanban capability: create a task in the board UI and see it in the "To Do" column, with persistence across refreshes. There is no backend or multi-user sync in this slice, but later slices will introduce orchestration and streaming.

## Decision
Adopt a local-first, single-writer task model with write-through persistence and deterministic identifiers:
- Tasks are created in the client with a minimal canonical shape: `id`, `title`, `description`, `status`, `createdAt`, `updatedAt`.
- The UI writes through to a local persisted store immediately on create/update, then reads from the same store on reload.
- Task identifiers are globally unique to allow safe future synchronization and reconciliation.
- Validation is enforced at the interaction boundary (e.g., non-empty title) and failed submissions do not mutate storage.
- The slice assumes a single user and no concurrent edits; no conflict resolution is implemented yet.

## Quality Attribute Scenarios (Gherkin)
```gherkin
Feature: Local persistence for Slice 0001

  Scenario: Recover tasks after refresh
    Given a task is created in the board UI
    When the client is reloaded
    Then the task appears in the "To Do" column from local persistence

  Scenario: Reject invalid tasks without persistence
    Given the create-task form is open
    When the user submits without a title
    Then the UI shows a validation error
    And no task is persisted
```

## Consequences
- Slice 0001 can be verified end-to-end without backend dependencies.
- Future slices must provide migration or versioning when the local schema evolves.
- Introducing multi-user sync later will require conflict resolution and reconciliation logic that is out of scope for this slice.
