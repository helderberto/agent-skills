# Using helderberto/agent-skills with GitHub Copilot

Copilot CLI and VS Code install this repo as a native plugin from its marketplace.

## Setup

### Copilot CLI

```bash
copilot plugin marketplace add helderberto/agent-skills
copilot plugin install hb@helderberto-skills
```

The plugin lands in `~/.copilot/installed-plugins/helderberto-skills/hb/`. Check it with `copilot plugin list` and `copilot skill list`.

### VS Code

VS Code picks up plugins installed by the CLI. Without the CLI, run **Chat: Install Plugin From Source** and enter `https://github.com/helderberto/agent-skills`. Agent plugins need `chat.plugins.enabled`, which is on by default.

Alternative, skills only with manual updates: `npx skills add helderberto/agent-skills -a github-copilot` copies them into `.agents/skills/` (`-g`: `~/.copilot/skills/`). Pick one route.

## Invoking skills

| Surface     | Typed form                            |
| ----------- | ------------------------------------- |
| Copilot CLI | `/triage`, `/to-spec dark-mode`       |
| VS Code     | `/hb:triage`, `/hb:to-spec dark-mode` |

Model-invocable skills also trigger from their `description`. Both surfaces honor `disable-model-invocation`, so flow skills stay typed-only, and `user-invocable: false`, which hides a skill from the `/` menu. In the CLI, drop `hb:` from `Next: /hb:<cmd>` lines.

## Limitations

- Copilot CLI has built-in `/review`, `/research`, and `/feedback`. To be sure you get the skill, ask by name: "use the review skill".
- `agents/` subagents target Claude Code. Copilot CLI expects plugin agents as `*.agent.md`. VS Code reads Claude-format `agents/*.md`, but their `skills:` preloads are Claude Code only.

## Updating

CLI: `copilot plugin update hb`. To update at every session start, set `autoUpdate` once in `~/.copilot/settings.json`:

```json
{
  "extraKnownMarketplaces": {
    "helderberto-skills": {
      "source": { "source": "github", "repo": "helderberto/agent-skills" },
      "autoUpdate": true
    }
  }
}
```

VS Code checks about once a day while `extensions.autoUpdate` is on. **Extensions: Check for Extension Updates** forces a check. For npx installs, run `npx skills update`.
