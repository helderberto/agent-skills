# helderberto/agent-skills

[![Test Plugin Installation](https://github.com/helderberto/agent-skills/actions/workflows/test-plugin-install.yml/badge.svg)](https://github.com/helderberto/agent-skills/actions/workflows/test-plugin-install.yml)

**Personal SDLC toolbelt for AI coding agents — from idea to PR.**

A collection of skills that encode the workflows, quality gates, and engineering practices I use day-to-day. Pure Markdown, zero runtime deps, installable as a [Claude Code](https://claude.com/claude-code) plugin or copied into any agent that reads instruction files.

```
TRIAGE    GRILL    SPEC       TICKETS       BUILD    REVIEW    SHIP     RETRO
triage ─▶ grill ─▶ to-spec ─▶ to-tickets ─▶ build ─▶ review ─▶ to-pr ─▶ retro
```

Type `/hb:<command>` for each step; `/hb:triage` tells you where to enter. The SHIP phase is `/hb:to-pr`: gate, push, PR, CI watch. Flow commands never chain on their own and never call each other. Each ends with a filled-in `Next: /hb:<cmd> <args>` line, so you always pull the trigger yourself.

Full walkthrough and the `.specs/` artifact layout: [docs/workflow.md](docs/workflow.md).

---

## Quick Start

**Fastest path — any agent, one command.** The [skills CLI](https://github.com/vercel-labs/skills) installs into 70+ agents (Claude Code, Cursor, Codex, Copilot, OpenCode, and more):

```bash
npx skills add helderberto/agent-skills             # install all skills
npx skills add helderberto/agent-skills --list      # browse before installing
npx skills add helderberto/agent-skills --skill tdd # one skill
```

It installs skills only; the Claude Code plugin also ships the `agents/` subagents. Pick one install per agent, or every skill shows up twice.

Prefer a native integration? Pick your tool below.

<details open>
<summary><b>Claude Code (Recommended)</b></summary>

**Marketplace install:**

```bash
/plugin marketplace add helderberto/agent-skills
/plugin install hb@helderberto-skills
```

> Third-party marketplaces don't auto-update: turn it on in `/plugin` → **Marketplaces**.
>
> SSH errors on install → `git config --global url."https://github.com/".insteadOf git@github.com:`.

</details>

| Agent           | Install                                                                                                     | Guide                                             |
| --------------- | ----------------------------------------------------------------------------------------------------------- | ------------------------------------------------- |
| Codex           | `codex plugin marketplace add helderberto/agent-skills` → `codex plugin add hb@helderberto-skills`          | [codex-setup.md](docs/codex-setup.md)             |
| Cursor          | Clone, then `rsync -a agent-skills/skills/ .cursor/skills/`                                                 | [cursor-setup.md](docs/cursor-setup.md)           |
| Antigravity CLI | `agy plugin install https://github.com/helderberto/agent-skills`                                            | [antigravity-setup.md](docs/antigravity-setup.md) |
| Gemini CLI      | `gemini skills install https://github.com/helderberto/agent-skills.git --path skills`                       | [gemini-cli-setup.md](docs/gemini-cli-setup.md)   |
| GitHub Copilot  | `copilot plugin marketplace add helderberto/agent-skills` → `copilot plugin install hb@helderberto-skills`   | [copilot-setup.md](docs/copilot-setup.md)         |
| OpenCode        | Clone, copy `skills/*` to `.opencode/skills/`, paste the OpenCode section of `AGENTS.md` into yours          | [opencode-setup.md](docs/opencode-setup.md)       |
| Other agents    | `npx skills@latest add helderberto/agent-skills -a <agent>` (devin, windsurf, amp, pi; omit `-a` to choose) | —                                                 |

Codex invokes skills as `$hb:<skill>`; the others use `/hb:<skill>`.

---

## Skills

Typed as `/hb:<name>` or triggered from the task. Naming, invocation tiers, and effort hints: [docs/skill-conventions.md](docs/skill-conventions.md).

### SDLC workflow

The flow, one typed command per step:

| Skill                                      | Phase   | What it does                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             |
| ------------------------------------------ | ------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| [`setup`](skills/setup/SKILL.md)           | SETUP   | Optional, once per repo: pick where specs and tickets live — local markdown (default), or only in GitHub or Jira |
| [`triage`](skills/triage/SKILL.md)         | TRIAGE  | Classify any input (idea, bug, ticket, PR, stack trace), size it, name the command to type; no args → where you are                                                                                                                                                                                                                                                                                                                                                                                                      |
| [`grill`](skills/grill/SKILL.md)           | GRILL   | Interview in rounds over the design-tree frontier, each question with a recommended answer                                                                                                                                                                                                                                                                                                                                                                                                                               |
| [`to-spec`](skills/to-spec/SKILL.md)       | SPEC    | Settled conversation + codebase scan → structured spec in `.specs/specs/<slug>.md`, or one tracker issue                                                                                                                                                                                                                                                                                                                                                                                                                                       |
| [`to-tickets`](skills/to-tickets/SKILL.md) | TICKETS | Slice a spec into tracer-bullet vertical slices with blocking edges                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
| [`build`](skills/build/SKILL.md)           | BUILD   | Implement the next unblocked slice test-first via `tdd`, with feedback loops; `--all` fans every ticket out to parallel implementer subagents after one approval                                                                                                                                                                                                                                                                                                                                                         |
| [`review`](skills/review/SKILL.md)         | REVIEW  | Fan out parallel reviewers (scope-detected audits + agent lenses incl. spec conformance, standards, coverage, and a quality-bar check), consolidate into one verdict                                                                                                                                                                                                                                                                                                                                                     |
| [`to-pr`](skills/to-pr/SKILL.md)           | SHIP    | Gate (check, ADR check), push, open a GitHub PR on the repo's template or the default, every field written by the model with no questions: Summary with a visual (diagram, diff sketch, or tree), Before/After evidence, merge danger (one-way or two-way door, blast radius); watch CI, `debug` on red (max 2); `--safe` runs `safe-repo` before the push, `--skip-ci` marks the HEAD commit `[skip ci]` and skips the watch, `--diagram[=<type>]` makes the visual a mermaid diagram, typed by the change unless given |
| [`retro`](skills/retro/SKILL.md)           | RETRO   | Retrospective on a session — suggests navigation pointers, checks, coding standards, steering fixes; mechanical mistakes become checks                                                                                                                                                                                                                                                                                                                                                                                   |

### On-demand tools

Focused capabilities the agent applies based on the task; both-tier ones are also typed as `/hb:<name>`. Expand a group to browse.

<details>
<summary><b>Build &amp; test</b></summary>

| Skill                                            | What it does                                                                                          |
| ------------------------------------------------ | ----------------------------------------------------------------------------------------------------- |
| [`tdd`](skills/tdd/SKILL.md)                     | Red → green → refactor loop for any new logic, unit to end-to-end                                     |
| [`source-driven`](skills/source-driven/SKILL.md) | Implement using official docs for exact dependency versions                                           |
| [`refactor`](skills/refactor/SKILL.md)           | Behavior-preserving improvement: split large functions, backfill tests, simplify (Chesterton's Fence) |

</details>

<details>
<summary><b>Verify</b></summary>

| Skill                            | What it does                                                     |
| -------------------------------- | ---------------------------------------------------------------- |
| [`check`](skills/check/SKILL.md) | Auto-fix lint, verify types, run tests; `--check` writes nothing |
| [`debug`](skills/debug/SKILL.md) | Disciplined diagnosis loop for hard bugs and perf regressions    |

</details>

<details>
<summary><b>Review &amp; audit</b></summary>

| Skill                                            | What it does                                                                                                                                                                                                   |
| ------------------------------------------------ | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [`code-review`](skills/code-review/SKILL.md)     | Correctness lens used by `build` and `review`: a PR or diff against an approval standard — correctness, security, performance, a Fowler smell baseline; Critical→Nit severities                                |
| [`visual-review`](skills/visual-review/SKILL.md) | Render a PR diff as an annotated HTML page — each hunk linked to a design/simplification principle with a suggested rewrite; `--ui` checks a UI change in a real browser via Chrome DevTools or Playwright MCP |
| [`feedback`](skills/feedback/SKILL.md)           | Triage existing PR review comments (Copilot + human), verify against code, classify Address/Skip/Optional/Discuss                                                                                              |
| [`a11y-audit`](skills/a11y-audit/SKILL.md)       | Accessibility compliance audit (WCAG)                                                                                                                                                                          |
| [`i18n`](skills/i18n/SKILL.md)                   | Find hardcoded strings, check translation coverage                                                                                                                                                             |
| [`perf-audit`](skills/perf-audit/SKILL.md)       | Frontend bundle size and Core Web Vitals risks; no metric without a measurement                                                                                                                                |
| [`deps-audit`](skills/deps-audit/SKILL.md)       | Check dependencies for vulnerabilities (npm/pnpm/yarn/pip/go/cargo)                                                                                                                                            |
| [`safe-repo`](skills/safe-repo/SKILL.md)         | Sensitive data scan; `--diff [<base>]` scopes to a branch's changes                                                                                                                                            |
| [`harden`](skills/harden/SKILL.md)               | Proactive security hardening at trust boundaries (OWASP-style), including LLM features                                                                                                                         |

</details>

<details>
<summary><b>Git &amp; release</b></summary>

| Skill                              | What it does                                                             |
| ---------------------------------- | ------------------------------------------------------------------------ |
| [`commit`](skills/commit/SKILL.md) | Group unstaged changes into atomic commits by concern (repository style) |
| [`to-adr`](skills/to-adr/SKILL.md) | Record a 1–3 sentence Architecture Decision Record                       |

</details>

<details>
<summary><b>Design &amp; discovery</b></summary>

| Skill                                                                | What it does                                                                                                                       |
| -------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------- |
| [`codebase-design`](skills/codebase-design/SKILL.md)                 | Shared deep-module vocabulary for designing or improving an interface                                                              |
| [`frontend-ui-engineering`](skills/frontend-ui-engineering/SKILL.md) | Front-load UI construction decisions — prop API, state placement, required states, a11y by construction                            |
| [`architecture-audit`](skills/architecture-audit/SKILL.md)           | Surface architectural friction in git hot spots, propose refactors toward deep modules as RFCs; `--html` for a before/after report |
| [`domain-modeling`](skills/domain-modeling/SKILL.md)                 | Build and sharpen the project's ubiquitous language and glossary                                                                   |
| [`research`](skills/research/SKILL.md)                               | Investigate a question against primary sources; capture cited findings as Markdown                                                 |
| [`prototype`](skills/prototype/SKILL.md)                             | Build a throwaway prototype — shareable HTML logic demo or toggleable UI variations — kept on a `prototype/<name>` branch          |
| [`debate`](skills/debate/SKILL.md)                                   | Is a risky change or PR worth it? Advocate, skeptic, and neutral investigator argue it over two rounds, then one recommendation    |

</details>

<details>
<summary><b>Session, meta &amp; writing</b></summary>

| Skill                                          | What it does                                                                                                                        |
| ---------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------- |
| [`guide`](skills/guide/SKILL.md)               | Which skill fits? A map of the flow, on-ramps, and standalone skills, plus when to continue, `/clear`, `/hb:handoff`, or `/compact` |
| [`handoff`](skills/handoff/SKILL.md)           | Compact the current conversation into a handoff doc for a fresh agent                                                               |
| [`teach`](skills/teach/SKILL.md)               | Stateful teaching workspace — lessons, references, learning records tied to a mission                                               |
| [`wait-what`](skills/wait-what/SKILL.md)       | Last message didn't land — re-pitch it with context, in Simplified Technical English and glossary terms                             |
| [`zoom-out`](skills/zoom-out/SKILL.md)         | Explain code with visual diagrams and analogies                                                                                     |
| [`create-skill`](skills/create-skill/SKILL.md) | Author a new skill with proper structure                                                                                            |
| [`revise`](skills/revise/SKILL.md)             | Restructure article drafts, or polish any markdown (typos, dashes, filler)                                                          |

</details>

---

## Agents

Subagents the skills fan out to for independent, read-only perspectives (e.g. `/hb:review` spawns `test-auditor` as a lens). Bundled with the plugin, so installing `hb` ships them too. **Claude Code only** — other agents consume `skills/` and ignore this directory.

| Agent                                            | Purpose                                                                                        |
| ------------------------------------------------ | ---------------------------------------------------------------------------------------------- |
| [`test-auditor`](agents/test-auditor.md)         | Test effectiveness beyond coverage: weak assertions, missing edge scenarios, surviving mutants |
| [`security-auditor`](agents/security-auditor.md) | Exploitable flaws at trust boundaries, STRIDE per boundary; preloads `harden`                  |
| [`perf-auditor`](agents/perf-auditor.md)         | Bundle size and Core Web Vitals risks, graded for review; preloads `perf-audit`                |
| [`parity-auditor`](agents/parity-auditor.md)     | Audit code migrations for missing functionality                                                |

---

## Contributing

PRs welcome. See [CONTRIBUTING.md](CONTRIBUTING.md) for workflow, conventions, and where to start.

---

## License

[MIT](LICENSE) © Helder Burato Berto
