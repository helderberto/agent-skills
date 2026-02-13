# Agent Skills

Personal collection of Claude Code agent skills - centralized repository for development workflows.

## About

Skills are managed using the [skills CLI](https://www.npmjs.com/package/skills) - a tool for installing and managing reusable AI agent capabilities.

**Philosophy:** Skills are centralized in this repository and consumed via GitHub, not duplicated across projects.

## Installation

Install from GitHub (recommended):
```bash
npx skills add helderberto/skills --agent claude-code --all
```

Install specific skill:
```bash
npx skills add helderberto/skills --agent claude-code --skill commit
```

List available skills:
```bash
npx skills add helderberto/skills --list
```

## Managing Skills

List installed skills:
```bash
npx skills list
```

Update to latest version:
```bash
npx skills remove --all -y
npx skills add helderberto/skills --agent claude-code --all
```

## Development

When developing skills locally:
```bash
cd ~/workspace/labs/skills
npx skills add . --agent claude-code --all
```

This installs from the local repository for testing before pushing.

## Structure

Each skill is a directory containing:
- `SKILL.md` - Main instructions (keep under 50 lines)
- Reference files - For progressive disclosure (patterns, examples, templates)
- `scripts/` - Executable helpers (when needed)

Skills follow progressive disclosure: core workflow in SKILL.md, details in supporting files.
