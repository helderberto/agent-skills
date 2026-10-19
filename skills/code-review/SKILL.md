---
name: code-review
effort: high
description: Review a PR, or the current branch, on two axes in parallel subagents, quality and spec, reported side by side.
disable-model-invocation: true
argument-hint: '[PR-number-or-URL]'
---

# Code Review

Two axes, each in its own subagent so neither pollutes the other's context:

- **Quality**: correctness, readability, architecture, security, performance, the repo's documented standards, and a smell baseline
- **Spec**: does the diff do what its issue, spec, or PR description asked?

A change can pass one and fail the other, so the axes are never merged or re-ranked. For the full panel (audits, test effectiveness, quality bar), use `/hb:review`.

## 1. Resolve the diff

`$ARGUMENTS` has a PR number or URL → `gh pr view <PR> --json number,title,body,baseRefName,headRefName,commits` and `gh pr diff <PR>`. None → the current branch's PR (`gh pr view`). No PR → `git diff <base>...HEAD` and `git log <base>..HEAD --oneline`, base from `git merge-base HEAD main` (fall back `master`).

Bad ref or empty diff → stop here, not inside two subagents. PR head ≠ the checked-out branch → tell the subagents files on disk aren't the PR's; read context with `gh api repos/{owner}/{repo}/contents/<path>?ref=<head>`. State the scope: "Reviewing PR #42 (`feat/x` → `main`): 6 files, 224 insertions." ~1000+ changed lines → suggest a split per [axes.md](references/axes.md), then review anyway.

## 2. Find the spec

In order: issue refs in the PR body or commits (`#123`, `Closes #45`, Jira keys), fetched the tracker's way (`.specs/issue-tracker.md`, else [the local default](references/issue-tracker-local.md)); a spec in the tracker matching the branch slug; the PR description. Nothing → skip the Spec subagent and say so.

## 3. Find the standards

Every file that documents how code should be written. `CODING_STANDARDS.md`, `CONTRIBUTING.md`, `AGENTS.md`, and `CLAUDE.md` must be on the list when present.

## 4. Fan out

Spawn both `general-purpose` subagents in **one message**. Each gets the repo path, the diff and log commands, and a read-only rule: no edits, staging, commits, or pushes. Brief with the artifact, never your own conclusion.

**Quality** also gets the standards files and the absolute paths of [axes.md](references/axes.md) and [smells.md](references/smells.md) under `${CLAUDE_SKILL_DIR}/references/`. Brief: "Review the diff along every axis in axes.md. Report (a) every documented-standard violation, citing file and rule; (b) baseline smells as judgement calls, quoting the hunk. A documented standard overrides the baseline; skip what tooling enforces. Each finding: `file:line`, severity (Critical / Important / Suggestion / Nit), one-line rationale, the structural remedy, and a fix for every Critical. Then list what you ran versus only read. Under 500 words."

**Spec** also gets the spec contents or path. Brief, verbatim: "Report: (a) requirements the spec asked for that are missing or partial; (b) behaviour in the diff that wasn't asked for (scope creep); (c) requirements that look implemented but where the implementation looks wrong. Quote the spec line for each finding. Under 400 words."

## 5. Report

```
## Code Review
**Scope**: <PR or branch, files/lines> · **Spec source**: <issue / spec / PR description / none>

## Quality
### Critical · Important · Suggestion · Nit
### Verified — what ran, what was only read

## Spec
### Missing · Scope creep · Looks wrong

**Summary**: Quality <n> findings, worst: <one line> · Spec <n> findings, worst: <one line>
**Verdict**: APPROVE / REQUEST CHANGES, against the approval standard in axes.md
```

Relay each subagent's findings verbatim or lightly cleaned. A subagent that errors is noted as skipped. One structural problem and ten nits: the structural problem _is_ the review, so lead with it. Name the worst finding per axis, never one winner across both.
