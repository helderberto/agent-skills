#!/usr/bin/env bash
# PreToolUse hook on agent shell commands. Blocks destructive git commands
# and gates every git push on the outgoing secret scan and floor-guard.
#
# Input (stdin): hook event JSON; reads .tool_input.command and .cwd.
#
# Exit codes:
#   0 - allow
#   2 - block; stderr goes to the agent
set -uo pipefail

command -v jq > /dev/null || exit 0
event=$(cat)
cmd=$(jq -r '.tool_input.command // empty' <<< "$event")
case $cmd in *git*) ;; *) exit 0 ;; esac
dir=$(jq -r '.cwd // empty' <<< "$event")
[ -n "$dir" ] || dir=$PWD
root=$(cd "$(dirname "$0")/.." && pwd)
sep=$'\001'
prefix='^([A-Za-z_][A-Za-z0-9_]*=|env$|sudo$)'

block() { printf 'guard: blocked: %s\n' "$1" >&2; exit 2; }
resolve() { case $2 in /*) echo "$2" ;; "~"*) echo "$HOME${2#"~"}" ;; *) echo "$1/$2" ;; esac; }
short() {
  local re="^-[A-Za-z]*$1" a
  shift
  for a; do [[ $a =~ $re ]] && return 0; done
  return 1
}
has() {
  local want=$1 a
  shift
  for a; do [ "$a" = "$want" ] && return 0; done
  return 1
}

gate() {
  local out upstream
  cd "$1" 2> /dev/null || return 0
  out=$(bash "$root/skills/safe-repo/scripts/scan-secrets.sh" --outgoing 2> /dev/null)
  [ $? -eq 1 ] && block "push carries secrets"$'\n'"$out"
  upstream=$(git rev-parse --abbrev-ref '@{u}' 2> /dev/null)
  out=$(bash "$root/skills/review/scripts/floor-guard.sh" ${upstream:+--base "$upstream"} 2>&1)
  [ $? -eq 1 ] && block "push lowers the quality bar"$'\n'"$out"
}

# A quoted string becomes one token: quotes dropped, inner blanks and
# separators swapped for $sep. So a commit message can mention --no-verify.
segments=$(awk -v sep="$sep" '{
  out = ""
  for (i = 1; i <= length($0); i++) {
    c = substr($0, i, 1)
    if (q == "" && (c == "\"" || c == "\047")) { q = c; continue }
    if (c == q) { q = ""; continue }
    if (c == "\\" && q != "\047") c = substr($0, ++i, 1)
    if (q != "" && c ~ /[ \t;|&()]/) c = sep
    out = out c
  }
  printf "%s%s", out, (q == "" ? "\n" : sep)
}' <<< "$cmd" | tr ';|&()' '\n')

set -f
while IFS= read -r segment; do
  # Splitting into words is the point. set -f keeps globs literal.
  # shellcheck disable=SC2086
  set -- $segment
  while [ $# -gt 0 ] && [[ $1 =~ $prefix ]]; do shift; done
  [ $# -gt 0 ] || continue
  if [ "$1" = cd ]; then
    [ $# -gt 1 ] && dir=$(resolve "$dir" "${2//$sep/ }")
    continue
  fi
  [[ $1 = git || $1 = */git ]] || continue
  shift
  repo=$dir
  while [ $# -gt 0 ]; do
    case $1 in
      -C) repo=$(resolve "$repo" "${2:-}"); repo=${repo//$sep/ }; shift 2 || break ;;
      -c | --git-dir | --work-tree | --namespace | --config-env) shift 2 || break ;;
      -*) shift ;;
      *) break ;;
    esac
  done
  sub=${1:-}
  [ $# -gt 0 ] && shift
  has --no-verify "$@" && block "--no-verify skips the repo's hooks"
  case $sub in
    push)
      for a; do case $a in --force* | +*) block "force push rewrites remote history" ;; esac; done
      short f "$@" && block "force push rewrites remote history"
      gate "$repo"
      ;;
    reset) has --hard "$@" && block "git reset --hard discards uncommitted work" ;;
    clean) { has --force "$@" || short f "$@"; } && block "git clean -f deletes untracked files" ;;
    branch) short D "$@" && block "git branch -D deletes unmerged commits" ;;
  esac
done <<< "$segments"
exit 0
