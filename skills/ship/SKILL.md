---
name: ship
description: Commit and push changes with a pre-launch gate (validate-code + safe-repo) by default. `--fast` skips the gate.
argument-hint: '[--fast]'
disable-model-invocation: true
---

# Ship Changes

Ship runs a **pre-launch gate** before committing. By default: `validate-code` + `safe-repo`. The gate ensures nothing broken or unsafe leaves the working tree.

## Arguments

- `--fast` — skip the pre-launch gate. Only for hotfixes, disposable branches (spike/prototype/CI), or when the gate already passed manually this session. Never on main/release. State the reason in the commit body.

## Workflow

### Phase 1 — Pre-launch gate (skipped if `--fast`)

1. **Validate code**: invoke the [validate-code](../validate-code/SKILL.md) skill. Auto-fixes formatting, verifies types, runs tests.
   - If `validate-code` returns FAIL → report errors, STOP. Do not commit or push.
2. **Sensitive data scan**: invoke the [safe-repo](../safe-repo/SKILL.md) skill against the staged + unstaged diff only (not the whole repo).
   - If sensitive data found → report findings, STOP. Do not commit or push.

### Phase 2 — Commit

3. Review all changes from status and diff
4. Analyze recent commit style from log
5. Group changed files by logical concern using [commit grouping rules](../commit/SKILL.md#grouping-rules)
6. For each group: stage specific files by name, commit with HEREDOC format
7. If all changes form one logical unit, stage files by name (never `git add -A` or `git add .`)

### Phase 3 — Push

8. Push: `git push` (current branch)
9. Run `git status` after to verify

## Rules

- Pre-launch gate runs by default; only skip via `--fast` with a stated reason; never `--fast` on main/release branches
- Group changes into atomic commits when they serve distinct purposes
- NEVER force push (`-f` or `--force`)

## Error Handling

- If `git push` is rejected (non-fast-forward) → run `git pull --rebase` then retry push once
- If pre-commit hook fails → fix reported issues, re-stage, create a NEW commit (never `--amend`)
- If `--fast` is used → log "Pre-launch gate skipped via --fast" in agent output for traceability
