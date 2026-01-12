#!/usr/bin/env node
const fs = require('fs');
const path = require('path');
const { startServer, defaultHost, defaultPort, defaultRootDir } = require('../scripts/app-server');

function readPackageJson() {
  const packagePath = path.join(__dirname, '..', 'package.json');
  return JSON.parse(fs.readFileSync(packagePath, 'utf-8'));
}

function printHelp() {
  console.log(`Usage: task-board [options]\n\nStarts the Slice 0001 static task board server.\n\nOptions:\n  -p, --port <number>   Port to bind (default: ${defaultPort} or $PORT)\n  -H, --host <address>  Host to bind (default: ${defaultHost} or $HOST)\n  -h, --help            Show this help message\n  -v, --version         Show version\n`);
}

function parseArgs(args) {
  const options = {
    port: undefined,
    host: undefined,
  };

  for (let i = 0; i < args.length; i += 1) {
    const arg = args[i];

    if (arg === '--help' || arg === '-h') {
      return { action: 'help', options };
    }

    if (arg === '--version' || arg === '-v') {
      return { action: 'version', options };
    }

    if (arg === '--port' || arg === '-p') {
      if (i + 1 >= args.length) {
        return { action: 'error', message: 'Missing value for --port.' };
      }
      options.port = args[i + 1];
      i += 1;
      continue;
    }

    if (arg.startsWith('--port=')) {
      options.port = arg.split('=')[1];
      continue;
    }

    if (arg === '--host' || arg === '-H') {
      if (i + 1 >= args.length) {
        return { action: 'error', message: 'Missing value for --host.' };
      }
      options.host = args[i + 1];
      i += 1;
      continue;
    }

    if (arg.startsWith('--host=')) {
      options.host = arg.split('=')[1];
      continue;
    }

    return { action: 'error', message: `Unknown argument: ${arg}` };
  }

  return { action: 'run', options };
}

function parsePort(value, fallback) {
  if (value === undefined || value === '') {
    return fallback;
  }
  const parsed = Number(value);
  if (!Number.isFinite(parsed) || parsed < 0 || !Number.isInteger(parsed)) {
    return null;
  }
  return parsed;
}

function main() {
  const result = parseArgs(process.argv.slice(2));

  if (result.action === 'help') {
    printHelp();
    return;
  }

  if (result.action === 'version') {
    const packageJson = readPackageJson();
    console.log(packageJson.version || '0.0.0');
    return;
  }

  if (result.action === 'error') {
    console.error(result.message);
    printHelp();
    process.exitCode = 1;
    return;
  }

  const envPort = process.env.PORT;
  const envHost = process.env.HOST;
  const port = parsePort(result.options.port ?? envPort, defaultPort);
  const host = result.options.host ?? envHost ?? defaultHost;

  if (port === null) {
    console.error('Invalid port value.');
    process.exitCode = 1;
    return;
  }

  startServer({
    port,
    host,
    rootDir: defaultRootDir,
    onReady: ({ url }) => {
      console.log(`Ready at ${url}`);
    },
    onError: (error) => {
      console.error(error);
      process.exitCode = 1;
    },
  });
}

main();
