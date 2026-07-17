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

# Note: no `set -e` / no aborting `pipefail` — `grep` exits 1 on a no-match,
# which is normal here (most files won't match most patterns). Under `set -e`
# that would kill the scan on the first non-matching file and silently miss
# everything after it.
set -uo pipefail

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
    # Process substitution (not a pipe) so `found` updates in this shell, and
    # `|| true` so a no-match (grep exit 1) never aborts the loop.
    while IFS= read -r match; do
      [ -n "$match" ] || continue
      lineno=${match%%:*}
      echo "$file:$lineno: $label"
      found=1
    done < <(grep -inE "$pattern" "$file" 2>/dev/null || true)
  done <<< "$files"
}

# POSIX ERE patterns (grep -inE) — portable to BSD grep (macOS) which lacks -P.
# Case-insensitivity comes from the -i flag, so no inline (?i).
scan 'AKIA[0-9A-Z]{16}' "AWS Access Key ID"
scan '(api[_-]?key|apikey)[[:space:]]*[=:][[:space:]]*["'\'']?[A-Za-z0-9_-]{16,}' "API Key assignment"
scan '(password|passwd|pwd)[[:space:]]*[=:][[:space:]]*["'\''][^"'\''[:space:]]{6,}' "Hardcoded password"
scan '(secret|token)[[:space:]]*[=:][[:space:]]*["'\''][A-Za-z0-9_.-]{10,}' "Secret/token assignment"
scan '-----BEGIN (RSA |EC |OPENSSH )?PRIVATE KEY-----' "Private key"
scan 'Authorization:[[:space:]]*Bearer[[:space:]]+[A-Za-z0-9._-]{20,}' "Bearer token in code"

if [ "$found" -eq 0 ]; then
  echo "No secret patterns found in tracked files." >&2
  exit 0
else
  exit 1
fi
