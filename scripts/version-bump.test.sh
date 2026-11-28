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
  git commit -qm "${msg:-chore: change}"
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
bump() {
  printf '{ "version": "%s" }\n' "${1:-1.1.0}" > .claude-plugin/plugin.json
  printf '## [%s] - 2026-01-01\n' "${1:-1.1.0}" >> CHANGELOG.md
}
bare_bump() { printf '{ "version": "%s" }\n' "$1" > .claude-plugin/plugin.json; }
edit() { append skills/fix/SKILL.md more; bump "$1"; }

passes "change outside skills" append README.md 'more'
flags "skill edited, no bump" append skills/fix/SKILL.md 'more'
msg='feat: add' passes "skill edited, bumped" edit 1.1.0
flags "skill deleted, no bump" rm -r skills/fix
flags "skill renamed, no bump" git mv skills/fix skills/repair
msg='feat: rename' passes "skill renamed, bumped" eval "git mv skills/fix skills/repair; bump"
msg='fix: typo' passes "fix bumps patch" edit 1.0.1
msg='fix: typo' flags "fix with minor bump" edit 1.1.0
msg='feat: add' flags "feat with patch bump" edit 1.0.1
msg='feat!: drop flag' passes "bang bumps major" edit 2.0.0
msg='feat!: drop flag' flags "bang with minor bump" edit 1.1.0
msg='feat: add' flags "bump without changelog entry" eval "append skills/fix/SKILL.md more; bare_bump 1.1.0"
msg=$'refactor: x\n\nBREAKING CHANGE: renamed' passes "footer bumps major" edit 2.0.0

exit "$failed"
