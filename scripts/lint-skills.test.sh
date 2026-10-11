#!/usr/bin/env bash
# Tests for lint-skills.sh. Each case builds skills in a scratch root.
#
# Usage:
#   bash scripts/lint-skills.test.sh
set -uo pipefail

here="$(cd "$(dirname "$0")" && pwd)"
lint="$here/lint-skills.sh"
failed=0

root() {
  cd "$(mktemp -d)" || exit 2
  skill alpha 'Alpha skill.'
  skill beta 'Beta skill.'
}

# skill <name> <description> [frontmatter line] [body]
skill() {
  mkdir -p "skills/$1"
  {
    printf -- '---\nname: %s\n' "$1"
    [ -n "${3:-}" ] && printf '%s\n' "$3"
    printf 'description: %s\n---\n\n%s\n' "$2" "${4:-Body.}"
  } > "skills/$1/SKILL.md"
}

# typed <name> <body>
typed() { skill "$1" "$1." 'disable-model-invocation: true' "$2"; }

# typed_pair <body>: typed-only gamma with <body> beside typed-only beta.
typed_pair() {
  typed beta 'Body.'
  typed gamma "$1"
}

# chars <n>: a string of <n> characters.
chars() { printf 'a%.0s' $(seq "$1"); }

check() {
  local want=$1 name=$2 got
  bash "$lint" "$PWD" > /dev/null 2>&1
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
  root
  "$@"
  check 1 "$name"
}

passes() {
  local name=$1
  shift
  root
  "$@"
  check 0 "$name"
}

passes "no references" true
passes "valid references and non-skill slashes" skill gamma 'See /beta.' '' 'Run `/beta`, `/hb:alpha`, or call the Skill tool with `beta`. Then `/clear`, `/compact`, `/tmp`, `/name`, > /dev/null, `children`/slots.'
passes "typed-only calls both-tier" typed gamma 'Call the Skill tool with `beta`.'
passes "typed-only suggests typed-only" typed_pair 'Next: `/hb:beta`'
passes "340-char description, multibyte" skill gamma "$(chars 338)—a"
flags "dangling slash reference" skill gamma 'Gamma.' '' 'Then run `/nope`.'
flags "dangling /hb: reference" skill gamma 'Gamma.' '' 'Next: `/hb:nope <slug>`'
flags "dangling Skill tool reference" skill gamma 'Gamma.' '' 'Call the Skill tool with `nope`.'
flags "typed-only calls typed-only" typed_pair 'Call the Skill tool with `beta`.'
flags "duplicate name" cp -R skills/beta skills/beta2
flags "341-char description" skill gamma "$(chars 341)"

cd "$(mktemp -d)" || exit 2
check 2 "no skills"

cd "$here/.." || exit 2
check 0 "this repo"

exit "$failed"
