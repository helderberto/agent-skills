# Workflow

## Example: full SDLC walkthrough

A non-trivial feature flows through every step. Each command is one invocation:

```
You: /hb:triage add dark mode support
AI:  L, fuzzy feature → /hb:grill dark mode

You: /hb:grill dark mode
AI:  Interviews you in rounds; writes settled terms to the glossary and ADRs inline.
     Next: /hb:to-spec dark-mode

You: /hb:to-spec dark-mode
AI:  Writes .specs/specs/dark-mode.md from the conversation, no re-interview.
     Next: /hb:to-tickets dark-mode

You: /hb:to-tickets dark-mode
AI:  Slices the spec into tracer-bullet tickets with blocking edges.

You: /hb:build dark-mode
AI:  Implements the next unblocked ticket test-first via tdd, then lint and
     type-check. Marks checkboxes, commits.
     /hb:build dark-mode --all fans the tickets out to parallel subagents,
     frontier by frontier, after one approval.

You: /hb:review
AI:  Fans out reviewers in parallel (correctness, standards, spec + checkboxes,
     tests + coverage, quality bar, a11y-audit, safe-repo, ...).
     Consolidates findings into Critical / Important / Suggestion.

You: /hb:to-pr
AI:  Gate (check, ADR check), push, writes the PR body itself (Summary visual,
     Before/After evidence, merge danger), gh pr create, then watches CI.

You: /hb:retro
AI:  Suggests environment fixes from this session: pointers, checks, standards.
```

For quick standalone tasks, you don't need the flow — describe what you want and the relevant skill triggers ("write tests for X", "audit deps", "create an ADR for Y").

## Artifact convention

Workflow skills write structured artifacts to `.specs/`:

- `.specs/specs/<slug>.md` — specs from `/hb:to-spec`
- `.specs/tickets/<slug>.md` — tracer-bullet tickets from `/hb:to-tickets`
- `.specs/research/<slug>.md` — cited findings from `/hb:research`, when the repo has no notes convention of its own

The `.specs/` directory is local-first. Add it to `.gitignore` if you prefer specs as scratch space, or commit it if you want specs as versioned project documentation.

Throwaway output stays out of the working tree, so `commit` never sweeps it up: `visual-review` and `architecture-audit --html` reports, `perf-audit` bundle reports, and `handoff` docs go to `$TMPDIR` (else `/tmp`), and the skill prints the path.
