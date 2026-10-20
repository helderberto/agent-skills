#!/usr/bin/env bash
# skills.sh security audit status per skill: Agent Trust Hub, Socket, Snyk.
# Needs network, so CI doesn't run it.
#
# Usage:
#   bash scripts/audits.sh
set -uo pipefail

cd "$(dirname "$0")/.."

api="https://skills.sh/api/v1/skills/audit/helderberto/agent-skills"

for dir in skills/*/; do
  skill=$(basename "$dir")
  status=$(curl -sf "$api/$skill" | jq -r '[.audits[] | "\(.provider)=\(.status)"] | join(" ")')
  printf '%-26s %s\n' "$skill" "${status:-not audited}"
done
