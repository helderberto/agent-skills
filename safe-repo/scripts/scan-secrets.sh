#!/usr/bin/env bash
# Scan git-tracked files for common secret patterns.
#
# Usage:
#   bash scripts/scan-secrets.sh
#
# Output (stdout):
#   file:line: <matched pattern description>
#
# Exit codes:
#   0 - no secrets found
#   1 - secrets found
#   2 - error (not a git repo, etc.)

set -euo pipefail

if ! git rev-parse --git-dir > /dev/null 2>&1; then
  echo "ERROR: not a git repository" >&2
  exit 2
fi

files=$(git ls-files 2>/dev/null)

if [ -z "$files" ]; then
  echo "ERROR: no tracked files found" >&2
  exit 2
fi

found=0

scan() {
  local pattern="$1"
  local label="$2"
  while IFS= read -r file; do
    # Skip binary files, minified JS, and node_modules
    case "$file" in
      *.min.js|*.min.css|node_modules/*|*.lock|*.sum) continue ;;
    esac
    if ! file "$file" 2>/dev/null | grep -q "text"; then
      continue
    fi
    grep -nP "$pattern" "$file" 2>/dev/null | while IFS= read -r match; do
      lineno=$(echo "$match" | cut -d: -f1)
      echo "$file:$lineno: $label"
      found=1
    done
  done <<< "$files"
}

scan 'AKIA[0-9A-Z]{16}' "AWS Access Key ID"
scan '(?i)(api[_-]?key|apikey)\s*[=:]\s*["\x27]?[A-Za-z0-9_\-]{16,}' "API Key assignment"
scan '(?i)(password|passwd|pwd)\s*[=:]\s*["\x27][^"\x27\s]{6,}' "Hardcoded password"
scan '(?i)(secret|token)\s*[=:]\s*["\x27][A-Za-z0-9_\-\.]{10,}' "Secret/token assignment"
scan '-----BEGIN (RSA |EC |OPENSSH )?PRIVATE KEY-----' "Private key"
scan '(?i)Authorization:\s*Bearer\s+[A-Za-z0-9\-_\.]{20,}' "Bearer token in code"

if [ "$found" -eq 0 ]; then
  echo "No secret patterns found in tracked files." >&2
  exit 0
else
  exit 1
fi
