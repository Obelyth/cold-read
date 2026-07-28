#!/usr/bin/env bash
# Fails if any shipped file contains an en dash (U+2013) or em dash (U+2014).
# The skill forbids these in its output; shipping them would teach the opposite.
#
# One exception: a fenced block preceded by a line containing "dash-demo" is a
# deliberate demonstration of the characters being replaced. Those blocks are skipped.
# Everything else, including all example OUTPUT blocks, must be clean.
set -uo pipefail

REPO="$(cd "$(dirname "$0")/.." && pwd)"

FILES=$(find "$REPO/plugins" "$REPO/.claude-plugin" -type f 2>/dev/null; \
        [ -f "$REPO/README.md" ] && echo "$REPO/README.md")

HITS=$(
  for f in $FILES; do
    awk -v F="$f" '
      /dash-demo/ { demo=1; next }
      /^```/      { if (demo && !infence) { infence=1; next }
                    if (infence)          { infence=0; demo=0; next } }
      infence     { next }
      /[\xe2\x80\x93\xe2\x80\x94]/ { printf "%s:%d: %s\n", F, NR, $0 }
    ' "$f"
  done
)

if [ -z "$HITS" ]; then
  echo "PASS  no en dashes or em dashes in shipped files"
  exit 0
fi

echo "$HITS"
echo "FAIL  shipped files contain en or em dashes (listed above)"
exit 1
