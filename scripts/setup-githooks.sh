#!/bin/sh
set -e

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
HOOKS_DIR="$ROOT_DIR/.githooks"

if [ ! -d "$HOOKS_DIR" ]; then
  echo "Missing $HOOKS_DIR; run from repo root." >&2
  exit 1
fi

chmod +x "$HOOKS_DIR/commit-msg"

git -C "$ROOT_DIR" config core.hooksPath .githooks

echo "Git hooks configured to use .githooks"
