# Using helderberto/agent-skills with Cursor

Cursor reads skills natively: each `.cursor/skills/<name>/SKILL.md` is loaded when a task matches its `description`. Rules (`.cursor/rules/*.mdc`) are for short always-on policies; don't paste whole skills into them.

## Setup

### Project skills (recommended)

```bash
git clone https://github.com/helderberto/agent-skills.git /path/to/agent-skills
mkdir -p .cursor/skills
rsync -a /path/to/agent-skills/skills/ .cursor/skills/
```

Only a few? Copy their folders whole, so `references/` comes along:

```bash
cp -R /path/to/agent-skills/skills/{tdd,code-review,commit} .cursor/skills/
```

### User skills

For every workspace, sync into `~/.cursor/skills/` instead. Project skills win for that project.

## Recommended starter set

| Skill                | Why it helps in Cursor                                  |
| -------------------- | ------------------------------------------------------- |
| `tdd`                | Forces red-green-refactor for new features and bugs     |
| `code-review`        | Correctness lens on a diff: bugs, security, performance |
| `commit`             | Atomic commits in the repository's message style        |
| `debug`              | Disciplined debugging loop for hard bugs                |
| `source-driven`      | Forces use of official docs over training data          |
| `architecture-audit` | Surfaces friction toward deep modules                   |

For the tracer-bullet flow, add `to-spec`, `to-tickets`, and `build`. Prompts like "slice the dark mode spec into tickets" or "build the next ticket" then route to them.

## Limitations

- No `/hb:` commands. Ask for a skill by name: "use the to-spec skill for dark-mode".
- `agents/` subagents are Claude Code only.

## Updating

```bash
git -C /path/to/agent-skills pull
rsync -a /path/to/agent-skills/skills/ .cursor/skills/
```
