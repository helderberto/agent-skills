#!/usr/bin/env bash
# Scan git-tracked files for common secret patterns.
#
# Usage:
#   bash scripts/scan-secrets.sh [--outgoing]
#
# --outgoing scans only lines added by commits not on any remote.
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

outgoing=false
[ "${1:-}" = "--outgoing" ] && outgoing=true

if $outgoing; then
  scope="outgoing commits"
  # file:line<TAB>text for each added line. Header state keeps an added
  # "++ x" line from reading as a file header.
  added=$(git log -p --unified=0 --no-color --no-ext-diff --format='commit %h' HEAD --not --remotes 2>/dev/null | awk '
    /^diff / { header = 1; next }
    header && /^\+\+\+ / {
      file = substr($0, 5); sub(/^b\//, "", file)
      skip = file ~ /\.min\.(js|css)$|^node_modules\/|\.(lock|sum)$/
      next
    }
    /^@@/ { header = 0; match($0, /\+[0-9]+/); line = substr($0, RSTART + 1, RLENGTH - 1); next }
    header { next }
    /^\+/ { if (!skip) print file ":" line "\t" substr($0, 2); line++ }
  ') || { echo "ERROR: cannot read outgoing commits" >&2; exit 2; }
else
  scope="tracked files"
  files=$(git ls-files 2>/dev/null)

  if [ -z "$files" ]; then
    echo "ERROR: no tracked files found" >&2
    exit 2
  fi
fi

found=0

scan() {
  local pattern="$1"
  local label="$2"
  if $outgoing; then
    while IFS= read -r match; do
      [ -n "$match" ] || continue
      echo "${match%%$'\t'*}: $label"
      found=1
    done < <(printf '%s\n' "$added" | grep -iE $'\t'".*($pattern)" || true)
    return
  fi
  while IFS= read -r file; do
    # Skip binary files, minified JS, and node_modules
    case "$file" in
      *.min.js|*.min.css|node_modules/*|*.lock|*.sum) continue ;;
    esac
    if file --mime "$file" 2>/dev/null | grep -q "charset=binary"; then
      continue
    fi
    # Process substitution (not a pipe) so `found` updates in this shell, and
    # `|| true` so a no-match (grep exit 1) never aborts the loop.
    while IFS= read -r match; do
      [ -n "$match" ] || continue
      lineno=${match%%:*}
      echo "$file:$lineno: $label"
      found=1
    done < <(grep -inE -e "$pattern" "$file" 2>/dev/null || true)
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
  echo "No secret patterns found in $scope." >&2
  exit 0
else
  exit 1
fi
