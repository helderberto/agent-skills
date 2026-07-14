---
name: triage-review
effort: high
description: Fetch unresolved review comments on a GitHub PR (Copilot bot + human reviewers), verify each against the current code, and classify as Address / Skip / Optional / Discuss with a one-line rationale. Use when the user asks which review comments to address, to triage Copilot/reviewer feedback, sort signal from noise on a PR, or decide what makes sense to fix and what not. Don't use to reply to or resolve threads (out of scope — this is read-only), or to generate a fresh review (use /code-review or /validate-pr).
argument-hint: '[PR-number-or-branch]'
---

# Triage Review Comments

Consume the review comments **already on a PR** — Copilot and human reviewers — and sort them into what's worth fixing and what isn't. This is judgment, not a fresh review: each comment is verified against the current code before a verdict.

**Read-only.** Never reply to threads, resolve conversations, or post anything. The output is a decision aid for the user.

Distinct from siblings: `/code-review` and `/validate-pr` *generate* new findings; this skill *evaluates existing* reviewer comments.

## Workflow

1. **Fetch with `gh`** — pull the PR's review comments (default to the current branch's PR). Cover both inline thread comments and top-level review summaries, from Copilot and human reviewers. Keep only **unresolved** threads — resolution state lives in the GraphQL `reviewThreads` field (`isResolved`), not REST `pulls/comments`, so reach for `gh api graphql` when you need to filter out resolved/outdated noise. Capture author, `path`, `line`, and body for each. No unresolved comments → report that and stop.

2. **Verify each against current code** — read the file at `path:line` and confirm the comment still applies. Reviewers (especially bots) comment on stale diffs and miss surrounding context. An `outdated: true` thread defaults toward Skip unless the concern still holds in the current code. Completion: every comment has been checked against the actual code, not judged from its text alone.

3. **Classify** each comment using the rubric below. Every verdict carries a one-line rationale grounded in what you saw in step 2.

4. **Output the triage table** — grouped Address-first (see Output). Completion: every fetched comment appears in the table with a verdict and rationale.

5. **Offer to fix** — ask whether to implement the Address items. On yes, hand them to `/tdd` (test-first). Don't auto-implement; don't touch Skip/Optional/Discuss items.

## Rubric

| Verdict | When |
|---|---|
| **Address** | Verified against current code as a real bug, risk, correctness gap, or clearly valid improvement. |
| **Skip** | Wrong, false positive, outdated (code already changed), contradicts an established codebase convention, or outside this PR's scope. Rationale must cite the evidence, not just assert it. |
| **Optional** | Subjective/style/preference with no correctness impact — the user's call. |
| **Discuss** | Valid concern needing a decision you can't make alone (product tradeoff, breaking change, architectural direction). |

- **Verify before judging.** A comment's confidence is not evidence — Copilot produces confident false positives. Ground every verdict in the current code.
- Prefer a specific rationale over a category label: "Skip — `user` is already null-checked at line 40" beats "Skip — not applicable".

## Output

```
## Triage: PR #<n> — <title>  (<count> unresolved)

### Address (<n>)
- **`path:line`** · @author — <comment gist>
  → <rationale>

### Optional (<n>)
- ...

### Discuss (<n>)
- ...

### Skip (<n>)
- **`path:line`** · @author — <comment gist>
  → <why it doesn't apply, citing the code>
```

## Error handling

- `gh pr view` fails → run `gh auth status`; if not on a PR branch, ask for the PR number.
- A commented file was deleted or renamed in the PR → note it and lean toward Skip (the concern likely moved).
- Copilot comment references a line outside the diff → treat as low-signal; verify the surrounding code before trusting it.
