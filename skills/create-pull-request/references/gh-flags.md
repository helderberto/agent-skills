# gh pr create — Useful Flags

| Flag | Description |
|------|-------------|
| `--draft` | Create as draft PR |
| `--base <branch>` | Target branch (default: repo default) |
| `--assignee <login>` | Assign to user (`@me` for self) |
| `--reviewer <login>` | Request review |
| `--label <name>` | Add label |
| `--milestone <name>` | Link to milestone |
| `--project <name>` | Add to project board |
| `--fill` | Auto-fill title/body from commits |
| `--web` | Open in browser after creation |

## Example

```bash
gh pr create \
  --title "Add user search" \
  --draft \
  --assignee @me \
  --reviewer teammate \
  --label "feature" \
  --body "$(cat <<'EOF'
## Summary
- ...

## Test Plan
- [ ] ...
EOF
)"
```
