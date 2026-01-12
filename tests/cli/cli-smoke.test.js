const assert = require('node:assert/strict');
const http = require('node:http');
const path = require('node:path');
const { spawn } = require('node:child_process');
const { test } = require('node:test');

const CLI_PATH = path.resolve(__dirname, '..', '..', 'bin', 'task-board.js');

function waitForReady(process, timeoutMs = 10000) {
  return new Promise((resolve, reject) => {
    let buffer = '';
    let resolved = false;

    const timeout = setTimeout(() => {
      if (resolved) {
        return;
      }
      resolved = true;
      cleanup();
      reject(new Error(`Timed out waiting for ready output. Output so far:\n${buffer}`));
    }, timeoutMs);

    function cleanup() {
      clearTimeout(timeout);
      process.stdout?.off('data', onData);
      process.stderr?.off('data', onData);
      process.off('exit', onExit);
      process.off('error', onError);
    }

    function onData(chunk) {
      buffer += chunk.toString();
      const match = buffer.match(/Ready at (http:\/\/[^\s]+)/);
      if (match && !resolved) {
        resolved = true;
        cleanup();
        resolve(match[1]);
      }
    }

    function onExit(code) {
      if (resolved) {
        return;
      }
      resolved = true;
      cleanup();
      reject(new Error(`CLI exited with code ${code}. Output:\n${buffer}`));
    }

    function onError(error) {
      if (resolved) {
        return;
      }
      resolved = true;
      cleanup();
      reject(error);
    }

    process.stdout?.on('data', onData);
    process.stderr?.on('data', onData);
    process.on('exit', onExit);
    process.on('error', onError);
  });
}

function request(url) {
  return new Promise((resolve, reject) => {
    const req = http.get(url, (res) => {
      res.resume();
      resolve(res.statusCode || 0);
    });

    req.on('error', reject);
  });
}

async function terminate(process) {
  if (process.killed || process.exitCode !== null) {
    return;
  }

  try {
    process.kill('SIGTERM');
  } catch (error) {
    return;
  }

  await new Promise((resolve) => {
    const timeout = setTimeout(() => {
      if (!process.killed) {
        process.kill('SIGKILL');
      }
      resolve();
    }, 2000);

    process.once('exit', () => {
      clearTimeout(timeout);
      resolve();
    });
  });
}

test('Given the CLI starts, when it logs a ready URL, then the app responds', async () => {
  const cliProcess = spawn(process.execPath, [CLI_PATH, '--port', '0'], {
    stdio: ['ignore', 'pipe', 'pipe'],
    env: { ...process.env, HOST: '127.0.0.1' },
  });

  try {
    const readyUrl = await waitForReady(cliProcess);
    const status = await request(readyUrl);
    assert.ok(status >= 200 && status < 500, `Unexpected status: ${status}`);
  } finally {
    await terminate(cliProcess);
  }
});
