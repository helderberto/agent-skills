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
- code-review — correctness review before merge
- commit — conventional commit messages
- debug — disciplined debugging loop
```

Gemini reads `GEMINI.md` automatically at session start.

## Or with the skills CLI

```bash
npx skills add helderberto/agent-skills -a gemini-cli
```

## Verifying installation

Inside a Gemini session:

```
/skills list
```

You should see every skill from this repo plus any others you've installed. Gemini asks before activating a skill that matches your task.

## Updating

Re-run the install command.

## Tracer-bullet workflow

The workflow skills (`triage`, `grill`, `to-spec`, `to-tickets`, `build`, `review`, `to-pr`, `retro`) work the same way in Gemini as in Claude Code, only without the `/hb:` prefix:

```
You: invoke the grill skill on a dark mode feature
Gemini: [interviews you; settled terms go to the glossary]

You: now the to-spec skill for dark-mode
Gemini: [spec written to .specs/specs/dark-mode.md from the conversation]

You: now use the to-tickets skill on dark-mode
Gemini: [spec sliced into tickets in .specs/tickets/dark-mode.md]

You: build the next ticket of dark-mode
Gemini: [implements the ticket test-first, runs feedback loops]
```

## Limitations

- Gemini does not support slash commands like `/hb:to-spec`. Invoke by skill name in natural language.
- Auto-routing relies on the `description` field. Skills with vague descriptions may not trigger automatically — be explicit when in doubt.
