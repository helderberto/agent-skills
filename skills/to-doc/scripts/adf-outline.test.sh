#!/usr/bin/env bash
# Tests for adf-outline.sh. Each case writes one ADF fixture to a temp file.
#
# Usage:
#   bash skills/to-doc/scripts/adf-outline.test.sh
set -uo pipefail

outline="$(cd "$(dirname "$0")" && pwd)/adf-outline.sh"
failed=0

panel='{"type":"panel","attrs":{"panelType":"info"},"content":[{"type":"paragraph","content":[{"type":"text","text":"TL;DR. Cache it."}]}]}'
heading='{"type":"heading","attrs":{"level":2},"content":[{"type":"text","text":"The loop"}]}'
macro='{"type":"extension","attrs":{"extensionType":"com.atlassian.ecosystem","extensionKey":"23392b90-4271-4239-98ca-a3e96c663cbb/63d4d207-ac2f-4273-865c-0240d37f044a/static/mermaid-diagram"}}'
code='{"type":"codeBlock","attrs":{"language":"mermaid"},"content":[{"type":"text","text":"graph LR; A-->B"}]}'

doc() {
  local IFS=,
  printf '{"type":"doc","version":1,"content":[%s]}' "$*"
}

expand() {
  local IFS=,
  printf '{"type":"expand","attrs":{"title":"Diagram"},"content":[%s]}' "$*"
}

check() {
  local want=$1 name=$2 body=$3 want_out=$4 want_err=${5:-} file out err got
  file=$(mktemp)
  printf '%s' "$body" > "$file"
  out=$(bash "$outline" "$file" 2> "$file.err")
  got=$?
  err=$(cat "$file.err")
  rm -f "$file" "$file.err"
  if [ "$got" = "$want" ] && [ "$out" = "$want_out" ] && [[ $err == *"$want_err"* ]]; then
    echo "ok   $name"
  else
    printf 'FAIL %s: exit %s, want %s\n%s\n%s\n' "$name" "$got" "$want" "$out" "$err"
    failed=1
  fi
}

good=$(doc "$panel" "$heading" "$macro" "$(expand "$code")")
good_out=$'panel info\nh2 The loop\nmacro mermaid-diagram\nexpand Diagram\n  code mermaid'

check 0 "macro then expand with source" "$good" "$good_out"
check 0 "doc in a page envelope" "$(jq -n --argjson d "$good" '{id: "1", type: "page", body: $d}')" "$good_out"
check 0 "doc as a string in a saved tool result" \
  "$(jq -n --arg t "$(jq -n --arg d "$good" '{type: "page", body: $d}')" '[{type: "text", text: $t}]')" "$good_out"
check 1 "macro duplicated inside expand" "$(doc "$heading" "$macro" "$(expand "$macro" "$code")")" \
  $'h2 The loop\nmacro mermaid-diagram\nexpand Diagram\n  macro mermaid-diagram\n  code mermaid\nFLAG macro inside expand: Diagram'
check 2 "not json" "<p>html</p>" "" "not ADF JSON"

exit "$failed"
