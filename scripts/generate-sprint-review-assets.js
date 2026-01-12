const fs = require('fs');
const path = require('path');
const http = require('http');
const { spawn } = require('child_process');
const { pathToFileURL } = require('url');
const { chromium } = require('playwright');

const rootDir = path.resolve(__dirname, '..');
const reviewDir = path.join(rootDir, 'docs', 'reviews', 'sprint-review-2026-01-11');
const serverUrl = 'http://127.0.0.1:4173';

function waitForServer(url, timeoutMs = 15000) {
  return new Promise((resolve, reject) => {
    const start = Date.now();

    const attempt = () => {
      const req = http.get(url, (res) => {
        res.resume();
        if (res.statusCode && res.statusCode >= 200 && res.statusCode < 500) {
          resolve();
          return;
        }
        if (Date.now() - start > timeoutMs) {
          reject(new Error('Server did not respond in time.'));
          return;
        }
        setTimeout(attempt, 300);
      });

      req.on('error', () => {
        if (Date.now() - start > timeoutMs) {
          reject(new Error('Server did not respond in time.'));
          return;
        }
        setTimeout(attempt, 300);
      });
    };

    attempt();
  });
}

function fileUrl(fileName) {
  return pathToFileURL(path.join(reviewDir, fileName)).toString();
}

async function run() {
  fs.mkdirSync(reviewDir, { recursive: true });

  const serverProcess = spawn('node', ['scripts/serve-app.js'], {
    cwd: rootDir,
    stdio: 'inherit',
  });

  let browser;
  let context;
  let page;
  let video;

  try {
    await waitForServer(serverUrl);

    browser = await chromium.launch({ headless: true });
    context = await browser.newContext({
      viewport: { width: 1280, height: 720 },
      recordVideo: {
        dir: reviewDir,
        size: { width: 1280, height: 720 },
      },
    });

    page = await context.newPage();
    video = page.video();

    await page.goto(fileUrl('terminal-intro.html'));
    await page.waitForTimeout(1200);
    await page.screenshot({ path: path.join(reviewDir, '01-cli-intro.png'), fullPage: true });

    await page.goto(serverUrl);
    await page.evaluate(() => localStorage.clear());
    await page.reload();
    await page.waitForSelector('#task-count');
    await page.waitForTimeout(800);
    await page.screenshot({ path: path.join(reviewDir, '02-web-empty.png'), fullPage: true });

    await page.click('#open-modal');
    await page.waitForSelector('#task-modal[aria-hidden="false"]');
    await page.waitForTimeout(600);
    await page.screenshot({ path: path.join(reviewDir, '03-web-modal.png'), fullPage: true });

    await page.fill('#task-title', 'Capture sprint review demo assets');
    await page.fill('#task-description', 'Record walkthrough, QR pairing, and completion proof.');
    await page.click('#task-form button[type="submit"]');
    await page.waitForFunction(() => {
      const count = document.querySelector('#task-count');
      return count && count.textContent === '1';
    });
    await page.waitForTimeout(800);
    await page.screenshot({ path: path.join(reviewDir, '04-web-task-created.png'), fullPage: true });

    await page.click('#open-connect');
    await page.waitForSelector('#connect-modal[aria-hidden="false"]');
    await page.waitForTimeout(800);
    await page.screenshot({ path: path.join(reviewDir, '05-qr-connect.png'), fullPage: true });

    await page.goto(`${serverUrl}/mobile/index.html`);
    await page.waitForSelector('#todo-list');
    await page.waitForTimeout(800);
    await page.screenshot({ path: path.join(reviewDir, '06-mobile-review.png'), fullPage: true });

    await page.goto(serverUrl);
    await page.waitForSelector('.task-action');
    await page.click('.task-action');
    await page.waitForFunction(() => {
      const doneCount = document.querySelector('#done-count');
      return doneCount && doneCount.textContent === '1';
    });
    await page.goto(`${serverUrl}/mobile/index.html`);
    await page.waitForFunction(() => {
      const doneCount = document.querySelector('#done-count');
      return doneCount && doneCount.textContent === '1';
    });
    await page.waitForTimeout(800);
    await page.screenshot({ path: path.join(reviewDir, '07-mobile-complete.png'), fullPage: true });

    await page.waitForTimeout(1000);
    await page.close();

    const videoPath = await video.path();
    const targetVideo = path.join(reviewDir, 'sprint-review-walkthrough.webm');
    if (fs.existsSync(targetVideo)) {
      fs.unlinkSync(targetVideo);
    }
    fs.renameSync(videoPath, targetVideo);
  } finally {
    if (context) {
      await context.close().catch(() => undefined);
    }
    if (browser) {
      await browser.close().catch(() => undefined);
    }
    if (serverProcess && !serverProcess.killed) {
      serverProcess.kill('SIGTERM');
    }
  }
}

run().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
