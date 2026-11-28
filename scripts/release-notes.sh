#!/usr/bin/env bash
# Prints the CHANGELOG.md entry for <version>, without its heading. Fails when there is none.
#
# Usage:
#   bash scripts/release-notes.sh <version> [changelog]   # default: CHANGELOG.md
set -euo pipefail

version=$1
file=${2:-CHANGELOG.md}

awk -v head="## [$version]" '
  index($0, head) == 1 { found = 1; on = 1; next }
  on && (/^## \[/ || /^\[[^]]+\]: /) { exit }
  on { print }
  END { exit !found }
' "$file" | sed -e '/./,$!d' | sed -e ':a' -e '/^\n*$/{$d;N;ba' -e '}'
