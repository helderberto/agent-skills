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
| `checks` | Pre-commit quality gate: auto-fix formatting/lint, verify types, run tests |
| `code-review` | Review a GitHub PR for bugs, security, performance, and code quality |
| `commit` | Create git commits following repository style |
| `coverage` | Check test coverage for unstaged changes |
| `create-pull-request` | Create GitHub pull requests |
| `deps-audit` | Check dependencies for vulnerabilities (npm only) |
| `e2e` | Write end-to-end tests for user flows using Cypress |
| `explain-code` | Explain code with visual diagrams and analogies |
| `grill-me` | Stress-test a plan or design through relentless interview |
| `i18n` | Audit internationalization coverage, find hardcoded strings |
| `lint` | Run linting and formatting checks |
| `perf-audit` | Audit frontend bundle size and performance |
| `prose-fix` | Fix formatting, typos, and clarity issues in markdown and text files |
| `refactor-plan` | Create structured refactoring plans |
| `safe-repo` | Check for sensitive data in repository |
| `ship` | Commit and push changes using atomic commits |
| `tdd` | Guide test-driven development with red-green-refactor loop |
| `write-a-skill` | Create new agent skills with proper structure |

## Structure

Each skill is a directory containing:
- `SKILL.md` - Main instructions (keep under 50 lines)
- Reference files - For progressive disclosure (patterns, examples, templates)
- `scripts/` - Executable helpers (when needed)

Skills follow progressive disclosure: core workflow in SKILL.md, details in supporting files.

## License

[MIT](LICENSE) © Helder Burato Berto
