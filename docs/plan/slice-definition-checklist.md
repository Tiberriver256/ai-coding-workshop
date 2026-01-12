# Slice Definition Checklist

Use this checklist before moving any slice card to In Progress. The goal is to create a shared, unambiguous signal for downstream work.

## Checklist

### Outcome and scope
- Outcome statement is single-sentence and testable.
- In-scope and out-of-scope lists are explicit.
- Key edge cases are listed (minimum 2 if applicable).

### Acceptance criteria
- Scenarios written in Given/When/Then format.
- At least one negative/validation scenario included.
- Evidence capture location named (file or folder path).

### Dependencies and risks
- Dependencies listed (docs, features, external inputs).
- Known risks or assumptions captured in one short bullet list.

### Readiness signal
- Checklist link is attached to the kanban card.
- Readiness tag set to Ready once all items are complete.

## Usage
- Add the checklist link to the slice card before grooming.
- If any item is missing, set the readiness tag to Needs Definition and keep the card out of In Progress.

## Related
- `docs/plan/slice-plan.md`
- `docs/kanban/board.md`
