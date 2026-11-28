# AGENTS.md

Guidance for AI coding agents working on this repository.

## Repository Overview

`helderberto/agent-skills` is a personal SDLC toolbelt for AI coding agents, from spec to ship. One `skills/` directory serves every supported agent; per-agent setup lives in [docs/](./docs/).

## Project Structure

```
skills/          → Core skills (one folder per skill, each with SKILL.md)
agents/          → Subagent definitions the skills fan out to (Claude Code only)
docs/            → Per-agent setup guides, skill conventions, workflow walkthrough
scripts/         → CI checks and their tests
.claude-plugin/  → Plugin manifest + marketplace entry (Claude Code)
plugin.json      → Plugin manifest (Antigravity CLI)
.agents/plugins/ → Marketplace entry (Codex)
.plugin/         → Copy of .claude-plugin/plugin.json (Copilot CLI reads it first)
```

## Conventions

- Prose a person reads at length (skills you author or restructure, docs, README, PR bodies) → invoke the `revise` skill before committing. Short edits and changelog entries skip it
- Author or restructure a skill with the `create-skill` skill
- Agents in `agents/` are named `*-auditor`: read-only reviewers that preload, through `skills:` frontmatter, the skill holding their checklist when one exists
- No Claude Code hooks: they would block the user's own sessions. Safety checks run when the user asks (`/hb:safe-repo`, `/hb:to-pr --safe`)
- After editing `.claude-plugin/plugin.json`, copy it to `.plugin/plugin.json`. The root `plugin.json` keeps only `name` and `description`, matching it
- A PR that changes `skills/` bumps the `version` and adds its `CHANGELOG.md` entry. CI checks the level its commits imply; levels in [CONTRIBUTING.md](./CONTRIBUTING.md#versioning)
- Release: `/hb:to-release <PR>` before the merge writes the entry and drafts the title. On merge, `.github/workflows/release.yml` tags and publishes
- The installed `hb` plugin can lag this repo. After a release: `claude plugin marketplace update helderberto-skills && claude plugin update hb@helderberto-skills`
- `bash scripts/check.sh` runs every CI check locally; `bash scripts/audits.sh` lists each skill's skills.sh audit status
- Untrusted text and verifying a skill's commands: [docs/skill-conventions.md](./docs/skill-conventions.md)

## Boundaries

Skills are Markdown plus bash helper scripts. No runtime dependencies, no build step.
