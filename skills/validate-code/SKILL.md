---
name: validate-code
description: "Validate code quality: auto-fix formatting/lint, verify types, run tests. Use when user asks to \"validate code\", \"/validate-code\", \"check code\", or wants to validate before committing. Don't use for committing, pushing, or writing new tests."
---

# Validate Code

Run the project's own quality gates — format/lint fix, type check, tests — whatever this project defines. Detect the toolchain; never assume npm.

## Workflow

1. **Detect the project's commands.** Prefer a task the project already defines over a raw tool call:
   - Node → `package.json` scripts (`lint:fix`/`lint-fix`, `lint`, `typecheck`/`tsc`, `test`)
   - Python → `pyproject.toml` / `tox.ini` / `Makefile` (`ruff --fix`/`black`, `ruff`/`flake8`, `mypy`, `pytest`)
   - Go → `gofmt -w`, `go vet`, `go build ./...`, `go test ./...`
   - Rust → `cargo fmt`, `cargo clippy`, `cargo check`, `cargo test`
   - else → read the `Makefile` / CI config for the equivalent targets
2. **Format + lint fix** (the fix variant). These rewrite files in place and exit 0 silently — capture what changed right after (`git status --short` / `git diff --stat`) and remember it for the report. The user is about to commit; they need to know their tree was modified.
3. **Lint + types** (check variants).
4. **Tests.**
5. Report: an **Auto-fixed** section listing files the fix step changed (or "nothing auto-fixed"), then overall **PASS** or **FAIL** with `file:line` error references.

## Rules

- Detect the project's commands — never hardcode a package manager
- Always auto-fix before reporting errors — but never modify files silently; always report which files auto-fix changed
- Run fix → check → test sequentially
- If the fix step fails, still run check + tests; report all failures at the end
- Report errors as `file:line` references
- Never commit, stage, or push anything

## Error Handling

- If no recognizable manifest/tasks → ask the user for the validate command, or report and stop
- If a step's command doesn't exist → skip it, note it was skipped
- If all steps missing → report nothing to run, stop
- If tests time out → report and suggest raising the runner's timeout
- If a runner crashes (exit code other than 0 or 1) → report crash output and stop
