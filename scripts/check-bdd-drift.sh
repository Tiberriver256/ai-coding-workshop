#!/usr/bin/env bash
set -euo pipefail

root=$(git rev-parse --show-toplevel)
docs_dir="$root/docs/features"
tests_dir="$root/tests/bdd"

if [ ! -d "$docs_dir" ]; then
  echo "Missing docs/features directory: $docs_dir"
  exit 1
fi

if [ ! -d "$tests_dir" ]; then
  echo "Missing tests/bdd directory: $tests_dir"
  exit 1
fi

fail=0

while IFS= read -r -d '' file; do
  rel="${file#$docs_dir/}"
  test_file="$tests_dir/$rel"
  if [ ! -f "$test_file" ]; then
    echo "Missing in tests/bdd: $rel"
    fail=1
    continue
  fi
  if ! diff -u "$file" "$test_file" >/dev/null; then
    echo "Drift detected: $rel"
    fail=1
  fi
done < <(find "$docs_dir" -type f -name '*.feature' -print0)

while IFS= read -r -d '' file; do
  rel="${file#$tests_dir/}"
  doc_file="$docs_dir/$rel"
  if [ ! -f "$doc_file" ]; then
    echo "Extra in tests/bdd (no docs/features match): $rel"
    fail=1
  fi
done < <(find "$tests_dir" -type f -name '*.feature' -print0)

if [ "$fail" -ne 0 ]; then
  echo "BDD feature drift detected. Sync docs/features and tests/bdd."
  exit 1
fi

echo "BDD feature files are in sync."
