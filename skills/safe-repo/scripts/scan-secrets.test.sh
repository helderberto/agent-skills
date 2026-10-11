#!/usr/bin/env bash
# Tests for scan-secrets.sh. Each case plants one file in a scratch repo.
# Planted secrets are split across quotes so this file scans clean.
#
# Usage:
#   bash skills/safe-repo/scripts/scan-secrets.test.sh
set -uo pipefail

scan="$(cd "$(dirname "$0")" && pwd)/scan-secrets.sh"
failed=0

repo() {
  cd "$(mktemp -d)" || exit 2
  git init -q
  git config user.email t@example.com
  git config user.name t
  git config commit.gpgsign false
  printf 'export const add = (a, b) => a + b;\n' > add.js
}

plant() {
  mkdir -p "$(dirname "$1")"
  printf '%b' "$2" > "$1"
  git add -A -f
  git commit -qm plant
}

reports() {
  local name=$1 want=$2 out got
  shift 2
  repo
  plant "$@"
  out=$(bash "$scan" 2> /dev/null)
  got=$?
  if [ "$got" = 1 ] && printf '%s\n' "$out" | grep -qxF "$want"; then
    echo "ok   $name"
  else
    echo "FAIL $name: exit $got, want 1 with '$want'"
    failed=1
  fi
}

passes() {
  local name=$1 got
  shift
  repo
  plant "$@"
  bash "$scan" > /dev/null 2>&1
  got=$?
  if [ "$got" = 0 ]; then
    echo "ok   $name"
  else
    echo "FAIL $name: exit $got, want 0"
    failed=1
  fi
}

passes "clean repo" notes.txt 'nothing to see\n'
reports "AWS access key" "aws.txt:1: AWS Access Key ID" aws.txt 'id = AKIA''ABCDEFGHIJKLMNOP\n'
reports "API key" "cfg.txt:1: API Key assignment" cfg.txt 'api''_key = "abcdefghijklmnopqrstu"\n'
reports "hardcoded password" "app.txt:2: Hardcoded password" app.txt 'a\npass''word = "hunter22secret"\n'
reports "token" "env.txt:1: Secret/token assignment" env.txt 'tok''en = "abcdefghij123456"\n'
reports "private key" "key.pem:1: Private key" key.pem '-----BEGIN RSA ''PRIVATE KEY-----\n'
reports "bearer token" "http.txt:1: Bearer token in code" http.txt 'Authorization: Bear''er abcdefghijklmnopqrstuvwx\n'
passes "binary file skipped" bin.dat 'pass''word = "hunter22binary"\0\n'
passes "node_modules skipped" node_modules/x.js 'pass''word = "hunter22module"\n'
passes "lockfile skipped" yarn.lock 'pass''word = "hunter22lockfile"\n'

cd "$(mktemp -d)" || exit 2
bash "$scan" > /dev/null 2>&1
got=$?
if [ "$got" = 2 ]; then
  echo "ok   not a git repo"
else
  echo "FAIL not a git repo: exit $got, want 2"
  failed=1
fi

exit "$failed"
