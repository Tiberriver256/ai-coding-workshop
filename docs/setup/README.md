# Setup - Slice 0001

Practical setup steps for running the Slice 0001 app and performing the current test runbook.

## Prerequisites
- Node.js and npm (CLI server + automated tests).
- Modern web browser (Chrome, Firefox, Safari, or Edge).
- Repo cloned locally.

## Lockfile policy (500-line rule)
This repo does not track npm lockfiles to keep all files under 500 lines.

- `.npmrc` sets `package-lock=false` to prevent `package-lock.json` generation.
- Use `npm install` as usual; do not commit lockfiles (they are ignored).

## llm-tldr (code navigation)
The `llm-tldr` tool is vendored at `tools/llm-tldr/` for local inspection and installs.

1. Install from the vendored copy (recommended):
   ```bash
   python3 -m venv .venv
   source .venv/bin/activate
   pip install -e tools/llm-tldr
   ```
2. Index the repo once:
   ```bash
   tldr warm .
   ```
3. Use it for summaries or search:
   ```bash
   tldr context main --project .
   tldr semantic "task persistence" .
   ```

## Changelog + commit hygiene
We use Conventional Commits and commitlint so the changelog can be generated reliably.

1. Install Node dependencies:
   ```bash
   npm install
   ```
2. Enable the local commit-msg hook:
   ```bash
   ./scripts/setup-githooks.sh
   ```
   Or manually:
   ```bash
   git config core.hooksPath .githooks
   ```
3. Validate commit messages before updating the changelog:
   ```bash
   npx commitlint --from HEAD~20 --to HEAD
   ```
   (Use a wider range or a tag like `--from v0.1.0` if available.)
4. Refresh the Unreleased section in `CHANGELOG.md`:
   ```bash
   node scripts/update-changelog.js
   ```
   Optional range override:
   ```bash
   node scripts/update-changelog.js --from v0.1.0 --to HEAD
   ```
5. When cutting a release, move the Unreleased entries into a new version section with the date,
   then rerun the script to repopulate Unreleased.

## Run the app
1. From the repo root, start the CLI server:
   ```bash
   ./bin/task-board.js --port 4173
   ```
   Wait for the ready message: `Ready at http://127.0.0.1:4173`.
2. Open the app in a browser:
   - `http://127.0.0.1:4173`
3. Create a task to confirm the UI is working.

To stop the server, press `Ctrl+C` in the terminal.

## Android APK (mobile review app)
1. Ensure Java 17 and the Android SDK are installed and available:
   - Set `JAVA_HOME` and `ANDROID_SDK_ROOT` as needed.
2. Build the debug APK:
   ```bash
   cd mobile
   ./gradlew assembleDebug
   ```
3. The APK is generated at:
   - `mobile/app/build/outputs/apk/debug/app-debug.apk`

To use the app against the local web server, load `http://10.0.2.2:8000/mobile/` in the URL field
(Android emulator) or replace `10.0.2.2` with your machine's LAN IP for a physical device.

## Tests
### Automated
1. Install dependencies from the repo root:
   ```bash
   npm install
   ```
2. Run the acceptance test suite:
   ```bash
   npm run test:acceptance
   ```

### Mobile (Appium)
1. Build the APK (see Android steps above).
2. Install the Appium client dependency:
   ```bash
   npm install -D webdriverio
   ```
3. Start an emulator/device and run Appium:
   ```bash
   appium
   ```
4. Run the basic Appium flow:
   ```bash
   node tests/mobile/appium-basic-flow.js
   ```
3. Run the CLI smoke test:
   ```bash
   npm run test:cli
   ```

### BDD (Behave)
1. From the repo root, set up a Python venv (reuse if already created):
   ```bash
   python3 -m venv .venv
   source .venv/bin/activate
   ```
2. Install Behave dependencies:
   ```bash
   pip install -r requirements.txt
   ```
3. Run the BDD suite:
   ```bash
   behave tests/bdd
   ```

### Manual acceptance run (Slice 0001)
Use the Slice 0001 acceptance criteria from `docs/plan/slice-plan.md` and capture results in
`docs/testing/acceptance/slice-0001.md`.

Suggested runbook:
1. Open the app and confirm the "To Do" column is visible.
2. Click "Create Task", enter a title + description, and select "Create".
3. Verify the new task appears in the "To Do" column.
4. Refresh the page and confirm the task still appears.
5. Attempt to create a task with an empty title and confirm the validation error appears.
6. Click "Cancel" and confirm the dialog closes without creating a task.

### Linters
- Folder structure: `./scripts/check-folder-structure.sh`

## Troubleshooting
- Port already in use: rerun the CLI on a different port, e.g. `./bin/task-board.js --port 8001`.
- Tasks not persisting: confirm your browser allows local storage for `http://127.0.0.1:4173`.
- Reset task data: clear the `slice0001.tasks` entry in local storage for `http://127.0.0.1:4173`.
