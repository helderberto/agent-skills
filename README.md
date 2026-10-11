# helderberto/agent-skills

[![Test Plugin Installation](https://github.com/helderberto/agent-skills/actions/workflows/test-plugin-install.yml/badge.svg)](https://github.com/helderberto/agent-skills/actions/workflows/test-plugin-install.yml)

**Personal SDLC toolbelt for AI coding agents — from idea to PR.**

A collection of skills that encode the workflows, quality gates, and engineering practices I use day-to-day. Pure Markdown, zero runtime deps, installable as a [Claude Code](https://claude.com/claude-code) plugin or copied into any agent that reads instruction files.

```
TRIAGE    GRILL    SPEC       TICKETS       BUILD    REVIEW    SHIP     RETRO
triage ─▶ grill ─▶ to-spec ─▶ to-tickets ─▶ build ─▶ review ─▶ to-pr ─▶ retro
```

Type `/hb:<command>` for each step; `/hb:triage` tells you where to enter. The SHIP phase is `/hb:to-pr`: gate, push, PR, CI watch. Flow commands never chain on their own and never call each other. Each ends with a filled-in `Next: /hb:<cmd> <args>` line, so you always pull the trigger yourself.

---

## Quick Start

<details open>
<summary><b>Claude Code (recommended)</b></summary>

Install via the marketplace:

```
/plugin marketplace add helderberto/agent-skills
/plugin install hb@helderberto-skills
```

After install, skills are available as `/hb:<skill-name>` — e.g. `/hb:triage`, `/hb:to-spec`, `/hb:to-pr`. Both-tier and model-only skills also trigger from natural language ("review this PR", "check accessibility", etc.) based on their description.

</details>

<details>
<summary><b>Gemini CLI</b></summary>

Install as native skills:

```bash
gemini skills install https://github.com/helderberto/agent-skills.git --path skills
```

Skills are auto-discovered and routed by description. See [docs/gemini-cli-setup.md](docs/gemini-cli-setup.md).

</details>

<details>
<summary><b>OpenCode</b></summary>

Clone and point OpenCode at the workspace — `AGENTS.md` plus the `skills/` directory drive auto-routing:

```bash
git clone https://github.com/helderberto/agent-skills.git
```

Open the project in OpenCode. The `.opencode/skills` symlink and root `AGENTS.md` are already wired. See [docs/opencode-setup.md](docs/opencode-setup.md).

</details>

<details>
<summary><b>Cursor</b></summary>

Clone the repo, then copy individual skills into `.cursor/rules/`:

```bash
git clone https://github.com/helderberto/agent-skills.git
cp agent-skills/skills/tdd/SKILL.md .cursor/rules/tdd.md
cp agent-skills/skills/code-review/SKILL.md .cursor/rules/code-review.md
```

See [docs/cursor-setup.md](docs/cursor-setup.md) for the recommended starter set.

</details>

---

<details>
<summary><b>Workflow example</b> — full SDLC walkthrough</summary>

A non-trivial feature flows through every step. Each command is one invocation:

```
You: /hb:triage add dark mode support
AI:  L, fuzzy feature → /hb:grill dark mode

You: /hb:grill dark mode
AI:  Interviews you in rounds; writes settled terms to the glossary and ADRs inline.
     Next: /hb:to-spec dark-mode

You: /hb:to-spec dark-mode
AI:  Writes .specs/specs/dark-mode.md from the conversation, no re-interview.
     Next: /hb:to-tickets dark-mode

You: /hb:to-tickets dark-mode
AI:  Slices the spec into tracer-bullet tickets with blocking edges.

You: /hb:build dark-mode
AI:  Implements the next unblocked ticket test-first via tdd, then lint and
     type-check. Marks checkboxes, commits.
     /hb:build dark-mode --all runs every ticket after one approval.

You: /hb:review
AI:  Fans out reviewers in parallel (correctness, standards, spec + checkboxes,
     tests + coverage, quality bar, a11y-audit, safe-repo, ...).
     Consolidates findings into Critical / Important / Suggestion.

You: /hb:to-pr
AI:  Gate (check, ADR check), push, PR body with Before/After evidence and
     merge danger, gh pr create, then watches CI.

You: /hb:retro
AI:  Suggests environment fixes from this session: pointers, checks, standards.
```

For quick standalone tasks, you don't need the flow — describe what you want and the relevant skill triggers ("write tests for X", "audit deps", "create an ADR for Y").

</details>

---

## Skills

### Naming

- **Verb** — does work, asks you something or changes code: `triage`, `grill`, `build`, `review`, `retro`, `debug`, `refactor`.
- **`to-X`** — turns what's in context into artifact X, at most one question round, never an interview: `to-spec`, `to-tickets`, `to-pr`, `to-adr`.
- **`*-audit`** — read-only report: `a11y-audit`, `perf-audit`, `deps-audit`, `architecture-audit`.

### Invocation tiers

Rule: on the flow, outward-facing, expensive, or session control → **typed-only**. Reached only by other skills or plain phrasing → **model only**. Otherwise → **both**.

| Tier | Frontmatter | Skills |
|---|---|---|
| Typed-only (12) | `disable-model-invocation: true` | triage · grill · to-spec · to-tickets · build · review · to-pr · retro · architecture-audit · handoff · wait-what · teach |
| Both (11) | default | debug · to-adr · zoom-out · commit · check · feedback · refactor · prototype · research · revise · create-skill |
| Model only (13) | `user-invocable: false` | tdd · code-review · codebase-design · domain-modeling · harden · source-driven · frontend-ui-engineering · visual-review · a11y-audit · i18n · perf-audit · deps-audit · safe-repo |

The `/hb:` menu shows typed-only and both (23 entries); the model sees both and model-only descriptions (24). Typed-only skills call model skills through the Skill tool and mention other typed-only skills only in `Next:` lines. Typed-only descriptions keep one what-it-does sentence; trigger phrases live only on model-visible skills. `ship` stays typed-only until `to-pr` absorbs it.

Skills also carry an **effort** hint: mechanical ones (`commit`, `to-adr`) run at low reasoning effort, heavy ones (`architecture-audit`, `harden`, `debug`) at high or xhigh, and the rest at the implicit medium default. The override lasts only for the turn the skill fires — so complexity matches the task without you touching `/effort`.

### SDLC workflow

The flow, one typed command per step:

| Skill | Phase | What it does |
|-------|-------|--------------|
| [`triage`](skills/triage/SKILL.md) | TRIAGE | Router — maps your situation to the command to type next, plus when to continue, `/clear`, hand off, or `/compact` |
| [`grill`](skills/grill/SKILL.md) | GRILL | Interview in rounds over the design-tree frontier, each question with a recommended answer |
| [`to-spec`](skills/to-spec/SKILL.md) | SPEC | Settled conversation + codebase scan → structured spec in `.specs/specs/<slug>.md` |
| [`to-tickets`](skills/to-tickets/SKILL.md) | TICKETS | Slice a spec into tracer-bullet vertical slices with blocking edges |
| [`build`](skills/build/SKILL.md) | BUILD | Implement the next unblocked slice test-first via `tdd`, with feedback loops; `--all` runs every slice after one approval |
| [`review`](skills/review/SKILL.md) | REVIEW | Fan out parallel reviewers (scope-detected audits + agent lenses incl. spec conformance, standards, coverage, and a quality-bar check), consolidate into one verdict |
| [`ship`](skills/ship/SKILL.md) | SHIP | Pre-launch gate (check + safe-repo + floor-guard) + atomic commits + push (`--fast` to skip gate); folds into `to-pr` |
| [`to-pr`](skills/to-pr/SKILL.md) | SHIP | Open a GitHub PR with a concise templated body: Before/After evidence, merge danger (one-way or two-way door, blast radius); `--diagram` adds a mermaid diagram of the change |
| [`retro`](skills/retro/SKILL.md) | RETRO | Retrospective on a session — suggests navigation pointers, checks, coding standards, steering fixes; mechanical mistakes become checks |

### On-demand tools

Focused capabilities the agent applies based on the task; both-tier ones are also typed as `/hb:<name>`. Expand a group to browse.

<details>
<summary><b>Build &amp; test</b></summary>

| Skill | What it does |
|-------|--------------|
| [`tdd`](skills/tdd/SKILL.md) | Red → green → refactor loop for any new logic, unit to end-to-end |
| [`source-driven`](skills/source-driven/SKILL.md) | Implement using official docs for exact dependency versions |
| [`refactor`](skills/refactor/SKILL.md) | Behavior-preserving improvement: split large functions, backfill tests, simplify (Chesterton's Fence) |

</details>

<details>
<summary><b>Verify</b></summary>

| Skill | What it does |
|-------|--------------|
| [`check`](skills/check/SKILL.md) | Auto-fix lint, verify types, run tests; `--check` writes nothing |
| [`debug`](skills/debug/SKILL.md) | Disciplined diagnosis loop for hard bugs and perf regressions |

</details>

<details>
<summary><b>Review &amp; audit</b></summary>

| Skill | What it does |
|-------|--------------|
| [`code-review`](skills/code-review/SKILL.md) | PR or pasted-diff review against an approval standard — correctness, security, performance, a Fowler smell baseline; Critical→Nit severities |
| [`visual-review`](skills/visual-review/SKILL.md) | Render a PR diff as an annotated HTML page — each hunk linked to a design/simplification principle with a suggested rewrite; `--ui` checks a UI change in a real browser via Chrome DevTools or Playwright MCP |
| [`feedback`](skills/feedback/SKILL.md) | Triage existing PR review comments (Copilot + human), verify against code, classify Address/Skip/Optional/Discuss |
| [`a11y-audit`](skills/a11y-audit/SKILL.md) | Accessibility compliance audit (WCAG) |
| [`i18n`](skills/i18n/SKILL.md) | Find hardcoded strings, check translation coverage |
| [`perf-audit`](skills/perf-audit/SKILL.md) | Frontend bundle size and performance audit |
| [`deps-audit`](skills/deps-audit/SKILL.md) | Check dependencies for vulnerabilities (npm/pnpm/yarn/pip/go/cargo) |
| [`safe-repo`](skills/safe-repo/SKILL.md) | Sensitive data scan; `--diff` mode for in-flight changes |
| [`harden`](skills/harden/SKILL.md) | Proactive security hardening at trust boundaries (OWASP-style) |

</details>

<details>
<summary><b>Git &amp; release</b></summary>

| Skill | What it does |
|-------|--------------|
| [`commit`](skills/commit/SKILL.md) | Group unstaged changes into atomic commits by concern (repository style) |
| [`to-adr`](skills/to-adr/SKILL.md) | Record a 1–3 sentence Architecture Decision Record |

</details>

<details>
<summary><b>Design &amp; discovery</b></summary>

| Skill | What it does |
|-------|--------------|
| [`codebase-design`](skills/codebase-design/SKILL.md) | Shared deep-module vocabulary for designing or improving an interface |
| [`frontend-ui-engineering`](skills/frontend-ui-engineering/SKILL.md) | Front-load UI construction decisions — prop API, state placement, required states, a11y by construction |
| [`architecture-audit`](skills/architecture-audit/SKILL.md) | Surface architectural friction in git hot spots, propose refactors toward deep modules as RFCs; `--html` for a before/after report |
| [`domain-modeling`](skills/domain-modeling/SKILL.md) | Build and sharpen the project's ubiquitous language and glossary |
| [`research`](skills/research/SKILL.md) | Investigate a question against primary sources; capture cited findings as Markdown |
| [`prototype`](skills/prototype/SKILL.md) | Build a throwaway prototype — shareable HTML logic demo or toggleable UI variations — kept on a `prototype/<name>` branch |

</details>

<details>
<summary><b>Session, meta &amp; writing</b></summary>

| Skill | What it does |
|-------|--------------|
| [`handoff`](skills/handoff/SKILL.md) | Compact the current conversation into a handoff doc for a fresh agent |
| [`teach`](skills/teach/SKILL.md) | Stateful teaching workspace — lessons, references, learning records tied to a mission |
| [`wait-what`](skills/wait-what/SKILL.md) | Last message didn't land — re-pitch it with context, in Simplified Technical English and glossary terms |
| [`zoom-out`](skills/zoom-out/SKILL.md) | Explain code with visual diagrams and analogies |
| [`create-skill`](skills/create-skill/SKILL.md) | Author a new skill with proper structure |
| [`revise`](skills/revise/SKILL.md) | Restructure article drafts, or polish any markdown (typos, dashes, filler) |

</details>

---

## Agents

Subagents the skills fan out to for independent, read-only perspectives (e.g. `/hb:review` spawns `test-auditor` as a lens). Bundled with the plugin, so installing `hb` ships them too. **Claude Code only** — other agents consume `skills/` and ignore this directory.

| Agent | Purpose |
|-------|---------|
| [`test-auditor`](agents/test-auditor.md) | Test effectiveness beyond coverage |
| [`parity-check`](agents/parity-check.md) | Audit code migrations for missing functionality |

---

## Structure

```
agent-skills/
├── .claude-plugin/      Plugin manifest + marketplace entry (Claude Code)
├── .opencode/skills →   Symlink to skills/ for OpenCode discovery
├── skills/              one folder per skill, each with SKILL.md
├── agents/              subagent definitions (Claude Code only)
├── docs/                Skill anatomy + per-agent setup guides
├── AGENTS.md            Intent → skill mapping (drives OpenCode auto-routing)
├── CONTRIBUTING.md      How to contribute new skills or improvements
├── LICENSE              MIT
└── README.md
```

### Artifact convention

Workflow skills write structured artifacts to `.specs/`:

- `.specs/specs/<slug>.md` — specs from `/hb:to-spec`
- `.specs/tickets/<slug>.md` — tracer-bullet tickets from `/hb:to-tickets`
- `.specs/research/<slug>.md` — cited findings from `/hb:research`, when the repo has no notes convention of its own

The `.specs/` directory is local-first. Add it to `.gitignore` if you prefer specs as scratch space, or commit it if you want specs as versioned project documentation.

Throwaway output stays out of the working tree, so `commit` never sweeps it up: `visual-review` and `architecture-audit --html` reports, `perf-audit` bundle reports, and `handoff` docs go to `$TMPDIR` (else `/tmp`), and the skill prints the path.

---

## Contributing

PRs welcome. See [CONTRIBUTING.md](CONTRIBUTING.md) for workflow, conventions, and where to start.

---

## License

[MIT](LICENSE) © Helder Burato Berto
