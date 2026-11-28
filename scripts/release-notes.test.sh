#!/usr/bin/env bash
# Tests for release-notes.sh against a planted changelog.
#
# Usage:
#   bash scripts/release-notes.test.sh
set -uo pipefail

script="$(cd "$(dirname "$0")" && pwd)/release-notes.sh"
failed=0
log=$(mktemp)

cat > "$log" <<'MD'
# Changelog

## [Unreleased]

## [1.1.0] - 2026-01-02

Summary of 1.1.0.

### Added

- new thing

## [1.0.0] - 2026-01-01

First.

[Unreleased]: https://example.com/compare/v1.1.0...HEAD
[1.1.0]: https://example.com/compare/v1.0.0...v1.1.0
MD

expect() {
  local name=$1 want=$2 got
  shift 2
  got=$(bash "$script" "$@" 2> /dev/null; echo "exit=$?")
  if [ "$got" = "$want" ]; then
    echo "ok   $name"
  else
    printf 'FAIL %s\n--- got\n%s\n--- want\n%s\n' "$name" "$got" "$want"
    failed=1
  fi
}

expect "middle entry" $'Summary of 1.1.0.\n\n### Added\n\n- new thing\nexit=0' 1.1.0 "$log"
expect "last entry skips link refs" $'First.\nexit=0' 1.0.0 "$log"
expect "missing entry fails" 'exit=1' 2.0.0 "$log"

exit "$failed"
