#!/usr/bin/env bash
# Tests for tiers.sh. Each case plants one drift in a scratch tree.
#
# Usage:
#   bash scripts/tiers.test.sh
set -uo pipefail

script="$(cd "$(dirname "$0")" && pwd)/tiers.sh"
failed=0

tree() {
  cd "$(mktemp -d)" || exit 2
  mkdir -p scripts docs skills/plan skills/fix skills/lint
  cp "$script" scripts/
  printf -- '---\nname: plan\ndisable-model-invocation: true\n---\n' > skills/plan/SKILL.md
  printf -- '---\nname: fix\n---\n' > skills/fix/SKILL.md
  printf -- '---\nname: lint\nuser-invocable: false\n---\n' > skills/lint/SKILL.md
  cat > docs/skill-conventions.md <<'EOF'
| Typed-only (1) | `disable-model-invocation: true` | plan |
| Both (1)       | default                          | fix  |
| Model only (1) | `user-invocable: false`          | lint |

The `/hb:` menu shows typed-only and both (2 entries); the model sees both and model-only descriptions (2).
EOF
}

check() {
  local want=$1 name=$2 got
  bash scripts/tiers.sh > /dev/null 2>&1
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
  tree
  "$@"
  check 1 "$name"
}

passes() {
  local name=$1
  shift
  tree
  "$@"
  check 0 "$name"
}

edit() { sed "$2" "$1" > "$1.tmp" && mv "$1.tmp" "$1"; }

passes "table matches frontmatter" true
flags "skill moved tier, table not" edit skills/fix/SKILL.md 's/^name: fix$/name: fix\nuser-invocable: false/'
flags "skill missing from its row" edit docs/skill-conventions.md 's/| fix  |/|      |/'
flags "row count drifted" edit docs/skill-conventions.md 's/Both (1)/Both (2)/'
flags "menu count drifted" edit docs/skill-conventions.md 's/(2 entries)/(3 entries)/'
flags "description count drifted" edit docs/skill-conventions.md 's/descriptions (2)/descriptions (3)/'
passes "name inside another name" edit docs/skill-conventions.md 's/| fix  |/| fix · prefix |/'

exit "$failed"
