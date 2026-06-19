---
name: create-adr
description: Record an Architecture Decision Record (ADR) — a 1–3 sentence note capturing what was decided and why. Use when user says "create an ADR", "record this decision", "/create-adr", or just decided something architecturally significant. Don't use for forward-looking specs (use hb:prd) or general repo conventions (use CLAUDE.md).
---

# Create ADR

Capture architectural decisions as durable, minimal records future-you (and future-Claude) can read instead of guessing from code.

## Gate — write an ADR only if all three are true

1. **Hard to reverse** — changing your mind later costs meaningful effort (migration, rewrite, vendor lock-in).
2. **Surprising without context** — a future reader will look at the code and wonder "why did they do it this way?"
3. **Real trade-off** — there were genuine alternatives, and you picked one for specific reasons.

If any criterion is missing, **say so and skip the ADR.** Easy-to-reverse decisions get reversed; obvious decisions don't need recording; non-decisions ("we did the only thing that worked") aren't ADRs.

Cheap rejections prevent ADR sprawl. When in doubt, refuse and ask the user to confirm the decision really meets all three.

## What qualifies

- **Architectural shape** — "monorepo," "event-sourced write model + projected read model"
- **Integration patterns between modules/contexts** — "Ordering and Billing communicate via events, not synchronous HTTP"
- **Technology choices with lock-in** — database, message bus, auth provider, deployment target. Not every library — only ones that take a quarter to swap.
- **Boundary and ownership decisions** — "Customer data is owned by Customer; other contexts reference by ID."
- **Deliberate deviations from the obvious path** — "manual SQL instead of an ORM because X." Stops the next engineer "fixing" a deliberate choice.
- **Constraints not visible in code** — "no AWS due to compliance," "must respond <200ms due to partner SLA."
- **Rejected alternatives when the rejection is non-obvious** — considered GraphQL, picked REST for subtle reasons. Otherwise someone re-suggests it in six months.

## Workflow

### 1. Verify the gate

Restate the decision in one sentence. Check it against all three criteria explicitly. If it fails, tell the user which criterion failed and stop.

### 2. Locate `docs/adr/`

- If `docs/adr/` exists, scan for the highest `NNNN-*.md` filename and increment.
- If it doesn't exist, create it lazily — only now that there's something to write.
- Numbering: zero-padded 4 digits (`0001`, `0002`, …).

### 3. Draft

Write `docs/adr/NNNN-<kebab-slug>.md` using the template below. Slug should be short and search-friendly (`postgres-for-write-model`, not `decision-about-database-choice`).

```md
# {Short title of the decision}

{1–3 sentences: context, what was decided, and why.}
```

That's it. **An ADR can be a single paragraph.** The value is recording *that* a decision was made and *why* — not filling out sections.

### 4. Optional sections — include only when they add genuine value

Most ADRs won't need any of these.

- **Status frontmatter** (`proposed | accepted | deprecated | superseded by ADR-NNNN`) — useful when decisions get revisited.
- **Considered Options** — only when rejected alternatives are worth remembering (e.g., "considered GraphQL" so it doesn't get re-suggested).
- **Consequences** — only when non-obvious downstream effects need calling out.

### 5. Show the user

Print the file path and the rendered content. Don't auto-commit — let the user stage it (matches their git rules).

## Rules

- Never write an ADR that fails the gate. Refuse and say which criterion failed.
- Never create `docs/adr/` until you have a real ADR to put in it (lazy creation).
- Never use `git add` here — the user stages explicitly.
- Title is the decision, not the question. "Use Postgres for write model" — not "Which database for write model?"
- Sentences should be tight and present-tense. No hedging, no "we are considering."
- ADR ≠ PRD. If the work is forward-looking (specs, plans, user stories), redirect to `/prd`.
- ADR ≠ CLAUDE.md. If it's a repo convention, gotcha, or general rule, redirect to `learn`/`learner`.

## Example

✅ Good — passes gate:

> # 0003 — Manual SQL instead of an ORM
>
> The query patterns are write-heavy and join-shaped in ways ORMs handle poorly; we hit perf cliffs in the spike. We accept the boilerplate cost in exchange for predictable plans and explicit transactions. Considered Prisma and Drizzle.

❌ Reject — fails "hard to reverse":

> "We decided to use Prettier for formatting."

Reversible in one PR. Not an ADR — that's a `.prettierrc` and maybe a line in CLAUDE.md.

❌ Reject — fails "surprising without context":

> "We decided to write tests."

Nobody will wonder why.
