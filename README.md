# helderberto/agent-skills

[![Test Plugin Installation](https://github.com/helderberto/agent-skills/actions/workflows/test-plugin-install.yml/badge.svg)](https://github.com/helderberto/agent-skills/actions/workflows/test-plugin-install.yml)

**Personal SDLC toolbelt for AI coding agents — from PRD to ship.**

A collection of skills that encode the workflows, quality gates, and engineering practices I use day-to-day. Pure Markdown, zero runtime deps, installable as a [Claude Code](https://claude.com/claude-code) plugin or copied into any agent that reads instruction files.

```
  DEFINE          PLAN            BUILD            VERIFY            REVIEW           SHIP
 ┌──────┐       ┌──────┐        ┌──────┐         ┌──────┐         ┌──────┐         ┌──────┐
 │ Idea │ ────▶ │ Spec │ ─────▶ │ Code │ ──────▶ │ Test │ ──────▶ │  QA  │ ──────▶ │  Go  │
 │Refine│       │ PRD  │        │ Impl │         │Debug │         │ Gate │         │ Live │
 └──────┘       └──────┘        └──────┘         └──────┘         └──────┘         └──────┘
 /hb:prd        /hb:plan        /hb:build        /hb:check        /hb:review       /hb:ship
```

Each phase has a dedicated **workflow skill** that orchestrates the smaller toolbelt skills underneath it. Workflow skills are designed to be invoked explicitly; everything else auto-routes by description.

---

## Quick Start

<details open>
<summary><b>Claude Code (recommended)</b></summary>

Install via the marketplace:

```
/plugin marketplace add helderberto/agent-skills
/plugin install hb@helderberto-skills
```

After install, skills are available as `/hb:<skill-name>` — e.g. `/hb:prd`, `/hb:tdd`, `/hb:ship`. Most skills also auto-trigger from natural language ("review this PR", "check accessibility", etc.) based on their description.

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

A non-trivial feature flows through all six phases. Each workflow skill is one invocation:

```
You: /hb:prd add dark mode support
AI:  Interviews, scans the codebase, writes .specs/prds/dark-mode.md.
     Run /hb:plan dark-mode next?

You: /hb:plan dark-mode
AI:  Breaks the PRD into phased vertical slices.
     Writes .specs/plans/dark-mode.md.

You: /hb:build dark-mode
AI:  Implements next incomplete phase. TDD loop, lint, type-check.
     Marks checkboxes in the plan. Offers a commit.

You: /hb:check dark-mode
AI:  Verifies plan checkboxes against actual codebase.
     Reports total progress and remaining blockers.

You: /hb:review
AI:  Detects what changed, runs relevant audits in order
     (code-review, a11y-audit, safe-repo, perf-audit, deps-audit, ...).
     Consolidates findings into Critical / Important / Suggestion.

You: /hb:ship
AI:  Pre-launch gate (validate-code + safe-repo --diff).
     Atomic commits, push current branch.
     /hb:ship --fast skips the gate (hotfix only).
```

For quick standalone tasks, you don't need the workflow — just describe what you want and the relevant skill triggers ("write tests for X", "audit deps", "create an ADR for Y").

</details>

---

## Skills

Organized by SDLC phase. Expand a phase to browse; click a skill to read its `SKILL.md`.

<details>
<summary><b>DEFINE</b></summary>

| Skill | What it does |
|-------|--------------|
| [`prd`](skills/prd/SKILL.md) | Interview + codebase scan → structured PRD in `.specs/prds/<slug>.md` |
| [`grill-me`](skills/grill-me/SKILL.md) | Stress-test a plan or design through relentless interview |

</details>

<details>
<summary><b>PLAN</b></summary>

| Skill | What it does |
|-------|--------------|
| [`plan`](skills/plan/SKILL.md) | Turn PRD into multi-phase implementation plan (tracer-bullet vertical slices) |
| [`refactor-plan`](skills/refactor-plan/SKILL.md) | Structured refactoring plan, breaks large changes into small commits |
| [`architecture-audit`](skills/architecture-audit/SKILL.md) | Surface architectural friction, propose refactors toward deep modules |
| [`zoom-out`](skills/zoom-out/SKILL.md) | Go up a layer of abstraction — map relevant modules and callers |

</details>

<details>
<summary><b>BUILD</b></summary>

| Skill | What it does |
|-------|--------------|
| [`build`](skills/build/SKILL.md) | Implement next incomplete phase of a plan with feedback loops |
| [`tdd`](skills/tdd/SKILL.md) | Red → green → refactor loop for any new logic |
| [`source-driven`](skills/source-driven/SKILL.md) | Implement using official docs for exact dependency versions |
| [`fortify`](skills/fortify/SKILL.md) | Split large functions, add edge-case coverage, backfill missing tests |
| [`e2e`](skills/e2e/SKILL.md) | Write end-to-end tests for user flows using Cypress |

</details>

<details>
<summary><b>VERIFY</b></summary>

| Skill | What it does |
|-------|--------------|
| [`check`](skills/check/SKILL.md) | Verify plan checkboxes against codebase; mark or unmark |
| [`testing`](skills/testing/SKILL.md) | Run the test suite and report results (`npm test`) |
| [`coverage`](skills/coverage/SKILL.md) | Test coverage for unstaged changes |
| [`validate-code`](skills/validate-code/SKILL.md) | Auto-fix lint, verify types, run tests |
| [`lint`](skills/lint/SKILL.md) | Run linting and formatting checks |
| [`diagnose`](skills/diagnose/SKILL.md) | Disciplined diagnosis loop for hard bugs and perf regressions |
| [`visual-validate`](skills/visual-validate/SKILL.md) | Browser-driven UI validation via Chrome DevTools or Playwright MCP |

</details>

<details>
<summary><b>REVIEW</b></summary>

| Skill | What it does |
|-------|--------------|
| [`review`](skills/review/SKILL.md) | Orchestrated REVIEW phase — detect scope, run relevant audits, consolidate findings |
| [`code-review`](skills/code-review/SKILL.md) | Five-axis review of a PR (correctness, readability, architecture, security, performance) |
| [`a11y-audit`](skills/a11y-audit/SKILL.md) | Accessibility compliance audit (WCAG) |
| [`i18n`](skills/i18n/SKILL.md) | Find hardcoded strings, check translation coverage |
| [`perf-audit`](skills/perf-audit/SKILL.md) | Frontend bundle size and performance audit |
| [`deps-audit`](skills/deps-audit/SKILL.md) | Check dependencies for vulnerabilities (npm) |
| [`safe-repo`](skills/safe-repo/SKILL.md) | Sensitive data scan; `--diff` mode for in-flight changes |
| [`harden`](skills/harden/SKILL.md) | Proactive security hardening at trust boundaries (OWASP-style) |

</details>

<details>
<summary><b>SHIP</b></summary>

| Skill | What it does |
|-------|--------------|
| [`ship`](skills/ship/SKILL.md) | Pre-launch gate + atomic commits + push (`--fast` to skip gate) |
| [`commit`](skills/commit/SKILL.md) | Single commit following repository style |
| [`atomic-commits`](skills/atomic-commits/SKILL.md) | Group unstaged changes into atomic commits by concern |
| [`create-pull-request`](skills/create-pull-request/SKILL.md) | Open a GitHub PR with structured body |
| [`pr-reply`](skills/pr-reply/SKILL.md) | Draft concise replies to PR review comments |
| [`create-adr`](skills/create-adr/SKILL.md) | Record a 1–3 sentence Architecture Decision Record |
| [`deprecate`](skills/deprecate/SKILL.md) | Manage deprecation and migration of old systems |
| [`ci-cd`](skills/ci-cd/SKILL.md) | Set up or modify CI/CD pipelines (GitHub Actions, Buildkite) |

</details>

<details>
<summary><b>MISC</b></summary>

| Skill | What it does |
|-------|--------------|
| [`brief`](skills/brief/SKILL.md) | Session briefing — active features, progress, suggested focus |
| [`doubt-driven-development`](skills/doubt-driven-development/SKILL.md) | Adversarial fresh-context review of non-trivial decisions |
| [`context-engineer`](skills/context-engineer/SKILL.md) | Optimize what loads into agent context; recover when output degrades |
| [`explain-code`](skills/explain-code/SKILL.md) | Explain code with visual diagrams and analogies |
| [`setup-pre-commit`](skills/setup-pre-commit/SKILL.md) | Configure Husky + lint-staged for commit-time gates |
| [`write-a-skill`](skills/write-a-skill/SKILL.md) | Author a new skill with proper structure |
| [`caveman`](skills/caveman/SKILL.md) | Ultra-compressed communication mode (cuts ~75% tokens) |
| [`prose-fix`](skills/prose-fix/SKILL.md) | Fix typos, dashes, formatting in markdown |
| [`revise`](skills/revise/SKILL.md) | Structurally edit and improve article drafts |

</details>

---

## Structure

```
agent-skills/
├── .claude-plugin/      Plugin manifest + marketplace entry (Claude Code)
├── .opencode/skills →   Symlink to skills/ for OpenCode discovery
├── skills/              one folder per skill, each with SKILL.md
├── docs/                Skill anatomy + per-agent setup guides
├── AGENTS.md            Intent → skill mapping (drives OpenCode auto-routing)
├── CONTRIBUTING.md      How to contribute new skills or improvements
├── LICENSE              MIT
└── README.md
```

### Artifact convention

Workflow skills write structured artifacts to `.specs/`:

- `.specs/prds/<slug>.md` — PRDs from `/hb:prd`
- `.specs/plans/<slug>.md` — phased plans from `/hb:plan`

The `.specs/` directory is local-first. Add it to `.gitignore` if you prefer specs as scratch space, or commit it if you want specs as versioned project documentation.

---

## Contributing

PRs welcome. See [CONTRIBUTING.md](CONTRIBUTING.md) for workflow, conventions, and where to start.

---

## License

[MIT](LICENSE) © Helder Burato Berto
