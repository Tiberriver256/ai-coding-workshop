#!/usr/bin/env bash
set -euo pipefail

root_dir=$(git rev-parse --show-toplevel 2>/dev/null || pwd)
structure_doc="${root_dir}/docs/folder-structure.md"

if [ ! -f "$structure_doc" ]; then
  echo "Missing required file: $structure_doc"
  exit 1
fi

required_paths=()
in_block=0

while IFS= read -r line; do
  if [[ "$line" == '```'* ]]; then
    if [ "$in_block" -eq 0 ]; then
      in_block=1
      continue
    fi
    break
  fi

  if [ "$in_block" -eq 1 ]; then
    trimmed=$(echo "$line" | sed -e 's/#.*$//' -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
    if [ -n "$trimmed" ]; then
      required_paths+=("$trimmed")
    fi
  fi
done < "$structure_doc"

if [ "${#required_paths[@]}" -eq 0 ]; then
  echo "No required paths found in $structure_doc."
  echo "Ensure the first fenced code block lists required paths."
  exit 1
fi

failures=0

for rel_path in "${required_paths[@]}"; do
  if [ ! -e "$root_dir/$rel_path" ]; then
    echo "Missing required path: $rel_path"
    failures=1
  fi
done

if [ "$failures" -ne 0 ]; then
  echo "Folder structure check failed."
  exit 1
fi

echo "Folder structure check passed."
