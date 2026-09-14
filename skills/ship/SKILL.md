---
name: ship
description: Commit and push changes with a pre-launch gate (validate-code + safe-repo) by default. `--fast` skips the gate.
argument-hint: '[--fast]'
disable-model-invocation: true
---

# Ship Changes

Ship runs a **pre-launch gate** before committing so nothing broken or unsafe leaves the working tree.

`--fast` skips the gate. Only for hotfixes, disposable branches (spike/prototype/CI), or when the gate already passed manually this session. Never on main/release. State the reason in the commit body and log "Pre-launch gate skipped via --fast".

## Workflow

### 1. Pre-launch gate (skipped with `--fast`)

1. Invoke the [validate-code](../validate-code/SKILL.md) skill. FAIL → report, stop.
2. Invoke the [safe-repo](../safe-repo/SKILL.md) skill in `--diff` mode (staged + unstaged only). Findings → report, stop.

### 2. Commit

Invoke the [commit](../commit/SKILL.md) skill — atomic commits by concern, repo style, staged by name.

### 3. Push

`git push` the current branch, then `git status` to verify. Rejected as non-fast-forward → `git pull --rebase`, retry once. **Never force push.**
