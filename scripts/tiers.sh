#!/usr/bin/env bash
# Fails when the tier table in docs/skill-conventions.md drifts from the skills' frontmatter.
#
# Usage:
#   bash scripts/tiers.sh
set -euo pipefail

cd "$(dirname "$0")/.."

doc=docs/skill-conventions.md
fail=0
typed=0 both=0 model=0

for f in skills/*/SKILL.md; do
  s=$(basename "$(dirname "$f")")
  if grep -q '^disable-model-invocation: true' "$f"; then row='Typed-only'; typed=$((typed + 1))
  elif grep -q '^user-invocable: false' "$f"; then row='Model only'; model=$((model + 1))
  else row='Both'; both=$((both + 1)); fi
  grep -E "^\| $row \(" "$doc" | grep -qE "(\| | · )$s( · | +\|)" || { echo "$s: missing from the $row row" >&2; fail=1; }
done

for want in "| Typed-only ($typed)" "| Both ($both)" "| Model only ($model)" "($((typed + both)) entries)" "descriptions ($((both + model)))"; do
  grep -qF "$want" "$doc" || { echo "$doc: expected \"$want\"" >&2; fail=1; }
done

exit "$fail"
