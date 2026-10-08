#!/usr/bin/env bash
# Tests for floor-guard.sh. Each case plants one move in a scratch repo.
#
# Usage:
#   bash skills/review/scripts/floor-guard.test.sh
set -uo pipefail

guard="$(cd "$(dirname "$0")" && pwd)/floor-guard.sh"
failed=0

repo() {
  cd "$(mktemp -d)" || exit 2
  git init -q -b main
  git config user.email t@example.com
  git config user.name t
  git config commit.gpgsign false
  mkdir -p src
  printf 'export const add = (a, b) => a + b;\n' > src/add.js
  printf "test('adds', () => {\n  expect(add(1, 2)).toBe(3);\n  expect(add(0, 0)).toBe(0);\n});\n" > src/add.test.js
  printf 'test("old", () => { expect(1).toBe(1); });\n' > src/old.test.js
  printf 'def run():\n    return 1\n' > src/app.py
  printf 'module.exports = {\n  coverageThreshold: { global: { lines: 80 } },\n};\n' > jest.config.js
  git add -A
  git commit -qm base
}

check() {
  local want=$1 name=$2 got
  bash "$guard" > /dev/null 2>&1
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
edit() { sed "$2" "$1" > "$1.tmp" && mv "$1.tmp" "$1"; }

passes "clean diff" append src/add.js 'export const sub = (a, b) => a - b;'
passes "assertion changed, not removed" edit src/add.test.js 's/toBe(3)/toEqual(3)/'
passes "threshold raised" edit jest.config.js 's/lines: 80/lines: 90/'

flags "@ts-ignore" append src/add.js '// @ts-ignore'
flags "@ts-nocheck" append src/add.js '// @ts-nocheck'
flags "eslint-disable" append src/add.js '/* eslint-disable no-console */'
flags "biome-ignore" append src/add.js '// biome-ignore lint: x'
flags "# noqa" append src/app.py 'import os  # noqa'
flags "# type: ignore" append src/app.py 'x = run()  # type: ignore'
flags "istanbul ignore" append src/add.js '/* istanbul ignore next */'
flags "Stryker disable" append src/add.js '// Stryker disable all'
flags "nosemgrep" append src/add.js '// nosemgrep'
flags "gitleaks:allow" append src/add.js 'const k = "x"; // gitleaks:allow'
flags ".skip" append src/add.test.js "test.skip('later', () => {});"
flags ".only" append src/add.test.js "describe.only('focus', () => {});"
flags "test file deleted" rm src/old.test.js
flags "assertion removed" edit src/add.test.js '/add(0, 0)/d'
flags "threshold lowered" edit jest.config.js 's/lines: 80/lines: 70/'
flags "threshold removed" edit jest.config.js '/lines: 80/d'
flags "max budget raised" eval "printf '{\"maxSize\": 100}\n' > .size-limit.json && git add .size-limit.json && git commit -qm budget && edit .size-limit.json s/100/200/"
flags "not implemented stub" append src/add.js 'export const mul = () => { throw new Error("Not implemented"); };'
flags "empty catch" append src/add.js 'try { add(); } catch {}'
flags "empty catch with binding" append src/add.js 'try { add(); } catch (e) {}'
flags "untracked file" eval "printf '// @ts-ignore\n' > src/new.js"
flags "committed on a branch" eval "git checkout -qb feat && printf '// @ts-ignore\n' >> src/add.js && git commit -qam wip"

cd "$(mktemp -d)" || exit 2
check 2 "not a git repo"

exit "$failed"
