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
  git init -q -b main
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

check() {
  local want=$1 name=$2 line=${3:-} out got
  out=$(bash "$scan" 2> /dev/null)
  got=$?
  if [ "$got" = "$want" ] && { [ -z "$line" ] || printf '%s\n' "$out" | grep -qxF "$line"; }; then
    echo "ok   $name"
  else
    echo "FAIL $name: exit $got, want $want${line:+ with $line}"
    failed=1
  fi
}

reports() {
  local name=$1 line=$2
  shift 2
  repo
  plant "$@"
  check 1 "$name" "$line"
}

passes() {
  local name=$1
  shift
  repo
  plant "$@"
  check 0 "$name"
}

passes "clean repo" notes.txt 'nothing to see\n'
passes "short or unquoted values" near.txt 'AKIA''ABCDEFGHIJKLMNO\napi_ke''y = "abcdefghijklmno"\npass''word = hunter22\npass''word = "12345"\ntok''en = abcdefghij12\ntok''en = "abcdefghi"\nAuthorization: Bear''er abcdefghijklmnopqrs\n'
reports "AWS access key" "aws.txt:1: AWS Access Key ID" aws.txt 'id = AKIA''ABCDEFGHIJKLMNOP\n'
reports "API key" "cfg.txt:1: API Key assignment" cfg.txt 'api_ke''y = "abcdefghijklmnopqrstu"\n'
reports "API key, uppercase" "up.txt:1: API Key assignment" up.txt 'API_KE''Y: abcdefghijklmnopqrstu\n'
reports "hardcoded password" "app.txt:2: Hardcoded password" app.txt 'a\npass''word = "hunter22secret"\n'
reports "passwd" "passwd.txt:1: Hardcoded password" passwd.txt 'pass''wd = "hunter22passwd"\n'
reports "pwd" "pwd.txt:1: Hardcoded password" pwd.txt 'pw''d: "hunter22pwd"\n'
reports "token" "env.txt:1: Secret/token assignment" env.txt 'tok''en = "abcdefghij123456"\n'
reports "secret" "secret.txt:1: Secret/token assignment" secret.txt 'sec''ret = "abcdefghij123456"\n'
reports "RSA private key" "key.pem:1: Private key" key.pem '-----BEGIN RSA ''PRIVATE KEY-----\n'
reports "EC private key" "ec.pem:1: Private key" ec.pem '-----BEGIN EC ''PRIVATE KEY-----\n'
reports "OpenSSH private key" "ssh.pem:1: Private key" ssh.pem '-----BEGIN OPENSSH ''PRIVATE KEY-----\n'
reports "PKCS8 private key" "p8.pem:1: Private key" p8.pem '-----BEGIN ''PRIVATE KEY-----\n'
reports "bearer token" "http.txt:1: Bearer token in code" http.txt 'Authorization: Bear''er abcdefghijklmnopqrstuvwx\n'
# \001, not \0: GNU grep hides matching lines in NUL files, which would mask a broken skip.
passes "binary file skipped" bin.dat 'pass''word = "hunter22binary"\001\n'
passes "node_modules skipped" node_modules/x.js 'pass''word = "hunter22module"\n'
passes "lockfile skipped" yarn.lock 'pass''word = "hunter22lockfile"\n'
passes "minified JS skipped" app.min.js 'pass''word = "hunter22minjs"\n'
passes "minified CSS skipped" app.min.css 'pass''word = "hunter22mincss"\n'
passes "checksum file skipped" go.sum 'pass''word = "hunter22gosum"\n'

repo
check 2 "no tracked files"

cd "$(mktemp -d)" || exit 2
check 2 "not a git repo"

exit "$failed"
