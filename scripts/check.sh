#!/usr/bin/env bash
# Every check CI runs. Run it locally before a PR.
#
# Usage:
#   bash scripts/check.sh
set -euo pipefail

cd "$(dirname "$0")/.."

claude plugin validate .
cmp .claude-plugin/plugin.json .plugin/plugin.json
jq -e --slurpfile c .claude-plugin/plugin.json '.name == $c[0].name and .description == $c[0].description' plugin.json > /dev/null
bash scripts/tiers.sh
bash scripts/version-bump.sh "${BASE_REF:-origin/main}"
! grep -rnE '\$\{CLAUDE_SKILL_DIR\}|~/\.claude/|subagent_type=|`! [a-z]|claude --[a-z]' skills
bash skills/review/scripts/floor-guard.test.sh
bash skills/safe-repo/scripts/scan-secrets.test.sh
bash skills/to-doc/scripts/adf-outline.test.sh
