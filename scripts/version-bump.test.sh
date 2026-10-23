#!/usr/bin/env bash
# Tests for version-bump.sh. Each case plants one change in a scratch repo branched off main.
#
# Usage:
#   bash scripts/version-bump.test.sh
set -uo pipefail

script="$(cd "$(dirname "$0")" && pwd)/version-bump.sh"
failed=0

repo() {
  cd "$(mktemp -d)" || exit 2
  git init -q -b main
  git config user.email t@example.com
  git config user.name t
  git config commit.gpgsign false
  mkdir -p scripts .claude-plugin skills/fix
  cp "$script" scripts/
  printf '{ "version": "1.0.0" }\n' > .claude-plugin/plugin.json
  printf -- '---\nname: fix\n---\n' > skills/fix/SKILL.md
  printf '# Readme\n' > README.md
  git add -A
  git commit -qm base
  git switch -qc topic
}

check() {
  local want=$1 name=$2 got
  git add -A
  git commit -qm change
  bash scripts/version-bump.sh main > /dev/null 2>&1
  got=$?
  if [ "$got" = "$want" ]; then
    echo "ok   $name"
  else
    echo "FAIL $name: exit $got, want $want"
    failed=1
  fi
}

flags() {
  local name=$1
  shift
  repo
  "$@"
  check 1 "$name"
}

passes() {
  local name=$1
  shift
  repo
  "$@"
  check 0 "$name"
}

append() { printf '%s\n' "$2" >> "$1"; }
bump() { printf '{ "version": "1.1.0" }\n' > .claude-plugin/plugin.json; }

passes "change outside skills" append README.md 'more'
flags "skill edited, no bump" append skills/fix/SKILL.md 'more'
passes "skill edited, bumped" eval "append skills/fix/SKILL.md more; bump"
flags "skill deleted, no bump" rm -r skills/fix
flags "skill renamed, no bump" git mv skills/fix skills/repair
passes "skill renamed, bumped" eval "git mv skills/fix skills/repair; bump"

exit "$failed"
