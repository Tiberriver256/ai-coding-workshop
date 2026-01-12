# User Guide - Slice 0001

Practical basics for using the Slice 0001 local task board.

## Quickstart
1. Open the Slice 0001 app in your browser.
   - If you have not started the app yet, follow `docs/setup/README.md` first.
2. Select **Create Task**.
3. Enter a title (required) and an optional description.
4. Select **Create Task** to add the task to **To Do**.
5. Refresh the page to confirm the task persists.

## Key Behaviors
- **Single status column**: Slice 0001 only supports the **To Do** column.
- **Local-only data**: Tasks are stored in your browser on this device; there is no server sync.
- **Title required**: Submitting an empty title shows a validation error and does not create a task.
- **Cancel safely**: **Cancel**, the **X** button, clicking outside the dialog, or pressing **Esc** closes the dialog without creating a task.
- **Newest first**: Newly created tasks appear at the top of the **To Do** list.
- **Empty state**: When no tasks exist, the board shows a “No tasks yet” message.

## Common Use Cases
- **Capture a task quickly**: Open the dialog, add a short title, and save it to **To Do**.
- **Add detail later**: Enter a quick title now and a description when you have more context.
- **Verify persistence**: Refresh the page after creating tasks to ensure they remain visible.

## Data Storage & Limits
- Tasks are saved to browser local storage under the key `slice0001.tasks`.
- Title limit: 120 characters.
- Description limit: 500 characters.

## Troubleshooting
- **Task did not save**: Confirm your browser allows local storage for the app URL.
- **Tasks disappeared after refresh**: Ensure you are using the same browser profile and device.
- **Need a reset**: Clear the `slice0001.tasks` local storage entry for the app URL to remove all tasks.

## What Slice 0001 Does Not Do
- No status changes beyond **To Do** (no drag-and-drop or transitions).
- No multi-user sync or backend persistence.
- No “Create & Start” agent execution.
