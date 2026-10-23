#!/usr/bin/env bash
# Fails when skills/ changed since <base> but .claude-plugin/plugin.json kept its version.
#
# Usage:
#   bash scripts/version-bump.sh [base]   # default: origin/main
set -euo pipefail

cd "$(dirname "$0")/.."

base=${1:-origin/main}

git diff --quiet "$base"...HEAD -- skills && exit 0

old=$(git show "$base:.claude-plugin/plugin.json" | jq -r .version)
new=$(jq -r .version .claude-plugin/plugin.json)

if [ "$old" = "$new" ]; then
  echo "skills/ changed since $base but the version is still $old: bump .claude-plugin/plugin.json" >&2
  exit 1
fi
