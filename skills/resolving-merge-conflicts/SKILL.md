---
name: resolving-merge-conflicts
effort: high
description: Resolve an in-progress git merge or rebase conflict by recovering each side's intent, then finishing the merge. Use when a merge or rebase is mid-conflict, git reports conflicted files, or the user asks to resolve conflicts. Don't use for preventing future conflicts, general git operations, or rewriting history where nothing is conflicted.
---

# Resolving Merge Conflicts

A conflict is two **intents** colliding. Resolve it by recovering both intents, not by guessing at the diff markers.

## Process

### 1. See the state

`git status` and read the conflicting files. Establish: merge or rebase, which branches, and the **stated goal** of the operation (what is being merged into what, and why). The goal decides every incompatible hunk later.

Completion: you can name the goal and list every conflicted file.

### 2. Recover intent from primary sources

For each conflict, understand *why* each side changed the code — read the commit messages, the PRs, the issues behind both branches. The diff shows *what* changed; the primary sources show *why*. Never resolve a hunk whose intent you can't state.

### 3. Resolve each hunk

- Preserve **both** intents where they compose.
- Where they genuinely conflict, keep the side matching the merge's stated goal and note the trade-off.
- Never invent new behavior to bridge them — resolution reconciles what exists, it doesn't add.
- Always resolve; never `--abort`.

Completion: no conflict markers remain, and every kept hunk traces to a stated intent.

### 4. Run the project's checks

Discover the project's automated checks and run them in order — typically typecheck → tests → format. Fix anything the merge broke, not adjacent code.

### 5. Finish the merge

Stage the resolved files explicitly by name (never `git add -A`), then complete the merge or continue the rebase until every commit is replayed. Stop there — don't push unless asked.
