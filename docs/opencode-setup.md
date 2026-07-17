# Using helderberto/agent-skills with OpenCode

OpenCode supports custom commands but does not have a native plugin system or auto-routing like Claude Code. This repo achieves parity through three pieces:

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

1. The full intent → skill table (see [`AGENTS.md`](../AGENTS.md))
2. Lifecycle mapping (DEFINE → PLAN → BUILD → VERIFY → REVIEW → SHIP)
3. Core rules: if a task matches a skill, the agent MUST invoke it

This means you don't need to type `/hb:tdd` or `/hb:commit`. Just describe what you want — the agent picks the skill.

## Using skills in another project

Copy or symlink this repo's `skills/` and `AGENTS.md` into the target project:

```bash
# Option A: symlink (changes here propagate)
ln -s /path/to/agent-skills/skills ./skills
cp /path/to/agent-skills/AGENTS.md ./AGENTS.md

# Option B: copy (project owns its own version)
cp -r /path/to/agent-skills/skills ./skills
cp /path/to/agent-skills/AGENTS.md ./AGENTS.md
```

## Tracer-bullet workflow

For features beyond a few files, follow the DEFINE → PLAN → BUILD → VERIFY loop:

```
You: I want to add dark mode support.
OpenCode: [invokes spec skill, interviews, writes .specs/specs/dark-mode.md]

You: Plan it.
OpenCode: [invokes plan skill, writes phases into .specs/plans/dark-mode.md]

You: Build the next phase.
OpenCode: [invokes build skill, implements, runs feedback loops, marks checkboxes]

You: Verify.
OpenCode: [invokes test skill, validates plan against codebase]
```

## Customizing the agent persona

If you want to constrain OpenCode further — for example, enforce TDD on every change — extend `AGENTS.md` in your project root rather than editing this repo's copy:

```markdown
# Project AGENTS.md

@import /path/to/agent-skills/AGENTS.md

## Project-specific rules

- Always use the tdd skill, even for one-line fixes
- Never use the e2e skill — this project uses Playwright, not Cypress
```

## Limitations

- OpenCode does not surface a slash-command UI. All invocation is conversational.
- Auto-routing relies on the description fields and `AGENTS.md`. Edits to either change behavior immediately.
- Some Claude Code-specific features (plugins, marketplaces) have no OpenCode equivalent. Use the agent-driven model instead.
