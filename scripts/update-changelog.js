#!/usr/bin/env node

const fs = require('node:fs');
const path = require('node:path');
const { execSync } = require('node:child_process');

const ROOT = path.resolve(__dirname, '..');
const CHANGELOG_PATH = path.join(ROOT, 'CHANGELOG.md');
const BEGIN_MARKER = '<!-- auto-changelog:begin -->';
const END_MARKER = '<!-- auto-changelog:end -->';
const SECTIONS = ['Added', 'Changed', 'Deprecated', 'Removed', 'Fixed', 'Security'];

const typeToSection = {
  feat: 'Added',
  fix: 'Fixed',
  perf: 'Changed',
  refactor: 'Changed',
  docs: 'Changed',
  style: 'Changed',
  test: 'Changed',
  chore: 'Changed',
  build: 'Changed',
  ci: 'Changed',
  revert: 'Fixed',
  security: 'Security',
  deprecate: 'Deprecated',
  remove: 'Removed',
};

function run(cmd) {
  return execSync(cmd, { cwd: ROOT, stdio: ['ignore', 'pipe', 'ignore'] })
    .toString()
    .trim();
}

function getRange(argv) {
  const args = argv.slice(2);
  const fromIndex = args.indexOf('--from');
  const toIndex = args.indexOf('--to');

  if (fromIndex !== -1 && args[fromIndex + 1]) {
    const from = args[fromIndex + 1];
    const to = toIndex !== -1 && args[toIndex + 1] ? args[toIndex + 1] : 'HEAD';
    return `${from}..${to}`;
  }

  try {
    const tag = run('git describe --tags --abbrev=0');
    if (tag) {
      return `${tag}..HEAD`;
    }
  } catch (error) {
    // No tags yet; fall back to full history.
  }

  return '';
}

function getCommits(range) {
  const rangeArg = range ? `${range} ` : '';
  const output = run(`git log ${rangeArg}--pretty=format:%s`);
  if (!output) {
    return [];
  }
  return output.split('\n').map((line) => line.trim()).filter(Boolean);
}

function categorizeCommits(commits) {
  const buckets = Object.fromEntries(SECTIONS.map((section) => [section, []]));
  const warnings = [];

  commits.forEach((subject) => {
    if (/^merge\s/i.test(subject)) {
      return;
    }

    const match = subject.match(/^(?<type>[a-z]+)(?:\((?<scope>[^)]+)\))?(?<breaking>!)?: (?<desc>.+)$/);
    if (!match || !match.groups) {
      buckets.Changed.push(`(non-conventional) ${subject}`);
      warnings.push(subject);
      return;
    }

    const { type, scope, breaking, desc } = match.groups;
    const section = typeToSection[type] || 'Changed';
    let entry = desc.trim();

    if (scope) {
      entry = `${scope}: ${entry}`;
    }

    if (breaking) {
      entry = `${entry} [breaking]`;
    }

    if (!typeToSection[type]) {
      entry = `${entry} (${type})`;
      warnings.push(subject);
    }

    buckets[section].push(entry);
  });

  return { buckets, warnings };
}

function renderSections(buckets) {
  const lines = [];

  SECTIONS.forEach((section) => {
    lines.push(`### ${section}`);
    const entries = buckets[section];

    if (!entries || entries.length === 0) {
      lines.push('- (no entries)');
    } else {
      entries.forEach((entry) => {
        lines.push(`- ${entry}`);
      });
    }

    lines.push('');
  });

  return lines.join('\n').trim();
}

function ensureMarkers(changelog) {
  if (changelog.includes(BEGIN_MARKER) && changelog.includes(END_MARKER)) {
    return changelog;
  }

  const unreleasedHeader = '## Unreleased';
  const markerBlock = `${BEGIN_MARKER}\n${END_MARKER}`;
  const parts = changelog.split(unreleasedHeader);

  if (parts.length < 2) {
    throw new Error('CHANGELOG.md is missing "## Unreleased"');
  }

  return `${parts[0]}${unreleasedHeader}\n\n${markerBlock}\n${parts.slice(1).join(unreleasedHeader)}`;
}

function updateChangelog() {
  if (!fs.existsSync(CHANGELOG_PATH)) {
    throw new Error('CHANGELOG.md not found at repo root');
  }

  const original = fs.readFileSync(CHANGELOG_PATH, 'utf8');
  const withMarkers = ensureMarkers(original);
  const range = getRange(process.argv);
  const commits = getCommits(range);
  const { buckets, warnings } = categorizeCommits(commits);
  const rendered = renderSections(buckets);
  const markerRegex = new RegExp(`${BEGIN_MARKER}[\s\S]*?${END_MARKER}`, 'm');
  const updated = withMarkers.replace(markerRegex, `${BEGIN_MARKER}\n${rendered}\n${END_MARKER}`);

  fs.writeFileSync(CHANGELOG_PATH, updated, 'utf8');

  if (warnings.length > 0) {
    console.warn('Non-conventional commit subjects were added to "Changed".');
    warnings.forEach((subject) => console.warn(`- ${subject}`));
  }

  const rangeLabel = range || 'full history';
  console.log(`Updated CHANGELOG.md from ${rangeLabel}.`);
}

try {
  updateChangelog();
} catch (error) {
  console.error(error.message || String(error));
  process.exit(1);
}
