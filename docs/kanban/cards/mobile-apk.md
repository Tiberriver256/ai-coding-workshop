# mobile-apk

## Goal
Produce a real Android APK for the mobile app.

## Why
Sprint review requires a legitimate mobile application.

## Acceptance Criteria
- Android project created under `mobile/`.
- APK built and stored at `mobile/app/build/outputs/apk/` (or documented path).
- App supports QR connect or manual URL entry to review tasks.
- Appium test(s) cover one user flow.
- Kanban card updated with summary and evidence link.

## Owner
Delegate: Mobile engineer.

## Status
Done

## Summary
Built a Kotlin WebView Android app under `mobile/` with manual URL entry, debug APK output, and an Appium smoke test for loading the mobile review URL.

## Links
- PR/commit: (pending)
- Evidence: `mobile/app/build/outputs/apk/debug/app-debug.apk`

## Notes
- Use minimal dependencies; ensure build instructions in `docs/setup/README.md`.
- No file may exceed 500 lines.
