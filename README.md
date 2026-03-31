# Agent Skills

Personal collection of Claude Code agent skills - centralized repository for development workflows.

## About

Skills are managed using the [skills CLI](https://www.npmjs.com/package/skills) - a tool for installing and managing reusable AI agent capabilities.

**Philosophy:** Skills are centralized in this repository and consumed via GitHub, not duplicated across projects.

## Installation

### Local (Project-specific)

Install from GitHub (recommended):
```bash
npx skills add helderberto/skills --agent claude-code --all
```

Install specific skill:
```bash
npx skills add helderberto/skills --agent claude-code --skill commit
```

### Global (All Projects)

Install globally:
```bash
npx skills add helderberto/skills --agent claude-code --all --global
```

List available skills:
```bash
npx skills add helderberto/skills --list
```

## Managing Skills

### Local

List installed skills:
```bash
npx skills list
```

Update to latest version:
```bash
npx skills remove --all -y
npx skills add helderberto/skills --agent claude-code --all
```

### Global

List globally installed skills:
```bash
npx skills list --global
```

Update global installation:
```bash
npx skills remove --all --global -y
npx skills add helderberto/skills --agent claude-code --all --global
```

## Development

When developing skills locally:
```bash
cd /path/to/skills
npx skills add . --agent claude-code --all
```

This installs from the local repository for testing before pushing.

## Skills

| Skill | Description |
|-------|-------------|
| `a11y-audit` | Audit accessibility compliance in frontend code |
| `architecture-audit` | Surface architectural friction, propose refactors as GitHub issue RFCs |
| `atomic-commits` | Group unstaged changes into atomic commits by concern, then push |
| `precommit` | Pre-commit quality gate: auto-fix formatting/lint, verify types, run tests |
| `code-review` | Review a GitHub PR for bugs, security, performance, and code quality |
| `commit` | Create git commits following repository style |
| `coverage` | Check test coverage for unstaged changes |
| `create-pull-request` | Create GitHub pull requests |
| `deps-audit` | Check dependencies for vulnerabilities (npm only) |
| `e2e` | Write end-to-end tests for user flows using Cypress |
| `explain-code` | Explain code with visual diagrams and analogies |
| `grill-me` | Stress-test a plan or design through relentless interview |
| `harden` | Harden existing code by splitting large functions, adding edge-case coverage, and backfilling unit tests |
| `i18n` | Audit internationalization coverage, find hardcoded strings |
| `lint` | Run linting and formatting checks |
| `perf-audit` | Audit frontend bundle size and performance |
| `prd-to-plan` | Turn a PRD into a multi-phase implementation plan using tracer-bullet vertical slices |
| `prose-fix` | Fix formatting, typos, and clarity issues in markdown and text files |
| `refactor-plan` | Create structured refactoring plans |
| `revise` | Structurally edit and improve article drafts — reorder sections, tighten arguments, improve clarity |
| `safe-repo` | Check for sensitive data in repository |
| `ship` | Commit and push changes using atomic commits |
| `tdd` | Guide test-driven development with red-green-refactor loop |
| `write-a-prd` | Create a PRD through user interview, codebase exploration, and module design, saved locally to prds/ |
| `write-a-skill` | Create new agent skills with proper structure |

## Structure

Each skill is a directory containing:
- `SKILL.md` - All instructions, references, and templates in a single file
- `scripts/` - Executable helpers (when needed)

## License

[MIT](LICENSE) © Helder Burato Berto
