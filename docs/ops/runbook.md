# Slice 0001 Runbook

## Scope
Slice 0001 is a static web app for creating tasks on a local board. It runs entirely in the browser and stores tasks in `localStorage`. There is no backend, database, or multi-user sync.

## System Overview
- Entry point: `app/index.html`
- Assets: `app/styles.css`, `app/app.js`
- Storage: Browser `localStorage` key `slice0001.tasks`
- Execution: Static file host or local HTTP server

## Startup

### Local (developer)
1. Run: `python3 -m http.server 8000 --directory app`
2. Open: `http://localhost:8000`
3. Verify:
   - Page loads with "Local Task Board" header.
   - "Create Task" opens modal.
   - Submit a task and see it appear in "To Do".
   - Refresh page and confirm the task persists.

### Production (static hosting)
1. Deploy the contents of `app/` to the static host root.
2. Ensure `index.html` is served at the site root and assets are accessible.
3. Verify the same checks as local.

## Shutdown
- Local: Stop the HTTP server (Ctrl+C).
- Production: Disable the deployment or roll back to a maintenance page.

## Recovery and Troubleshooting

### Site does not load
- Confirm the static host and DNS/CDN health.
- Check for 404s on `index.html`, `styles.css`, `app.js`.
- Roll back to the last known good build if recent changes caused the issue.

### Page loads but UI is broken
- Open browser devtools console and note JavaScript errors.
- If errors are new, roll back to the previous static asset bundle.

### Tasks do not persist after refresh
- Check browser storage permissions or privacy mode.
- Inspect `localStorage` for `slice0001.tasks`.
- If the stored value is corrupt, clear site data (this deletes local tasks).

### Modal does not open or submit
- Confirm `app.js` is loaded (Network tab).
- Test in a second browser to rule out extensions.

## Data Loss Notes
- All data is local to the browser. There is no server-side recovery.
- Clearing site data or using a different browser/device removes tasks.

## Support Checklist
- User impact and severity (single user vs. widespread).
- Browser, OS, and whether private mode is used.
- Reproduction steps and timestamps.
- Console errors (copy/paste) and screenshots.
- Network errors (failed asset requests).
- `localStorage` key presence and size.
- Any recent deployment or cache changes.

## Escalation
- If rollback or static host fixes do not resolve the issue, open an incident ticket and include the checklist above.
