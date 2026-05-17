#!/usr/bin/env bash
set -euo pipefail

file="$1"
start="$2"
end="$3"

head_content="$(git show "HEAD:$file" 2>/dev/null || true)"

blob_content="$(
  awk -v s="$start" -v e="$end" '
    NR < s || NR > e { print $0 }
  ' <<< "$head_content"

  awk -v s="$start" -v e="$end" '
    NR >= s && NR <= e { print $0 }
  ' "$file"
)"

mode="$(
  git ls-files --stage -- "$file" | awk "{print \$1}"
)"

blob="$(
  printf '%s\n' "$blob_content" | git hash-object -w --stdin --path "$file"
)"

git update-index --cacheinfo "$mode,$blob,$file"
