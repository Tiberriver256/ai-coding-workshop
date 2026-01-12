const { defineConfig } = require('@playwright/test');

const port = Number(process.env.PORT || 4173);

module.exports = defineConfig({
  testDir: 'tests/acceptance',
  timeout: 30000,
  expect: {
    timeout: 5000,
  },
  use: {
    baseURL: `http://127.0.0.1:${port}`,
    headless: true,
    viewport: { width: 1280, height: 720 },
  },
  webServer: {
    command: 'node scripts/serve-app.js',
    port,
    reuseExistingServer: !process.env.CI,
    cwd: __dirname,
  },
});
