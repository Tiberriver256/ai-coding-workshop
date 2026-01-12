#!/usr/bin/env bash
set -euo pipefail

max_lines=500
failures=0

while IFS= read -r -d '' file; do
  if [ -s "$file" ] && ! grep -Iq . "$file"; then
    continue
  fi

  line_count=$(wc -l < "$file")
  if [ "$line_count" -gt "$max_lines" ]; then
    echo "File exceeds ${max_lines} lines (${line_count}): $file"
    failures=1
  fi
done < <(git ls-files -z)

if [ "$failures" -ne 0 ]; then
  echo "One or more files exceed ${max_lines} lines."
  exit 1
fi

echo "All tracked text files are within ${max_lines} lines."
