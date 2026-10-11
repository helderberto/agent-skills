# Using helderberto/agent-skills with Codex

This repo is a native Codex plugin. Codex reads `.agents/plugins/marketplace.json` and the shared `.claude-plugin/plugin.json`, so skills load straight from `skills/`.

## Setup

Requires Codex CLI 0.131 or later.

```bash
codex plugin marketplace add helderberto/agent-skills
codex plugin add hb@helderberto-skills
```

Start a new session afterwards. The plugin lands in `~/.codex/plugins/cache/helderberto-skills/hb/<version>/`. Check it with `codex plugin list`, or `/plugins` inside a session.

Alternative, skills only with manual updates: `npx skills add helderberto/agent-skills -a codex` copies them into `.agents/skills/` (`-g`: `~/.agents/skills/`). Pick one route: both gives every skill twice.

## Invoking skills

- Type `$` to mention a skill: `$hb:triage`, `$hb:to-spec dark-mode`. `/skills` opens a picker.
- Model-invocable skills also trigger from their `description` ("review this PR").
- Flow skills end with `Next: /hb:<cmd>`. In Codex, type `$hb:<cmd>` instead.
- npx installs have no prefix: `$triage`.

## Limitations

- Codex ignores `disable-model-invocation` and `user-invocable`. Flow skills can fire on their own, and model-only skills appear in the picker.
- `agents/` subagents are Claude Code only. Codex custom agents are TOML files in `.codex/agents/`.
- The Codex IDE extension doesn't support plugins. Use the npx route there.

## Updating

At startup, Codex refreshes Git marketplaces and reinstalls plugins that changed. To force a refresh:

```bash
codex plugin marketplace upgrade helderberto-skills
```

npx installs: `npx skills update`.
