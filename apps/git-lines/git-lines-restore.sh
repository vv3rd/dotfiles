#!/usr/bin/env bash
set -euo pipefail

file="$1"
start="$2"
end="$3"

tmp="$(mktemp)"

git show "HEAD:$file" > "$tmp.head"

awk -v s="$start" -v e="$end" '
  NR < s || NR > e {
    print
    next
  }

  NR >= s && NR <= e {
    while ((getline line < ARGV[2]) > 0) {
      if (++n >= s && n <= e)
        print line
      if (n > e)
        break
    }
  }
' "$file" "$tmp.head" > "$tmp"

mv "$tmp" "$file"

rm "$tmp.head"
