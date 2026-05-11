# Using helderberto/agent-skills with Gemini CLI

Gemini CLI supports native skill installation via `gemini skills install`. Skills are auto-discovered and routed based on their `description` field.

## Install from this repository

```bash
gemini skills install https://github.com/helderberto/agent-skills.git --path skills
```

This pulls every skill in the `skills/` directory and registers them with Gemini.

## Install from a local clone

```bash
git clone https://github.com/helderberto/agent-skills.git
gemini skills install ./agent-skills/skills/
```

## Install a single skill

```bash
gemini skills install https://github.com/helderberto/agent-skills.git --path skills/tdd
```

## Persistent context via `GEMINI.md`

For project-specific defaults, add the skills you always want loaded into `GEMINI.md` in your project root:

```markdown
# Project Conventions

Always apply these skills when relevant:

- tdd — red-green-refactor for any new feature or bug
- code-review — five-axis review before merge
- commit — conventional commit messages
- diagnose — disciplined debugging loop
```

Gemini reads `GEMINI.md` automatically at session start.

## Verifying installation

```bash
gemini skills list
```

You should see all 35 skills from this repo plus any others you've installed.

## Updating

```bash
gemini skills update
```

Or for a single skill:

```bash
gemini skills update <skill-name>
```

## Tracer-bullet workflow

The five workflow skills (`prd`, `plan`, `build`, `check`, `brief`) work the same way in Gemini as in Claude Code, only without the `/hb:` prefix:

```
You: invoke the prd skill to define a dark mode feature
Gemini: [interview → spec written to .tracerkit/prds/dark-mode.md]

You: now use the plan skill on dark-mode
Gemini: [PRD parsed into phases]

You: build the next phase of dark-mode
Gemini: [implements phase, runs feedback loops]
```

## Limitations

- Gemini does not support slash commands like `/hb:prd`. Invoke by skill name in natural language.
- Auto-routing relies on the `description` field. Skills with vague descriptions may not trigger automatically — be explicit when in doubt.
