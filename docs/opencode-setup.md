# Using helderberto/agent-skills with OpenCode

OpenCode discovers skills natively and runs them through its built-in `skill` tool. This repo makes the routing explicit with three pieces:

- A strong system prompt (`AGENTS.md` at repo root)
- OpenCode's built-in `skill` tool
- Consistent skill discovery from the `skills/` directory

The result is an **agent-driven workflow** where skills are selected automatically based on user intent — no manual command invocation required.

## Setup

### 1. Clone the repo

```bash
git clone https://github.com/helderberto/agent-skills.git
```

### 2. Open the project in OpenCode

OpenCode reads two locations:

- `AGENTS.md` at the workspace root — the system prompt that defines the intent → skill mapping
- `skills/<name>/SKILL.md` — the actual skill instructions

Both are present in this repo. The `.opencode/skills` symlink also exposes the directory at the path OpenCode expects.

### 3. Verify

Open a session and ask: "what skill should I use to write tests for a new feature?"

The agent should respond by invoking `tdd` from `skills/tdd/SKILL.md`.

## How auto-routing works

OpenCode reads `AGENTS.md` at the start of every session. That file contains:

1. The full intent → skill table (see [the AGENTS.md section](#agentsmd-section))
2. Lifecycle mapping (TRIAGE → GRILL → SPEC → TICKETS → BUILD → REVIEW → SHIP → RETRO)
3. Core rules: if a task matches a skill, the agent MUST invoke it; typed-only flow skills are suggested, and run only when you ask for them

This means you don't need to name skills like `tdd` or `commit`. Just describe what you want — the agent picks the skill.

## Using skills in another project

Put the skill folders where OpenCode scans: `.opencode/skills/` for one project, `~/.config/opencode/skills/` for all.

```bash
# Option A: symlink (changes here propagate)
mkdir -p .opencode && ln -s /path/to/agent-skills/skills .opencode/skills

# Option B: copy (project owns its own version)
mkdir -p .opencode/skills && cp -R /path/to/agent-skills/skills/* .opencode/skills/

# Option C: skills CLI (installs to .agents/skills/)
npx skills add helderberto/agent-skills -a opencode
```

Paste [the AGENTS.md section](#agentsmd-section) into your project's `AGENTS.md`.

## Tracer-bullet workflow

For features beyond a few files, follow the GRILL → SPEC → TICKETS → BUILD → REVIEW loop. Flow skills run only when you ask for them by name:

```
You: I want to add dark mode support.
OpenCode: [suggests triage, then grill; runs neither on its own]

You: Run grill on dark mode.
OpenCode: [interviews you, writes settled terms to the glossary]

You: Run to-spec for dark-mode.
OpenCode: [writes .specs/specs/dark-mode.md from the conversation]

You: Run to-tickets on dark-mode.
OpenCode: [writes tickets into .specs/tickets/dark-mode.md]

You: Build the next ticket.
OpenCode: [runs the build skill, implements, runs feedback loops, marks checkboxes]

You: Review it.
OpenCode: [runs the review skill, checks the diff and ticket checkboxes]
```

## Customizing the agent persona

If you want to constrain OpenCode further — for example, enforce TDD on every change — extend `AGENTS.md` in your project root rather than editing this repo's copy:

```markdown
# Project AGENTS.md

<!-- the AGENTS.md section from docs/opencode-setup.md -->

## Project-specific rules

- Always use the tdd skill, even for one-line fixes
- Never use visual-review's UI mode — this project has no UI
```

## AGENTS.md section

Paste this into your project's `AGENTS.md`:

````markdown
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
| Configure the repo's issue tracker      | suggest `/hb:setup`                            |
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
| Review a PR or branch (quality + spec)  | suggest `/hb:code-review`                      |
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
| Split a large PR into small stacked PRs | suggest `/hb:to-stack`                         |
| Release a library (version, changelog, tag, GH release) | suggest `/hb:to-release`        |
| Record an architectural decision        | `to-adr`                                       |
| Pin down domain terminology / glossary  | `domain-modeling`                              |
| Stress-test a plan or design            | suggest `/hb:grill`                            |
| Is a risky change or PR worth it?       | suggest `/hb:debate`                           |
| Fix typos / polish existing text        | `revise`                                       |
| Restructure or tighten existing text    | `revise`                                       |
| Write an article from a blank page      | suggest `/hb:draft`                            |
| Write a doc, one-pager or ADR (Confluence, GitHub issue, Markdown) | suggest `/hb:to-doc`     |
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
- **SHIP** → `to-pr` (gate, push, PR, CI watch); `--safe` adds a `safe-repo` scan before the push. Libraries then run `to-release`: draft release on the PR, tag and publish after the merge
- **RETRO** → `retro`, in the same session before `/clear`
````

## Limitations

- OpenCode does not surface a slash-command UI. All invocation is conversational.
- Auto-routing relies on the description fields and `AGENTS.md`. Edits to either change behavior immediately.
- Some Claude Code-specific features (plugins, marketplaces) have no OpenCode equivalent. Use the agent-driven model instead.
