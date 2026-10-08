---
name: retro
description: Run a retrospective on a coding session and suggest changes to the agent's environment, not the code.
disable-model-invocation: true
argument-hint: '[session-id or path]'
---

# Retro

Look back over a session and suggest changes to the agent's **environment** — navigation pointers, automated checks, coding standards, steering files, tooling — so the next run starts from a better place. Apply nothing until the user picks.

## Steps

1. **Read the session.** Default: this one, before `/clear`. An earlier session (`$ARGUMENTS`) lives at `~/.claude/projects/<cwd with / as ->/<session-id>.jsonl`. Redact secrets when you quote it.
2. **Read the environment first**: `CLAUDE.md` / `AGENTS.md` (repo and global), `CODING_STANDARDS.md`, the repo's own lint / typecheck / test commands, pre-commit hooks, CI workflows.
3. **Find candidates** in every category below. Completion: each category has a candidate or "nothing found".
4. **Present them most severe first**, each with its session evidence (what happened, where) and the proposed change. Apply only what the user picks. Before drafting steering text, call the Skill tool with `create-skill` for its Writing style: the no-op test, prompt the positive.

## Categories

- **Navigation** — the session took long to find a file or fact → a navigation pointer.
- **Automated checks** — a mistake a check could have caught, or no guardrail at all (no pre-commit hook, no CI job running lint / types / tests). A check that exists but sits unwired or silently broken is the finding, not a new one.
- **Coding standards** — the reviewer missed a mistake, or a rule needs removing or clarifying. Classify first. **Mechanical** (syntactic pattern, banned API, import shape, file location) → a deterministic check: lint rule, hook, or CI job, whichever the repo's guardrail makes cheapest. **Judgment call** → `CODING_STANDARDS.md`.
- **Global AGENTS.md** — steering in `CLAUDE.md` / `AGENTS.md` (repo or global) that belongs in a standard or a check.
- **Tool economy** — expensive or token-heavy calls a cheaper call or script would replace.
- **No-ops** — steering lines that don't change behavior.
- **Information access** — what the agent lacked: dev-server logs, read-only access to a third-party service.
- **Bug prevention** — after `/diagnose`: what would have prevented the bug? No good test seam, tangled callers, hidden coupling → the candidate is an `/architecture-audit` run with those specifics.

## Where things go

The implementer carries the most context pressure; the reviewer gets a diff and little else. So the reviewer enforces standards, not the implementer.

- `CLAUDE.md` / `AGENTS.md` — loaded into every session. Navigation pointers only.
- `CODING_STANDARDS.md` — read at review time by `/review`'s Standards reviewer. Past ~1,000 lines, split it into docs it points at.
- Docs — reference files other files point at. Extend an existing one before writing a new one.
- Skills — knowledge loaded on demand, or user-invoked commands.
