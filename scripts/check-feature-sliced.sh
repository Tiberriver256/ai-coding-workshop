#!/usr/bin/env bash
set -euo pipefail

root_dir=$(git rev-parse --show-toplevel 2>/dev/null || pwd)

layers=(app pages widgets features entities shared processes)
segment_layers=(app shared)
slice_layers=(pages widgets features entities processes)
public_api_files=(index.ts index.tsx index.js index.jsx index.mjs index.cjs)
banned_segments=(components hooks types)

kebab_case_regex='^[a-z][a-z0-9-]*$'

usage() {
  cat <<'USAGE'
Usage: scripts/check-feature-sliced.sh [--root <path>] [--roots <path1,path2>]

Options:
  --root  Add a single FSD root (repo-relative or absolute).
  --roots Comma-separated list of FSD roots.

Environment:
  FSD_ROOTS  Comma-separated list of FSD roots (repo-relative or absolute).
USAGE
}

failures=0

report_error() {
  echo "[FSD] $1"
  failures=1
}

is_kebab_case() {
  [[ "$1" =~ $kebab_case_regex ]]
}

is_banned_segment() {
  local name="$1"
  for banned in "${banned_segments[@]}"; do
    if [ "$name" = "$banned" ]; then
      return 0
    fi
  done
  return 1
}

has_public_api() {
  local dir="$1"
  for file in "${public_api_files[@]}"; do
    if [ -f "$dir/$file" ]; then
      return 0
    fi
  done
  return 1
}

resolve_root() {
  local path="$1"
  if [[ "$path" = /* ]]; then
    echo "$path"
  else
    echo "$root_dir/$path"
  fi
}

is_layer_name() {
  local name="$1"
  for layer in "${layers[@]}"; do
    if [ "$name" = "$layer" ]; then
      return 0
    fi
  done
  return 1
}

is_segment_layer() {
  local name="$1"
  for layer in "${segment_layers[@]}"; do
    if [ "$name" = "$layer" ]; then
      return 0
    fi
  done
  return 1
}

is_slice_layer() {
  local name="$1"
  for layer in "${slice_layers[@]}"; do
    if [ "$name" = "$layer" ]; then
      return 0
    fi
  done
  return 1
}

collect_roots() {
  local -a roots=()
  local arg

  while [ "$#" -gt 0 ]; do
    case "$1" in
      --root)
        if [ "$#" -lt 2 ]; then
          echo "Missing value for --root" >&2
          usage
          exit 1
        fi
        roots+=("$2")
        shift 2
        ;;
      --roots)
        if [ "$#" -lt 2 ]; then
          echo "Missing value for --roots" >&2
          usage
          exit 1
        fi
        IFS=',' read -r -a extra <<< "$2"
        roots+=("${extra[@]}")
        shift 2
        ;;
      --help|-h)
        usage
        exit 0
        ;;
      *)
        echo "Unknown argument: $1" >&2
        usage
        exit 1
        ;;
    esac
  done

  if [ "${#roots[@]}" -eq 0 ] && [ -n "${FSD_ROOTS:-}" ]; then
    IFS=',' read -r -a roots <<< "$FSD_ROOTS"
  fi

  if [ "${#roots[@]}" -eq 0 ]; then
    mapfile -t roots < <(detect_roots)
  fi

  printf '%s\n' "${roots[@]}"
}

detect_roots() {
  local -a candidates=()
  while IFS= read -r -d '' dir; do
    local count=0
    for layer in "${layers[@]}"; do
      if [ -d "$dir/$layer" ]; then
        count=$((count + 1))
      fi
    done
    if [ "$count" -ge 2 ]; then
      candidates+=("$dir")
    fi
  done < <(
    find "$root_dir" -type d \( \
      -path "$root_dir/.git" -o \
      -path "$root_dir/.venv" -o \
      -path "$root_dir/.tldr" -o \
      -path "$root_dir/node_modules" -o \
      -path "$root_dir/research-output" -o \
      -path "$root_dir/test-results" -o \
      -path "$root_dir/mobile/app/build" \
    \) -prune -o -print0
  )
  printf '%s\n' "${candidates[@]}"
}

check_layer_case() {
  local root="$1"
  while IFS= read -r -d '' dir; do
    local name
    name=$(basename "$dir")
    local lower
    lower=$(echo "$name" | tr '[:upper:]' '[:lower:]')
    if is_layer_name "$lower" && [ "$name" != "$lower" ]; then
      report_error "Layer folder must be lowercase: $dir (expected $lower)"
    fi
  done < <(find "$root" -mindepth 1 -maxdepth 1 -type d -print0)
}

check_segments_layer() {
  local root="$1"
  local layer="$2"
  local layer_path="$root/$layer"

  while IFS= read -r -d '' segment_dir; do
    local segment
    segment=$(basename "$segment_dir")

    if [ "$segment" = "@x" ]; then
      report_error "@x is only allowed inside entities slices: $segment_dir"
      continue
    fi

    if ! is_kebab_case "$segment"; then
      report_error "Segment name must be kebab-case: $segment_dir"
    fi

    if is_banned_segment "$segment"; then
      report_error "Segment name '$segment' is not allowed (use purpose-driven names)."
    fi

    if ! has_public_api "$segment_dir"; then
      report_error "Segment missing public API (index.*): $segment_dir"
    fi
  done < <(find "$layer_path" -mindepth 1 -maxdepth 1 -type d -print0)
}

is_slice_group() {
  local dir="$1"
  if find "$dir" -mindepth 1 -maxdepth 1 -type f ! -name '.DS_Store' -print -quit | grep -q .; then
    return 1
  fi
  if has_public_api "$dir"; then
    return 1
  fi
  if find "$dir" -mindepth 1 -maxdepth 1 -type d -print -quit | grep -q .; then
    return 0
  fi
  return 1
}

check_slice_segments() {
  local layer="$1"
  local slice_dir="$2"

  while IFS= read -r -d '' segment_dir; do
    local segment
    segment=$(basename "$segment_dir")

    if [ "$segment" = "@x" ]; then
      if [ "$layer" != "entities" ]; then
        report_error "@x is only allowed inside entities slices: $segment_dir"
      fi
      continue
    fi

    if ! is_kebab_case "$segment"; then
      report_error "Segment name must be kebab-case: $segment_dir"
    fi

    if is_banned_segment "$segment"; then
      report_error "Segment name '$segment' is not allowed (use purpose-driven names)."
    fi
  done < <(find "$slice_dir" -mindepth 1 -maxdepth 1 -type d -print0)
}

check_slice() {
  local layer="$1"
  local slice_dir="$2"
  local slice
  slice=$(basename "$slice_dir")

  if ! is_kebab_case "$slice"; then
    report_error "Slice name must be kebab-case: $slice_dir"
  fi

  if ! has_public_api "$slice_dir"; then
    report_error "Slice missing public API (index.*): $slice_dir"
  fi

  check_slice_segments "$layer" "$slice_dir"
}

check_slice_layer() {
  local root="$1"
  local layer="$2"
  local layer_path="$root/$layer"

  while IFS= read -r -d '' slice_dir; do
    local slice
    slice=$(basename "$slice_dir")

    if [ "$slice" = "@x" ]; then
      report_error "@x is only allowed inside entities slices: $slice_dir"
      continue
    fi

    if ! is_kebab_case "$slice"; then
      report_error "Slice name must be kebab-case: $slice_dir"
    fi

    if is_slice_group "$slice_dir"; then
      if find "$slice_dir" -mindepth 1 -maxdepth 1 -type f ! -name '.DS_Store' -print -quit | grep -q .; then
        report_error "Slice group must not contain files: $slice_dir"
      fi
      while IFS= read -r -d '' nested_slice; do
        check_slice "$layer" "$nested_slice"
      done < <(find "$slice_dir" -mindepth 1 -maxdepth 1 -type d -print0)
    else
      check_slice "$layer" "$slice_dir"
    fi
  done < <(find "$layer_path" -mindepth 1 -maxdepth 1 -type d -print0)
}

check_root() {
  local root="$1"

  if [ ! -d "$root" ]; then
    report_error "FSD root does not exist: $root"
    return
  fi

  check_layer_case "$root"

  for layer in "${layers[@]}"; do
    local layer_path="$root/$layer"
    if [ ! -d "$layer_path" ]; then
      continue
    fi

    if is_segment_layer "$layer"; then
      check_segments_layer "$root" "$layer"
    elif is_slice_layer "$layer"; then
      check_slice_layer "$root" "$layer"
    fi
  done
}

main() {
  mapfile -t roots < <(collect_roots "$@")

  if [ "${#roots[@]}" -eq 0 ]; then
    echo "[FSD] No Feature-Sliced roots detected. Set FSD_ROOTS or use --root." >&2
    exit 0
  fi

  for root in "${roots[@]}"; do
    local resolved
    resolved=$(resolve_root "$root")
    check_root "$resolved"
  done

  if [ "$failures" -ne 0 ]; then
    echo "[FSD] Feature-Sliced check failed." >&2
    exit 1
  fi

  echo "[FSD] Feature-Sliced check passed."
}

main "$@"
