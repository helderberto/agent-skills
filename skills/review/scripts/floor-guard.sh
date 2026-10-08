#!/usr/bin/env bash
# Flag diff moves that lower the quality bar: new suppressions, skipped or
# deleted tests, removed assertions, loosened thresholds, stubs.
#
# Usage:
#   bash floor-guard.sh [--base <ref>]
#
# Diffs the merge base with <ref> (default: origin/HEAD, main, master)
# against the working tree, untracked files included.
#
# Output (stderr):
#   [rule] file:line
#   Never prints the matched line, which may hold a secret.
#
# Exit codes:
#   0 - clean
#   1 - at least one violation
#   2 - could not run (not a git repo, no merge base)
set -uo pipefail

bail() { echo "floor-guard: $1" >&2; exit 2; }

top=$(git rev-parse --show-toplevel 2> /dev/null) || bail "not a git repository"
cd "$top" || bail "cannot enter $top"

base=""
[ "${1:-}" = "--base" ] && base=${2:-}
if [ -z "$base" ]; then
  for ref in origin/HEAD main master; do
    git rev-parse --verify --quiet "$ref^{commit}" > /dev/null && base=$ref && break
  done
fi
[ -n "$base" ] || bail "no base ref; pass --base <ref>"
merge_base=$(git merge-base "$base" HEAD 2> /dev/null) || bail "no merge base with $base"

diff=$(git diff --unified=0 --no-color --no-ext-diff "$merge_base" --) || bail "cannot diff against $merge_base"
while IFS= read -r file; do
  [ -n "$file" ] || continue
  # --no-index exits 1 whenever the sides differ, which is always true here.
  untracked=$(git diff --no-index --unified=0 --no-color /dev/null "$file")
  [ $? -le 1 ] || bail "cannot diff untracked $file"
  diff+=$'\n'"$untracked"
done < <(git ls-files --others --exclude-standard)

printf '%s\n' "$diff" | awk '
  function is_test(f) { return f ~ /(^|\/)(tests?|__tests__|spec)\// || f ~ /[._](test|spec|cy)\.|(^|\/)test_|_test\.[a-z]+$/ }
  function is_config(f) { return f ~ /\.(json|toml|ini|cfg|ya?ml)$/ || f ~ /(^|\/)[^\/]*config[^\/]*$/ || f ~ /(^|\/)\.[^\/]*rc(\.[a-z]+)?$/ || f ~ /(^|\/)(Makefile|\.coveragerc|CONSTRAINTS\.md)$/ }
  function flag(rule, where) { print "[" rule "] " where; found = 1 }
  function direction(key) {
    key = tolower(key)
    if (key ~ /^(branches|functions|lines|statements|fail[_-]under|cov-fail-under|threshold|coverage|min.*)$/) return "min"
    if (key ~ /^(max.*|budget.*|limit|size-limit)$/) return "max"
    return ""
  }
  # Records each threshold on a line as file SUBSEP key SUBSEP nth -> value.
  function thresholds(f, text, line, side,    rest, pair, key, n) {
    rest = text
    while (match(rest, /[A-Za-z][A-Za-z0-9_-]*["\047]?[ \t]*[:= ][ \t]*["\047]?[0-9]+(\.[0-9]+)?/)) {
      pair = substr(rest, RSTART, RLENGTH)
      rest = substr(rest, RSTART + RLENGTH)
      key = pair; sub(/["\047]?[ \t]*[:= ].*/, "", key)
      if (direction(key) == "") continue
      n = ++count[side, f, key]
      value[side, f, key, n] = pair; sub(/^.*[^0-9.]/, "", value[side, f, key, n])
      at[side, f, key, n] = line
      keys[f SUBSEP key] = 1
    }
  }

  /^diff / { header = 1; next }
  header && /^--- / { old = substr($0, 5); sub(/^a\//, "", old); next }
  header && /^\+\+\+ / {
    new = substr($0, 5); sub(/^b\//, "", new)
    file = new == "/dev/null" ? old : new
    if (new == "/dev/null") deleted[file] = 1
    if (new == "/dev/null" && is_test(file)) flag("test-deleted", file)
    next
  }
  /^@@/ {
    header = 0
    match($0, /-[0-9]+/); old_line = substr($0, RSTART + 1, RLENGTH - 1)
    match($0, /\+[0-9]+/); new_line = substr($0, RSTART + 1, RLENGTH - 1)
    next
  }
  header { next }
  /^\+/ {
    text = substr($0, 2); where = file ":" new_line
    if (text ~ /@ts-ignore|@ts-nocheck|eslint-disable|biome-ignore|#[ \t]*noqa|#[ \t]*type:[ \t]*ignore|istanbul ignore|Stryker disable|nosemgrep|gitleaks:allow/) flag("silenced-checker", where)
    if (text ~ /[Nn]ot [Ii]mplemented/ && text ~ /throw|raise|panic/) flag("stub", where)
    if (text ~ /catch[ \t]*(\([^)]*\))?[ \t]*\{[ \t]*\}/) flag("empty-catch", where)
    if (is_test(file) && text ~ /\.(skip|only)[ \t]*\(|(^|[^A-Za-z0-9_])(xit|xdescribe|xtest|fit|fdescribe)\(|@pytest\.mark\.skip|t\.Skip\(/) flag("test-skipped", where)
    if (is_test(file) && text ~ /(^|[^A-Za-z0-9_])(expect|assert[A-Za-z_]*|should)([^A-Za-z0-9_]|$)/) asserts_added[file]++
    if (is_config(file)) thresholds(file, text, where, "+")
    new_line++
    next
  }
  /^-/ {
    text = substr($0, 2); where = file ":" old_line
    if (is_test(file) && text ~ /(^|[^A-Za-z0-9_])(expect|assert[A-Za-z_]*|should)([^A-Za-z0-9_]|$)/) {
      asserts_removed[file]++
      if (!(file in first_removed)) first_removed[file] = where
    }
    if (is_config(file)) thresholds(file, text, where, "-")
    old_line++
    next
  }

  END {
    for (f in asserts_removed) {
      if (deleted[f]) continue
      if (asserts_removed[f] > asserts_added[f] + 0) flag("assertion-removed", first_removed[f])
    }
    for (fk in keys) {
      split(fk, part, SUBSEP)
      f = part[1]; key = part[2]; dir = direction(key)
      for (n = 1; n <= count["-", f, key]; n++) {
        was = value["-", f, key, n] + 0
        if (n > count["+", f, key]) { flag("threshold-removed", at["-", f, key, n]); continue }
        now = value["+", f, key, n] + 0
        if ((dir == "min" && now < was) || (dir == "max" && now > was)) flag("threshold-loosened", at["+", f, key, n])
      }
    }
    exit found
  }
' >&2
status=$?

[ "$status" -eq 0 ] && echo "floor-guard: clean" >&2
exit "$status"
