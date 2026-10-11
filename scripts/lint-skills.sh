#!/usr/bin/env bash
# Lint skills: unique names, references to existing skills, typed-only
# skills never calling typed-only skills, descriptions within budget.
#
# Usage:
#   bash scripts/lint-skills.sh [root]
#
# Reads <root>/skills/*/SKILL.md (default root: this repo).
#
# Output (stderr):
#   [rule] file:line name
#
# Exit codes:
#   0 - clean
#   1 - at least one violation
#   2 - could not run (no skills found)
set -uo pipefail

max_description=340
root=${1:-"$(cd "$(dirname "$0")/.." && pwd)"}
# Slash tokens skills mention that are not skills: built-in commands, paths, placeholders.
not_skills="clear compact name tmp"

cd "$root" 2> /dev/null || { echo "lint-skills: cannot enter $root" >&2; exit 2; }
files=(skills/*/SKILL.md)
[ -f "${files[0]}" ] || { echo "lint-skills: no skills under $root/skills" >&2; exit 2; }

# C locale makes awk count bytes everywhere; dropping UTF-8 continuation bytes leaves characters.
LC_ALL=C awk -v allow="$not_skills" -v max="$max_description" '
  function flag(rule, where, name) { print "[" rule "] " where " " name; found = 1 }
  FNR == 1 { fm = 0 }
  FNR == 1 && /^---$/ { fm = 1; next }
  fm && /^---$/ { fm = 0 }
  fm && /^name:/ {
    if ($2 in seen) flag("duplicate-name", FILENAME ":" FNR, $2)
    seen[$2] = 1
    name_of[FILENAME] = $2
  }
  fm && /^description:/ {
    text = $0
    sub(/^description:[ \t]*/, "", text)
    gsub(/[\200-\277]/, "", text)
    if (length(text) > max) flag("long-description", FILENAME ":" FNR, length(text) " > " max)
  }
  fm && /^disable-model-invocation:[ \t]*true/ { typed_file[FILENAME] = 1 }
  {
    rest = " " $0
    while (match(rest, /[ (]`?\/(hb:)?[a-z][a-z0-9-]*/)) {
      token = substr(rest, RSTART, RLENGTH)
      rest = substr(rest, RSTART + RLENGTH)
      if (rest ~ /^\//) continue
      sub(/^[^\/]*\/(hb:)?/, "", token)
      refs++
      ref_name[refs] = token
      ref_where[refs] = FILENAME ":" FNR
    }
    rest = $0
    while (match(rest, /Skill tool with `[a-z0-9-]+`/)) {
      token = substr(rest, RSTART + 17, RLENGTH - 18)
      rest = substr(rest, RSTART + RLENGTH)
      refs++
      ref_name[refs] = token
      ref_where[refs] = FILENAME ":" FNR
      call_from[refs] = FILENAME
    }
  }
  END {
    n = split(allow, words, " ")
    for (i = 1; i <= n; i++) seen[words[i]] = 1
    for (f in typed_file) typed[name_of[f]] = 1
    for (i = 1; i <= refs; i++) {
      if (!(ref_name[i] in seen)) flag("unknown-skill", ref_where[i], ref_name[i])
      if ((call_from[i] in typed_file) && (ref_name[i] in typed)) flag("typed-only-calls-typed-only", ref_where[i], ref_name[i])
    }
    exit found
  }
' "${files[@]}" >&2
