# Blind User Test Protocol — Slice 0001

## Purpose
Validate that a first-time user can create a task on the Kanban board without guidance.

## Scope
- Slice: 0001 (Create a task on the Kanban board)
- Platform: Local web app (static server)
- Test type: Moderated, remote or in-person, single-session

## Research Questions
- Can a first-time user find how to create a task without instruction?
- Do labels, buttons, and form fields communicate their purpose?
- Where do users hesitate or make errors during task creation?

## Participant Criteria
- New to this product (no prior exposure).
- Comfortable with basic web apps.
- Preferably a mix of technical and non-technical roles.

## Materials & Setup
- Environment: Local repo running `scripts/serve-app.js`.
- Browser: Chromium/Chrome.
- Recording: Screen + audio (if permitted).
- Note-capture: Session template at `docs/testing/blind-user-tests/session-0001.md`.

## Task Script (Blind)
1. "You are looking at a Kanban board. Please add a new task for something you want to track."
2. If stuck for >60s: "What would you try next?"
3. If still stuck for >120s: Offer minimal nudge: "Look for a control that adds a task."

## Success Criteria
- User creates a task that appears in "To Do".
- User completes task within 2 minutes without direct instruction.

## Metrics to Capture
- Time to first click.
- Time to task created.
- Errors (e.g., validation issues).
- Assistance level (none, prompt, nudge).

## Data Capture
- Task completion outcome.
- Observed friction points.
- User quotes (anonymized).
- Follow-up questions and clarifications.

## Risks & Mitigations
- Risk: Participants recognize the UI from prior work. Mitigation: Pre-screening question.
- Risk: Facilitator bias. Mitigation: Use the blind script verbatim.

## Logistics
- Session length: 15 minutes.
- Target sessions: 3–5 participants.
- Scheduling window: Within 1 week of protocol approval.
