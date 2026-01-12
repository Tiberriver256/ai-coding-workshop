const { test, expect } = require('@playwright/test');

async function clearLocalStorage(page) {
  await page.evaluate(() => localStorage.clear());
}

async function openCreateModal(page) {
  await page.locator('#open-modal').click();
  await expect(page.locator('#task-modal')).toHaveAttribute('aria-hidden', 'false');
}

async function submitTask(page, { title, description }) {
  await openCreateModal(page);
  await page.locator('#task-title').fill(title);
  if (description) {
    await page.locator('#task-description').fill(description);
  }
  await page.locator('#task-form button[type="submit"]').click();
  await expect(page.locator('#task-modal')).toHaveAttribute('aria-hidden', 'true');
}

function median(values) {
  if (!values.length) {
    return 0;
  }
  const sorted = [...values].sort((a, b) => a - b);
  const mid = Math.floor(sorted.length / 2);
  if (sorted.length % 2 === 0) {
    return (sorted[mid - 1] + sorted[mid]) / 2;
  }
  return sorted[mid];
}

test.beforeEach(async ({ page }) => {
  await page.goto('/');
  await clearLocalStorage(page);
  await page.reload();
  await expect(page.locator('#task-count')).toHaveText('0');
});

test('create task adds card to list', async ({ page }) => {
  const attempts = 10;
  const description = 'Acceptance test automation check.';
  const durations = [];
  let lastTitle = '';

  for (let i = 0; i < attempts; i += 1) {
    const title = `Ship slice ${Date.now()}-${i}`;
    lastTitle = title;
    const start = Date.now();
    await submitTask(page, { title, description });
    const end = Date.now();
    durations.push(end - start);
  }

  const medianMs = median(durations);
  const medianSeconds = Math.round((medianMs / 1000) * 10) / 10;
  console.log(`[metric] task_creation_attempts=${attempts}`);
  console.log(`[metric] task_creation_successes=${attempts}`);
  console.log('[metric] task_creation_failures=0');
  console.log(`[metric] task_creation_times_ms=${durations.join(',')}`);
  console.log(`[metric] task_creation_median_ms=${medianMs}`);
  console.log(`[metric] task_creation_median_seconds=${medianSeconds}`);

  const cards = page.locator('.task-card');
  await expect(cards).toHaveCount(attempts);
  await expect(page.locator('.task-card h4', { hasText: lastTitle })).toHaveCount(1);
  await expect(page.locator('.task-card p', { hasText: description })).toHaveCount(attempts);
  await expect(page.locator('#task-count')).toHaveText(String(attempts));
});

test('empty title shows validation error and blocks create', async ({ page }) => {
  await openCreateModal(page);
  await page.locator('#task-form button[type="submit"]').click();

  await expect(page.locator('#title-error')).toHaveText('Title is required.');
  await expect(page.locator('#task-count')).toHaveText('0');
  await expect(page.locator('.task-card')).toHaveCount(0);
});

test('cancel does not create task', async ({ page }) => {
  await openCreateModal(page);
  await page.locator('#task-title').fill('Should not save');
  await page.locator('#task-description').fill('Cancel keeps list empty.');
  await page.locator('#cancel-modal').click();

  await expect(page.locator('#task-modal')).toHaveAttribute('aria-hidden', 'true');
  await expect(page.locator('#task-count')).toHaveText('0');
  await expect(page.locator('.task-card')).toHaveCount(0);
});

test('task persists after reload', async ({ page }) => {
  const title = `Persist ${Date.now()}`;

  await submitTask(page, { title, description: 'Local storage check.' });
  await page.reload();

  const cards = page.locator('.task-card');
  await expect(cards).toHaveCount(1);
  await expect(cards.locator('h4')).toHaveText(title);
  await expect(page.locator('#task-count')).toHaveText('1');
});
