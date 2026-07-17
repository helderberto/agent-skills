---
name: brief
description: Session briefing — shows active features, progress, and suggested focus. Use at the start of a session, when asking what to work on, or when checking active features.
---

# Session Briefing

Overview of active features, progress, and suggested focus.

## Algorithm

### 1. Discover plans

Glob `.specs/plans/*.md`. Slug = filename without `.md`. If no plans found, output: `No plans found — run /spec to start one.`

### 2. Count progress

For each plan, count `- [x]` and `- [ ]` lines under each `## Phase N` heading. Per-phase: `checked/total`. Sum across phases → total progress. First phase with unchecked items → cursor.

Skip plans where all items are checked (fully complete).

### 3. Show progress

For each incomplete plan:

```
<slug> (checked/total)
  Phase 1 — title: checked/total
> Phase 2 — title: checked/total
  Phase 3 — title: checked/total
```

The `>` marks the first incomplete phase (cursor). Completed phases show without `>`.

### 4. Suggest focus

If exactly one incomplete plan → auto-select it.
If multiple incomplete plans → select the one closest to completion.

```
**Focus → <slug>**
```

### 5. Offer next steps

Present options and wait for the user's choice:

1. Continue focused feature — `/build <slug>` (Recommended)
2. Start new feature — `/spec`
3. Check progress — `/test <slug>`
