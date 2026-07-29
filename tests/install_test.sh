#!/usr/bin/env bash
# Verifies the repo is a valid, installable Claude Code marketplace.
set -uo pipefail

REPO="$(cd "$(dirname "$0")/.." && pwd)"
FAIL=0

check() {
  if eval "$2" >/dev/null 2>&1; then
    echo "PASS  $1"
  else
    echo "FAIL  $1"
    FAIL=1
  fi
}

check "marketplace.json is valid JSON"      "jq -e . '$REPO/.claude-plugin/marketplace.json'"
check "marketplace name is cold-read"       "jq -e '.name == \"cold-read\"' '$REPO/.claude-plugin/marketplace.json'"
check "marketplace lists one plugin"        "jq -e '.plugins | length == 1' '$REPO/.claude-plugin/marketplace.json'"
check "plugin source points at the plugin"  "jq -e '.plugins[0].source == \"./plugins/cold-read\"' '$REPO/.claude-plugin/marketplace.json'"
check "plugin directory exists"             "test -d '$REPO/plugins/cold-read'"
check "plugin.json is valid JSON"           "jq -e . '$REPO/plugins/cold-read/.claude-plugin/plugin.json'"
check "plugin name is cold-read"            "jq -e '.name == \"cold-read\"' '$REPO/plugins/cold-read/.claude-plugin/plugin.json'"
check "SKILL.md exists"                     "test -f '$REPO/plugins/cold-read/skills/cold-read/SKILL.md'"
check "SKILL.md frontmatter name matches"   "head -3 '$REPO/plugins/cold-read/skills/cold-read/SKILL.md' | grep -q '^name: cold-read$'"
check "SKILL.md has a description"          "grep -q '^description: ' '$REPO/plugins/cold-read/skills/cold-read/SKILL.md'"

exit $FAIL
