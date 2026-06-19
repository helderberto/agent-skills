---
name: create-pull-request
description: Create a GitHub pull request — fills the repo's PR template, conventional-commit title, ticket refs. Draft mode via `--draft`.
disable-model-invocation: true
---

# Create Pull Request

Mode: $ARGUMENTS

If `--draft` is passed, create as draft PR.

## Workflow

1. Run in parallel:
   - `git fetch origin && git remote show origin | grep 'HEAD branch' | cut -d' ' -f5` (get base branch)
   - `git rev-parse --abbrev-ref HEAD | grep -oE '[A-Z]+-[0-9]+'` (extract ticket ID)
   - Search for PR template in order: `.github/pull_request_template.md`, `.github/PULL_REQUEST_TEMPLATE.md`, `.github/PULL_REQUEST_TEMPLATE/` (directory of templates), `docs/pull_request_template.md`, `pull_request_template.md`
2. Run in parallel:
   - `git diff HEAD`
   - `git diff [base-branch]...HEAD --unified=0`
3. If a PR template was found, read it in full — it becomes the canonical structure for the PR body. Do not paraphrase or skip sections.
4. Review ALL commits (not just latest)
5. Ask the user (use AskUserQuestion when available; otherwise ask directly). Ask all at once where possible:
   - **Effort** (required): how long the task took in hours (planning, reading, testing, all included)
   - **Changes** (required): general overview of what was done
   - **Testing** (optional): testing done that isn't visible in the diff
   - **Tricky parts** (optional): anything hard, requiring multiple attempts, or non-obvious
   - If template found, also surface any template-specific fields that can't be inferred from the diff (e.g. "Does this include breaking changes?", "What type of change is this?")
6. Draft title and body:
   - Title must match: `/^(build|chore|ci|docs|feat|fix|perf|refactor|revert|style|test)(\(.*\))?: .+$/`
   - **If template found**: use the template verbatim as the body base — fill every section/placeholder using diff + user answers; check applicable checkboxes; do NOT add sections not in the template; do NOT omit any template sections
   - **If no template**: use Summary + Test plan
   - Reference ticket ID in body if found (e.g. `Resolves TICKET-123`)
   - Incorporate user's answers into description — don't just repeat the diff
7. In parallel:
   - Create branch if needed
   - Push with `-u` if needed
   - Create PR with `gh pr create` using HEREDOC (add `--draft` if requested)

## Rules

- If a PR template exists, the body MUST be the filled template — not a summary that references it
- Return PR URL when done
- Use `gh` CLI only
- NEVER force push to main/master
- NEVER push without user confirmation if already on main/master
- NEVER create PR with uncommitted changes — commit first
