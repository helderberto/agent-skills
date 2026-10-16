---
name: setup
description: Configure this repo's issue tracker for the flow skills: GitHub, Jira, or local markdown (the default).
disable-model-invocation: true
---

# Setup

One-time, per repo. Records where `to-spec` and `to-tickets` publish. No config → local markdown under `.specs/` only, which is the default.

## 1. Explore

- `git remote -v`: GitHub remote?
- `CLAUDE.md` / `AGENTS.md` at the root: an `## Agent skills` block already?
- `.specs/issue-tracker.md`: prior output of this skill?

## 2. Ask one question

Which tracker? Lead with the recommendation: GitHub when the remote is on GitHub, else local.

- **GitHub** → `gh` CLI
- **Jira** → ask the project key; `acli` CLI, else the Atlassian MCP
- **Local** → markdown in `.specs/` only

## 3. Write

**Local** → remove `.specs/issue-tracker.md` and the `### Issue tracker` sub-block if present. Done.

**GitHub / Jira** → copy the seed ([issue-tracker-github.md](issue-tracker-github.md) or [issue-tracker-jira.md](issue-tracker-jira.md)) to `.specs/issue-tracker.md`, filling the placeholders. Then add to `CLAUDE.md` if it exists, else `AGENTS.md` (create it if neither exists):

```markdown
## Agent skills

### Issue tracker

<GitHub issues | Jira project KEY>. See `.specs/issue-tracker.md`.
```

Block exists → update it in place. Never touch the surrounding sections.

GitHub + `hitl` label missing → `gh label create hitl --force`.

## 4. Done

Print the tracker chosen and the files written. Switching later: rerun, or edit `.specs/issue-tracker.md`.

Next: `/hb:triage` or `/hb:grill <idea>`.
