# helderberto/agent-skills

**Personal SDLC toolbelt for AI coding agents — from PRD to ship.**

42 skills that encode the workflows, quality gates, and engineering practices I use day-to-day. Pure Markdown, zero runtime deps, installable as a [Claude Code](https://claude.com/claude-code) plugin or copied into any agent that reads instruction files.

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

Copy individual skills into `.cursor/rules/`:

```bash
cp /path/to/agent-skills/skills/tdd/SKILL.md .cursor/rules/tdd.md
cp /path/to/agent-skills/skills/code-review/SKILL.md .cursor/rules/code-review.md
```

See [docs/cursor-setup.md](docs/cursor-setup.md) for the recommended starter set.

</details>

---

## Workflow Example

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

---

## Skills

| Phase | Skill | What it does |
|-------|-------|--------------|
| **DEFINE** | `prd` | Interview + codebase scan → structured PRD in `.specs/prds/<slug>.md` |
| | `grill-me` | Stress-test a plan or design through relentless interview |
| **PLAN** | `plan` | Turn PRD into multi-phase implementation plan (tracer-bullet vertical slices) |
| | `refactor-plan` | Structured refactoring plan, breaks large changes into small commits |
| | `architecture-audit` | Surface architectural friction, propose refactors toward deep modules |
| | `zoom-out` | Go up a layer of abstraction — map relevant modules and callers |
| **BUILD** | `build` | Implement next incomplete phase of a plan with feedback loops |
| | `tdd` | Red → green → refactor loop for any new logic |
| | `source-driven` | Implement using official docs for exact dependency versions |
| | `fortify` | Split large functions, add edge-case coverage, backfill missing tests |
| | `e2e` | Write end-to-end tests for user flows using Cypress |
| **VERIFY** | `check` | Verify plan checkboxes against codebase; mark or unmark |
| | `coverage` | Test coverage for unstaged changes |
| | `validate-code` | Auto-fix lint, verify types, run tests |
| | `lint` | Run linting and formatting checks |
| | `diagnose` | Disciplined diagnosis loop for hard bugs and perf regressions |
| | `visual-validate` | Browser-driven UI validation via Chrome DevTools or Playwright MCP |
| **REVIEW** | `review` | Orchestrated REVIEW phase — detect scope, run relevant audits, consolidate findings |
| | `code-review` | Five-axis review of a PR (correctness, readability, architecture, security, performance) |
| | `a11y-audit` | Accessibility compliance audit (WCAG) |
| | `i18n` | Find hardcoded strings, check translation coverage |
| | `perf-audit` | Frontend bundle size and performance audit |
| | `deps-audit` | Check dependencies for vulnerabilities (npm) |
| | `safe-repo` | Sensitive data scan; `--diff` mode for in-flight changes |
| | `harden` | Proactive security hardening at trust boundaries (OWASP-style) |
| **SHIP** | `ship` | Pre-launch gate + atomic commits + push (`--fast` to skip gate) |
| | `commit` | Single commit following repository style |
| | `atomic-commits` | Group unstaged changes into atomic commits by concern |
| | `create-pull-request` | Open a GitHub PR with structured body |
| | `pr-reply` | Draft concise replies to PR review comments |
| | `create-adr` | Record a 1–3 sentence Architecture Decision Record |
| | `deprecate` | Manage deprecation and migration of old systems |
| | `ci-cd` | Set up or modify CI/CD pipelines (GitHub Actions, Buildkite) |
| **CROSS** | `brief` | Session briefing — active features, progress, suggested focus |
| | `doubt-driven-development` | Adversarial fresh-context review of non-trivial decisions |
| | `context-engineer` | Optimize what loads into agent context; recover when output degrades |
| | `explain-code` | Explain code with visual diagrams and analogies |
| | `setup-pre-commit` | Configure Husky + lint-staged for commit-time gates |
| | `write-a-skill` | Author a new skill with proper structure |
| | `caveman` | Ultra-compressed communication mode (cuts ~75% tokens) |
| | `prose-fix` | Fix typos, dashes, formatting in markdown |
| | `revise` | Structurally edit and improve article drafts |

---

## Structure

```
agent-skills/
├── .claude-plugin/      Plugin manifest + marketplace entry (Claude Code)
├── .opencode/skills →   Symlink to skills/ for OpenCode discovery
├── skills/              42 skills, one folder per skill, each with SKILL.md
├── docs/                Per-agent setup guides (Cursor, Gemini CLI, OpenCode)
├── AGENTS.md            Intent → skill mapping (drives OpenCode auto-routing)
├── LICENSE              MIT
└── README.md
```

### Skill anatomy

Every skill is a self-contained directory:

- `SKILL.md` — entry point with YAML frontmatter (`name`, `description`) followed by workflow, rules, error handling, verification
- `references/` *(optional)* — deep material loaded on demand
- `scripts/` *(optional)* — executable helpers a skill invokes

Skills auto-trigger when their `description` matches user intent. Workflow skills (`prd`, `plan`, `build`, `check`, `review`, `ship`) are typically invoked explicitly as `/hb:<name>`.

### Artifact convention

Workflow skills write structured artifacts to `.specs/`:

- `.specs/prds/<slug>.md` — PRDs from `/hb:prd`
- `.specs/plans/<slug>.md` — phased plans from `/hb:plan`

The `.specs/` directory is local-first. Add it to `.gitignore` if you prefer specs as scratch space, or commit it if you want specs as versioned project documentation.

---

## Contributing

PRs welcome. See the `write-a-skill` skill for the expected structure, then open a PR against `main`.

---

## License

[MIT](LICENSE) © Helder Burato Berto
