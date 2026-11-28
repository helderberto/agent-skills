#!/usr/bin/env bash
# Fails when skills/ changed since <base> and .claude-plugin/plugin.json doesn't carry
# the bump its commits imply (`!` or BREAKING CHANGE -> major, feat -> minor, else patch),
# or CHANGELOG.md has no entry for the new version.
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

log=$(git log --format=%B "$base"..HEAD)
IFS=. read -r major minor patch <<< "$old"

if grep -qE '^[a-z]+(\([^)]*\))?!:|^BREAKING[ -]CHANGE:' <<< "$log"; then
  want="$((major + 1)).0.0"
elif grep -qE '^feat(\([^)]*\))?:' <<< "$log"; then
  want="$major.$((minor + 1)).0"
else
  want="$major.$minor.$((patch + 1))"
fi

if [ "$new" != "$want" ]; then
  echo "commits since $base imply $want, but .claude-plugin/plugin.json reads $new" >&2
  exit 1
fi

if ! grep -qF "## [$new]" CHANGELOG.md 2> /dev/null; then
  echo "CHANGELOG.md has no entry for $new" >&2
  exit 1
fi
