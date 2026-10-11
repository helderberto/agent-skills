# Using helderberto/agent-skills with Antigravity CLI

Antigravity CLI (`agy`) installs this repo as a native plugin. The root `plugin.json` marks it, and `skills/` and `agents/` load from it.

## Setup

```bash
agy plugin install https://github.com/helderberto/agent-skills
```

From a local clone:

```bash
git clone https://github.com/helderberto/agent-skills.git
agy plugin install ./agent-skills
```

The plugin is global. `agy plugin list` shows it; recent releases stage it in `~/.gemini/config/plugins/`.

Or with the skills CLI, skills only, without the `hb:` prefix:

```bash
npx skills add helderberto/agent-skills -a antigravity-cli
```

It writes to `.agents/skills/` in the project, or to `~/.gemini/antigravity-cli/skills/` with `-g`.

## Invoking skills

- Skills activate when a task matches their `description`, or when you name one: "use the tdd skill".
- `/hb:<skill>` runs one directly, e.g. `/hb:triage`. `/skills` lists what loaded.

## Limitations

- No `disable-model-invocation`: the agent may start a flow skill unasked. `user-invocable: false` skills still show in the `/` menu.
- `agents/` subagents load but list Claude Code tool names (`Read`, `Bash`). Antigravity warns unmapped tool names can hang a subagent; press `k` on it in `/agents` to cancel.
- Antigravity documents no `$ARGUMENTS` or `${CLAUDE_SKILL_DIR}`. Pass arguments in plain words; `safe-repo` and `review` keep their scripts in `skills/<name>/scripts/`.
- With the skills CLI, `/feedback` collides with the built-in feedback panel.

## Updating

```bash
agy plugin install https://github.com/helderberto/agent-skills
```

Reinstalling replaces the plugin folder; if it refuses, run `agy plugin uninstall hb` first. `agy update` updates only the CLI. Skills CLI installs: `npx skills update`.
