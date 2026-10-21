#!/usr/bin/env bash
# Outline a Confluence ADF body: panels, headings, macros, expands, code blocks.
# Flags a macro inside an expand: the HTML converter duplicated a diagram.
#
# Usage:
#   bash adf-outline.sh <file>
#
# <file> is the ADF doc, or a saved page read that holds it, even as a JSON string.
#
# Exit: 0 clean, 1 flagged, 2 not ADF JSON.
set -uo pipefail

file=${1:-}

doc=$(jq -ce '
  def find:
    if type == "string" then fromjson? | find
    elif type == "object" and .type == "doc" then .
    elif type == "object" or type == "array" then .[] | find
    else empty end;
  first(find)
' "$file" 2> /dev/null) || {
  echo "not ADF JSON: $file" >&2
  exit 2
}

out=$(jq -r '
  def macro: .type | IN("extension", "bodiedExtension", "inlineExtension");
  def line:
    if .type == "panel" then "panel \(.attrs.panelType)"
    elif .type == "heading" then "h\(.attrs.level) \([.content[]?.text] | join(""))"
    elif macro then "macro \(.attrs.extensionKey | split("/") | last)"
    elif .type | IN("expand", "nestedExpand") then "expand \(.attrs.title)"
    elif .type == "codeBlock" then "code \(.attrs.language)"
    else empty end;
  def nodes($indent; $expand):
    ([line][0]) as $l
    | (if .type | IN("expand", "nestedExpand") then .attrs.title else $expand end) as $inner
    | if $l == null then .content[]? | nodes($indent; $inner)
      else
        {line: ($indent + $l)},
        (select($expand != null and macro) | {flag: "macro inside expand: \($expand)"}),
        (.content[]? | nodes($indent + "  "; $inner))
      end;
  [.content[]? | nodes(""; null)]
  | (.[] | .line // empty), (.[] | .flag // empty | "FLAG " + .)
' <<< "$doc")

[ -n "$out" ] && printf '%s\n' "$out"
if grep -q '^FLAG ' <<< "$out"; then
  exit 1
fi
