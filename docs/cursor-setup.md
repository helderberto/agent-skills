# Using helderberto/agent-skills with Cursor

Cursor doesn't have a native skill system, but it loads Markdown rules from `.cursor/rules/` or `.cursorrules`. Skills are plain Markdown, so they work as Cursor rules with minor adaptation.

## Setup

### Option 1: Rules directory (recommended)

```bash
# In your project root
mkdir -p .cursor/rules

# Copy the skills you want to load as rules
cp /path/to/agent-skills/skills/tdd/SKILL.md .cursor/rules/tdd.md
cp /path/to/agent-skills/skills/code-review/SKILL.md .cursor/rules/code-review.md
cp /path/to/agent-skills/skills/commit/SKILL.md .cursor/rules/commit.md
```

Cursor auto-loads everything in `.cursor/rules/` into its context.

### Option 2: Single `.cursorrules` file

For projects that prefer one consolidated rules file:

```bash
{
  cat /path/to/agent-skills/skills/tdd/SKILL.md
  echo "\n---\n"
  cat /path/to/agent-skills/skills/code-review/SKILL.md
} > .cursorrules
```

## Recommended starter set

The skills below cover the most common moments where Cursor benefits from explicit guidance:

| Skill            | Why it helps in Cursor                                  |
| ---------------- | ------------------------------------------------------- |
| `tdd`            | Forces red-green-refactor for new features and bugs     |
| `code-review`    | Five-axis review framework for diffs                    |
| `commit`         | Repository-style commit messages, conventional commits  |
| `diagnose`       | Disciplined debugging loop for hard bugs                |
| `source-driven`  | Forces use of official docs over training data          |
| `architecture-audit` | Surfaces friction toward deep modules               |

## Workflow-style skills (tracer-bullet flow)

If you want the full define → plan → build → verify loop in Cursor:

```bash
cp /path/to/agent-skills/skills/prd/SKILL.md   .cursor/rules/prd.md
cp /path/to/agent-skills/skills/plan/SKILL.md  .cursor/rules/plan.md
cp /path/to/agent-skills/skills/build/SKILL.md .cursor/rules/build.md
cp /path/to/agent-skills/skills/check/SKILL.md .cursor/rules/check.md
cp /path/to/agent-skills/skills/brief/SKILL.md .cursor/rules/brief.md
```

Cursor will then route prompts like "plan the dark mode feature" or "build the next phase" through these rules automatically.

## Limitations

- Cursor does not support slash-style invocation (e.g., `/hb:prd`). Reference skills by name in prompts: "use the prd skill to ...".
- Rules can grow Cursor's context fast. Load only the skills you actively need per project rather than the entire set.
- Cursor does not auto-detect when a skill applies. State the skill in your prompt explicitly.

## Updating

Rules are file copies, not symlinks. To refresh, re-copy the relevant SKILL.md files.
