# Agent Skills

Personal collection of Claude Code agent skills.

## About

Skills are managed using the [skills CLI](https://www.npmjs.com/package/skills) - a tool for installing and managing reusable AI agent capabilities.

## Installation

Install all skills:
```bash
npx skills add helderberto/skills
```

Install specific skill:
```bash
npx skills add helderberto/skills --skill commit
```

Install for specific agent:
```bash
npx skills add helderberto/skills --agent claude-code
```

List available skills before installing:
```bash
npx skills add helderberto/skills --list
```

## Managing Skills

List installed skills:
```bash
npx skills list
```

Update skills to latest version:
```bash
# Remove old versions and reinstall
npx skills remove --all -y
npx skills add helderberto/skills --agent claude-code --all
```

Remove skills:
```bash
npx skills remove --all -y
```

## Structure

Each skill is a directory containing a `SKILL.md` file with instructions for Claude Code. Complex skills include reference files for progressive disclosure.
