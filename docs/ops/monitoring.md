# Slice 0001 Monitoring Plan

## Goals
Provide basic availability, performance, and client error visibility for the static Slice 0001 app.

## Minimal Signals
- Availability: `GET /` returns 200 and HTML content is served.
- Asset health: `GET /styles.css` and `GET /app.js` return 200.
- Client errors: JavaScript error rate from browser telemetry.
- Performance: page load metrics (TTFB/LCP) from synthetic or RUM.
- Core flow: ability to open the modal and create a task in the UI.

## Logs
- Static host/CDN access logs for status codes and latency.
- Client-side error logs (e.g., Sentry, Rollbar) for JS exceptions.
- Synthetic run logs for availability and flow checks.

## Alerts (minimal)
- **Site down:** synthetic check failing for 2 consecutive runs.
- **Asset failure:** `app.js` or `styles.css` 4xx/5xx spike.
- **JS errors:** sustained error rate above baseline (e.g., >1% sessions for 10 min).
- **Performance regression:** LCP or page load time over budget for 15 min.

## Recommended Implementations
- Synthetic check: headless browser loads `/` and verifies the "Create Task" button exists.
- RUM or error tracking: capture `window.onerror` and unhandled promise rejections.
- Uptime monitor: simple HTTP 200 check for `/` and `/app.js`.

## Dashboards
- Availability and response time (synthetic + access logs).
- Client error rate and top exceptions.
- Page performance (TTFB/LCP trends).

## Ownership
- Primary: SRE delegate.
- Escalation: product/engineering owner for Slice 0001.

## Runbook
- `docs/ops/runbook.md`
