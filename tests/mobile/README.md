# Mobile Appium Test

## Prereqs
- Android emulator or device running.
- Appium server running (`appium`).
- Node dependencies installed: `npm install -D webdriverio`.

## Run
1. Build the debug APK:
   ```bash
   cd mobile
   ./gradlew assembleDebug
   ```
2. Run the Appium script from repo root:
   ```bash
   node tests/mobile/appium-basic-flow.js
   ```

## Config overrides
- `APK_PATH` to point at a custom APK.
- `MOBILE_REVIEW_URL` to change the URL loaded in the app.
- `APPIUM_HOST`, `APPIUM_PORT`, `APPIUM_DEVICE` to target different Appium endpoints/devices.
