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
| `caveman` | Ultra-compressed communication mode — cuts token usage by dropping filler while keeping technical accuracy |
| `code-review` | Review a GitHub PR for bugs, security, performance, and code quality |
| `commit` | Create git commits following repository style |
| `coverage` | Check test coverage for unstaged changes |
| `create-adr` | Record an Architecture Decision Record — gated 1–3 sentence note of what was decided and why |
| `create-pull-request` | Create GitHub pull requests |
| `deps-audit` | Check dependencies for vulnerabilities (npm only) |
| `diagnose` | Disciplined diagnosis loop for hard bugs and perf regressions — feedback loop first |
| `e2e` | Write end-to-end tests for user flows using Cypress |
| `explain-code` | Explain code with visual diagrams and analogies |
| `fortify` | Fortify existing code by splitting large functions, adding edge-case coverage, and backfilling unit tests |
| `grill-me` | Stress-test a plan or design through relentless interview |
| `i18n` | Audit internationalization coverage, find hardcoded strings |
| `lint` | Run linting and formatting checks |
| `perf-audit` | Audit frontend bundle size and performance |
| `pr-reply` | Draft friendly, concise replies to pull request review comments |
| `prose-fix` | Fix formatting, typos, and clarity issues in markdown and text files |
| `refactor-plan` | Create structured refactoring plans |
| `revise` | Structurally edit and improve article drafts — reorder sections, tighten arguments, improve clarity |
| `safe-repo` | Check for sensitive data in repository |
| `setup-pre-commit` | Set up Husky pre-commit hooks with lint-staged, Prettier, type checking, and tests |
| `ship` | Commit and push changes using atomic commits |
| `source-driven` | Implement features using official docs for exact dependency versions instead of training data |
| `tdd` | Guide test-driven development with red-green-refactor loop |
| `validate-code` | Validate code quality: auto-fix formatting/lint, verify types, run tests |
| `write-a-skill` | Create new agent skills with proper structure |
| `zoom-out` | Go up a layer of abstraction — map relevant modules and callers |

## Structure

Each skill is a self-contained directory:

- `SKILL.md` — entry point: frontmatter, workflow, rules, error handling
- `references/` — deep, skill-specific material loaded on demand (optional)
- `scripts/` — executable helpers a skill invokes (optional)

## License

[MIT](LICENSE) © Helder Burato Berto
