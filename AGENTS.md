# AGENTS.md

Guidance for AI coding agents (Claude Code, Cursor, Gemini CLI, OpenCode, Copilot, etc.) when working with this repository.

## Repository Overview

`helderberto/agent-skills` is a personal SDLC toolbelt for AI coding agents. Skills are packaged Markdown instructions that extend agent capabilities across the full lifecycle — from spec to ship.

## Project Structure

```
skills/         → Core skills (one folder per skill, each with SKILL.md)
agents/         → Subagent definitions the skills fan out to (Claude Code only)
docs/           → Setup guides per agent (Cursor, Gemini CLI, OpenCode, Copilot)
.claude-plugin/ → Plugin manifest + marketplace entry (Claude Code)
plugin.json     → Plugin manifest (Antigravity CLI)
```

## Integration Model

Different agents discover skills through different mechanisms. This repo supports all of them through one source of truth — the `skills/` directory.

| Agent       | Discovery mechanism                                           |
| ----------- | ------------------------------------------------------------- |
| Claude Code | Plugin marketplace (`/plugin install hb@helderberto-skills`)  |
| Gemini CLI  | `gemini skills install` from this repo                        |
| OpenCode    | Auto-routes via this `AGENTS.md` + the `skill` tool           |
| Cursor      | Sync `skills/` into `.cursor/skills/` (native skills)            |
| Antigravity CLI | Native plugin via root `plugin.json` (`agy plugin install`)  |

See [docs/](./docs/) for per-agent setup instructions.

## OpenCode Integration

OpenCode uses a **skill-driven execution model** — the agent reads this file plus the `skills/` directory and auto-routes user intent to the right skill.

### Core Rules

- If a task matches a skill, you MUST invoke it
- Skills live at `skills/<skill-name>/SKILL.md`
- Never implement directly when a skill applies
- Always follow the skill instructions exactly — do not partially apply them
- Typed-only skills (`disable-model-invocation: true`) are rows that say *suggest*: name the command for the user to type, don't run it

### Intent → Skill Mapping

| User intent                             | Skill to invoke                                |
| --------------------------------------- | ---------------------------------------------- |
| New feature with unclear requirements   | suggest `/hb:triage` → `/hb:grill` → `/hb:to-spec` |
| Slice a spec or ticket into tickets     | suggest `/hb:to-tickets`                       |
| Implement the next ticket               | suggest `/hb:build`                            |
| Test-first development                  | `tdd`                                          |
| Implement using official docs           | `source-driven`                                |
| Research a question against sources     | `research`                                     |
| Bug, error, unexpected behavior         | `debug`                                        |
| Backfill tests / split functions / simplify | `refactor`                                 |
| Design or improve a module's interface  | `codebase-design`                              |
| Architectural friction in codebase      | suggest `/hb:architecture-audit`               |
| Prototype a design (logic demo or UI)   | `prototype`                                    |
| Explain code or codebase area           | `zoom-out`                                     |
| Build or refactor a UI component/page   | `frontend-ui-engineering`                      |
| Code at a trust boundary (auth, input, external API) | `harden`                          |
| Full pre-ship review (parallel reviewers) | suggest `/hb:review`                         |
| Validate a UI change in a real browser  | `visual-review --ui`                           |
| Learn a concept over multiple sessions  | suggest `/hb:teach`                            |
| Code review on a PR or pasted diff      | `code-review`                                  |
| Visual/HTML PR review (annotated diff)  | `visual-review`                                |
| Triage existing PR review comments (what to fix) | `feedback`                            |
| Check accessibility                     | `a11y-audit`                                   |
| Check i18n coverage                     | `i18n`                                         |
| Audit bundle size / performance         | `perf-audit`                                   |
| Audit dependencies for CVEs             | `deps-audit`                                   |
| Check for sensitive data in repo        | `safe-repo`                                    |
| Run linter / formatter                  | `check`                                        |
| Validate code (lint + types + tests)    | `check`                                        |
| Write end-to-end tests                  | `tdd`                                          |
| Commit changes (atomic, grouped by concern) | `commit`                                   |
| Push and create a pull request          | suggest `/hb:to-pr`                            |
| Record an architectural decision        | `to-adr`                                       |
| Pin down domain terminology / glossary  | `domain-modeling`                              |
| Stress-test a plan or design            | suggest `/hb:grill`                            |
| Fix prose / typos in markdown           | `revise`                                       |
| Restructure an article draft            | `revise`                                       |
| Hand off mid-session work to a fresh agent | suggest `/hb:handoff`                       |
| Retrospective on a session (improve the agent's environment) | suggest `/hb:retro`       |
| Last message didn't land — re-explain plainly | suggest `/hb:wait-what`                  |
| Author a new skill                      | `create-skill`                                 |
| Classify a task, or where am I?         | suggest `/hb:triage`                           |
| Which skill fits my situation?          | suggest `/hb:guide`                            |

### Lifecycle Mapping (Implicit Flow)

When the user has a non-trivial task, suggest the flow commands in order. They are typed-only, so the user runs each one:

- **TRIAGE** → `triage` classifies the input, sizes it, and names the entry command; with no args it reports the current phase
- **GRILL** → `grill` interviews; settled terms go to the glossary via `domain-modeling`, decisions to `to-adr`
- **SPEC** → `to-spec` writes the spec from the conversation, no interview
- **TICKETS** → `to-tickets` slices the spec into tracer-bullet tickets, with `architecture-audit` or `codebase-design` as needed
- **BUILD** → `build` (one ticket per invocation, or `--all`), driven by `tdd`, `source-driven`, and `check`
- **REVIEW** → `review` (audits as parallel reviewers plus agent lenses: spec conformance with ticket checkboxes, standards, test effectiveness with changed-line coverage, floor-guard), covering `a11y-audit`, `i18n`, `perf-audit`, `deps-audit`, `safe-repo`, `harden`; `feedback` sorts existing reviewer comments
- **SHIP** → `to-pr` (gate, push, PR, CI watch); `--safe` adds a `safe-repo` scan before the push
- **RETRO** → `retro`, in the same session before `/clear`

## Conventions

- Every skill lives in `skills/<name>/SKILL.md` (or `<name>/SKILL.md` if flat at root — see structure section)
- YAML frontmatter requires `name` and `description`
- Agents in `agents/` are named `*-auditor`: read-only reviewers that preload, through `skills:` frontmatter, the skill holding their checklist when one exists
- Description starts with what the skill does. Model-visible skills follow with trigger conditions ("Use when..."); typed-only skills stop at one sentence
- Optional `effort` frontmatter (`low`/`medium`/`high`/`xhigh`/`max`) overrides reasoning effort for the turn the skill fires — set it only when the task deviates from the `medium` default
- No Claude Code hooks: they would block the user's own sessions. Safety checks run when the user asks (`/hb:safe-repo`, `/hb:to-pr --safe`)
- Supporting files split into subfolders: `references/` (long-form docs loaded on demand), `scripts/` (deterministic helpers), `assets/` (templates/icons used in output). Split when `SKILL.md` exceeds ~150 lines
- Keep `name` and `description` identical in every plugin manifest (`.claude-plugin/plugin.json`, `plugin.json`)
- Bump `.claude-plugin/plugin.json` `version` (semver) once per PR that changes a skill users see, so plugin consumers can track updates
- After the PR merges: annotated tag `vX.Y.Z` on the merge commit, summarizing changes since the previous tag; `git push origin vX.Y.Z`; then `gh release create vX.Y.Z` with notes shaped like the previous release (`gh release view`)

## Boundaries

This is a documentation-only project. It contains no application code, no runtime dependencies, no build step. Skills are pure Markdown.
