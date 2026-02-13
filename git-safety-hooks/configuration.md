# Git Safety Hooks Configuration

## Project-Level Installation

Add to `.claude/settings.json`:

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "\"$CLAUDE_PROJECT_DIR\"/.claude/hooks/block-dangerous-git.sh"
          }
        ]
      }
    ]
  }
}
```

Hook file location: `.claude/hooks/block-dangerous-git.sh`

## Global Installation

Add to `~/.claude/settings.json`:

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "~/.claude/hooks/block-dangerous-git.sh"
          }
        ]
      }
    ]
  }
}
```

Hook file location: `~/.claude/hooks/block-dangerous-git.sh`

## Merging with Existing Hooks

If you already have PreToolUse hooks, merge them:

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "existing-hook.sh"
          },
          {
            "type": "command",
            "command": "\"$CLAUDE_PROJECT_DIR\"/.claude/hooks/block-dangerous-git.sh"
          }
        ]
      }
    ]
  }
}
```

## Customizing Blocked Commands

Edit `block-dangerous-git.sh` to modify the `dangerous_patterns` array:

```bash
dangerous_patterns=(
  "^git push"
  "^git reset --hard"
  "^git clean -f"
  "^git branch -D"
  "^git checkout \."
  "^git restore \."
  # Add custom patterns here
  "^git rebase -i"
  "^git filter-branch"
)
```

## Testing

After installation, restart Claude Code and try:

```bash
claude "run git push"
```

Should see: "Blocked dangerous git command: git push"

## Troubleshooting

**Hook not running:**
- Check file permissions: `ls -l <hook-path>` (should be executable)
- Verify JSON syntax in settings.json
- Check hook path is correct in settings

**Commands still running:**
- Verify pattern matches in hook script
- Test pattern: `echo "git push" | grep -E "^git push"`
- Check hook returns proper JSON format
