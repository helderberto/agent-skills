---
name: context-engineer
description: Optimize what loads into the agent's context — what to include, what to drop, how to recover when output quality degrades. Use when starting a new session on a complex task, when agent output starts inventing APIs or diverging from conventions, when switching between tasks, or when context is approaching the window limit. Don't use for trivial single-file tasks where context is obvious.
---

# Context Engineer

Context is the agent's working memory. Bad context produces hallucinated APIs, ignored conventions, and repeated mistakes. Good context produces tight, conventional, on-target output. This skill is the discipline of deciding what loads, in what order, and what to drop when quality degrades.

This skill mirrors `~/.claude/rules/context-engineering.md`. Keep both in sync when updating.

## Hierarchy (load in this order)

1. **Rules** — persistent, project-wide conventions (always loaded: AGENTS.md, CLAUDE.md, `~/.claude/rules/`)
2. **Specs / PRDs** — per-feature requirements and constraints (the `.specs/<slug>.md` for the current task)
3. **Relevant source** — files directly related to the task (not "all files in the module")
4. **Error output** — current failures and stack traces (the exact ones, not paraphrased)
5. **Conversation history** — managed by compaction; oldest goes first when truncating

The order matters. Rules anchor everything. Specs scope. Source grounds. Errors guide. History contextualizes.

## Principles

- **Quality over quantity**: focused context (<2000 lines) outperforms comprehensive dumps. The agent reads what's loaded; it doesn't skim.
- **Just-in-time loading**: pull a file when its content matters, not "just in case". Reference by path until needed.
- **Drop completed work**: once a sub-task is done, summarize it and let the intermediate steps fall out of context.
- **Path beats paste**: reference `src/auth/session.ts:42` instead of pasting the function. The agent can re-read on demand.

## Session start protocol

Before non-trivial work:

1. State the goal in one sentence
2. Load the rules layer: AGENTS.md / CLAUDE.md + relevant `~/.claude/rules/*.md`
3. Load the spec / PRD if one exists for this task
4. Identify ~3-7 files most relevant to the task; load by reference, not full content
5. State assumptions; ask the user to correct any wrong assumption before proceeding

If you can't fit the above in <30% of the context window, the task is too big — break it into smaller conversations.

## Red flags — context is failing

Watch for these signals. They are silent until you look:

- Agent invents APIs, function names, or flags that don't exist
- Output diverges from documented conventions even though the rule is loaded
- Quality degrades as conversation lengthens (later answers worse than earlier)
- Agent asks questions already answered in loaded context
- Same mistake repeats after correction
- Agent confabulates citations to lines or files that don't exist

When you see any of these, stop and recover.

## Recovery

In order of cost:

1. **Re-state the rule / fact** explicitly in the current turn — cheapest, often enough
2. **`/clear`** between unrelated tasks — frees context, re-loads rules at next message
3. **Re-load rules and the most relevant 2-3 files** explicitly after compaction
4. **Break large tasks into smaller conversations** — each conversation focused, rules re-loaded
5. **When quality drops mid-conversation**: stop, summarize current state into a note, start a fresh session pointed at the note

Do not push through degraded context. The cost of one fresh session is less than the cost of one wrong commit caused by drift.

## Task switching

When pivoting from task A to task B:

- If the tasks share rules and source files → keep the session, state the pivot
- If the tasks are independent → `/clear` and start fresh; the new task pays a tiny cold-start cost in exchange for clean context
- Default to `/clear` when in doubt — fresh context is almost free; degraded context is expensive

Sign you switched too aggressively: agent answers task B with patterns from task A.

## What NOT to preload

- Entire directories ("just so you have the codebase")
- Generated code (lock files, dist/, build artifacts)
- Documentation pages "in case they come up"
- Test files when fixing production code (load only the test for the case being fixed)
- Historical commits beyond what's needed to understand the current state

Preloading "just in case" reads token budget you'll need later.

## Rules

- Load rules first, then specs, then source, then errors
- Keep total loaded context <2000 lines when possible; always <30% of window
- Reference by path until the content is actually needed
- Watch for red flags every ~10 turns in long sessions
- Recover via `/clear` early, not late
- Never paste large files when you can reference them

## Red flags (meta — when this skill is misapplied)

- Loading this skill itself into context for trivial tasks (it's overhead)
- Following the session-start protocol for one-line fixes (ceremony over speed)
- Re-loading rules every turn (rules are sticky once loaded; only re-load after `/clear` or compaction)

## Verification

When applied to a non-trivial task:

- [ ] Goal stated in one sentence before loading anything
- [ ] Rules layer loaded explicitly
- [ ] Spec / PRD loaded if it exists
- [ ] Relevant source identified by path; only loaded when needed
- [ ] Assumptions stated; user confirmed or corrected before implementing
- [ ] If output quality degrades mid-session: recover, do not push through
