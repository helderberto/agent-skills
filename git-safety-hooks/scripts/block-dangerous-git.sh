#!/bin/bash

# Git Safety Hook for Claude Code
# Blocks dangerous git commands before execution

# Read the tool call JSON from stdin
input=$(cat)

# Extract the command being called
command=$(echo "$input" | jq -r '.params.command // empty')

# List of dangerous git command patterns to block
dangerous_patterns=(
  "^git push"
  "^git reset --hard"
  "^git clean -f"
  "^git branch -D"
  "^git checkout \."
  "^git restore \."
)

# Check if command matches any dangerous pattern
for pattern in "${dangerous_patterns[@]}"; do
  if echo "$command" | grep -qE "$pattern"; then
    # Command is dangerous - block it
    cat <<EOF
{
  "block": true,
  "message": "Blocked dangerous git command: $command\n\nYou do not have authority to run this command. If you need to push changes, ask the user to run it manually."
}
EOF
    exit 0
  fi
done

# Command is safe - allow it
echo '{"block": false}'
exit 0
