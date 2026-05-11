# Contributing

Thanks for considering a contribution. This plugin is a personal toolbelt, but PRs that add value to a general audience are welcome.

## What kind of contributions fit

- **New skills** that fill a real gap in the SDLC coverage
- **Improvements** to existing skills (tighter descriptions, clearer workflows, missing error cases)
- **Fixes** for broken links, typos, or factual errors in skill content
- **Multi-agent setup docs** beyond the four already covered (Claude Code, Gemini CLI, OpenCode, Cursor)

## What does NOT fit

- Skills that duplicate an existing one with a different name
- Skills tied to a single project's setup (those belong in the project, not here)
- Skills that depend on private services or paid tools without an open alternative
- Sweeping refactors of skills the maintainer hasn't asked for

When in doubt, open an issue first to discuss scope.

## Workflow

1. **Fork** the repo and create a feature branch from `main`:
   ```bash
   git checkout -b <type>/<short-description>
   ```
   Branch name examples: `feat/visual-validate`, `fix/safe-repo-diff`, `docs/cursor-setup`.

2. **Read [`docs/skill-anatomy.md`](docs/skill-anatomy.md)** if you're adding or modifying a skill. It covers directory layout, frontmatter rules, description writing, and the authoring checklist.

3. **Scaffold a new skill** using the `write-a-skill` skill itself (interactive walkthrough), or copy an existing skill's structure as a template.

4. **Run the authoring checklist** from `docs/skill-anatomy.md` before opening the PR.

5. **Commit** with [Conventional Commits](https://www.conventionalcommits.org/):
   - `feat(<skill>): add ...` — new skill or new behavior
   - `fix(<skill>): ...` — bug fix
   - `docs: ...` — README or docs/
   - `chore: ...` — gitignore, plugin manifest, structural

6. **Open a PR against `main`** with:
   - One-line summary in the title
   - "What changed" + "Why" in the body
   - Test plan (how to verify) — even one bullet is fine

## Conventions

- **English only** for all written artifacts (code, comments, commits, PR titles/bodies, ADRs, docs)
- **Skill names** are lowercase kebab-case: `code-review`, `safe-repo`
- **Workflow skills** (`prd`, `plan`, `build`, `check`, `review`, `ship`) are invoked as `/hb:<name>`
- **Toolbelt skills** auto-trigger from the `description` field — write that carefully
- **Don't add** `compatibility:` or `allowed-tools:` to frontmatter (legacy `npx skills` CLI fields, not part of the plugin spec)

## Where to start

| You want to... | Read this |
|----------------|-----------|
| Understand the plugin structure | [README.md](README.md) |
| Write a new skill from scratch | [docs/skill-anatomy.md](docs/skill-anatomy.md) |
| Scaffold a skill interactively | Invoke `/hb:write-a-skill` |
| Configure another agent | [`docs/cursor-setup.md`](docs/cursor-setup.md), [`docs/gemini-cli-setup.md`](docs/gemini-cli-setup.md), [`docs/opencode-setup.md`](docs/opencode-setup.md) |
| Question scope before coding | Open an issue |

## License

By contributing, you agree your work will be licensed under the [MIT License](LICENSE).
