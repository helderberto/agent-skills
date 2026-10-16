---
name: setup
description: Configure this repo's issue tracker for the flow skills: GitHub, Jira, or local markdown (the default).
disable-model-invocation: true
---

# Setup

One-time, per repo. Records the tracker every flow skill follows. No config → specs and tickets are markdown under `.specs/`, the default. GitHub or Jira → they live only in that tracker, with no `.specs/specs/` or `.specs/tickets/` files.

## 1. Explore

- `git remote -v`: GitHub remote?
- `.specs/issue-tracker.md`: prior output of this skill?
- `git check-ignore -q .specs`: already ignored?

## 2. Ask one question

Which tracker? Lead with the recommendation: GitHub when the remote is on GitHub, else local.

- **GitHub** → `gh` CLI
- **Jira** → ask the project key; Atlassian MCP
- **Local** → markdown in `.specs/` only

## 3. Write

Never touch committed files: no `AGENTS.md`, `CLAUDE.md`, or `.gitignore` edits. The skills read the config directly.

**Local** → remove `.specs/issue-tracker.md` if present. Done.

**GitHub / Jira** → copy the seed ([issue-tracker-github.md](issue-tracker-github.md) or [issue-tracker-jira.md](issue-tracker-jira.md)) to `.specs/issue-tracker.md`, filling the placeholders.

`.specs/` not ignored → append `.specs/` to `.git/info/exclude`: ignored for this clone, never committed.

GitHub + `hitl` label missing → `gh label create hitl --force`.

## 4. Done

Print the tracker chosen and the files written. Switching later: rerun, or edit `.specs/issue-tracker.md`.

Next: `/hb:triage` or `/hb:grill <idea>`.
