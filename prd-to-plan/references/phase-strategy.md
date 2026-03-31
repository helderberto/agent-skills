# Phase Strategy

Use this reference in Step 3 to choose a strategy and map PRD content to phases.

## The Three Strategies

### Layer-by-layer (default)

Build one horizontal layer before the next.

**Phase order:**
1. Data layer — schema migrations, seed data
2. Service layer — business logic modules from PRD's New Modules section
3. API layer — routes/endpoints from PRD's API Contracts section
4. UI layer — components and navigation from PRD's Navigation section
5. Polish — error states, edge cases, accessibility

**When to recommend:** PRD has schema changes + new service modules + new API routes (all three layers are non-trivial).

**Signal phrases:** "New Modules" lists 2+ modules; "Schema Changes" adds new tables; "API Contracts" defines new routes.

---

### Vertical slice

Each phase delivers one complete user-visible feature end-to-end.

**Phase order:**
1. Slice for the most critical User Story (data + service + API + minimal UI)
2. Next story, reusing Phase 1 infrastructure
3. ...N. Polish: cross-cutting concerns, error states, remaining stories

**When to recommend:** PRD User Stories are independent, schema changes are additive (no rewrites), team wants releasable increments.

**Signal phrases:** Stories describe distinct surfaces ("overview page" vs "detail page") or PRD explicitly mentions multiple views.

---

### Inferred

Follow the dependency order implied by the PRD's Architectural Decisions section.

**When to recommend:** PRD has unusually detailed architectural decisions, or there is an obvious bootstrapping constraint (e.g., auth must exist before anything else).

**How to apply:** Extract sequencing clues from phrases like "depends on", "requires", "before", "must exist first".

---

## Mapping PRD Sections to Tasks

| PRD Section | Task pattern |
|---|---|
| New Modules | `Implement <ModuleName> with <interface>` |
| Schema Changes | `Write and test migration for <table/column>` |
| API Contracts | `Implement <METHOD> <route> returning <shape>` |
| Navigation | `Wire <Component> to <route>` |
| User Stories | Verify every story is covered; add a task if not |
| Testing Decisions | `Write tests for <module/behavior>` in the phase where that module lands |
| Out of Scope | Do not create tasks for these |

## Dependency Rules

Order phases so that:
1. Schema changes precede service layer (services depend on schema)
2. Service layer precedes API layer (routes call services)
3. API layer precedes UI layer (UI calls API)
4. Happy paths precede error/edge-case tasks within any phase

In vertical-slice strategy, compress these into per-slice mini-sequences rather than global layers.

## Phase Naming

Use a short goal phrase, not a layer name.

Good: `Phase 1 — Data foundation: schema and migrations`
Avoid: `Phase 1 — Backend`

A good phase name answers: "what can we demo or verify when this phase is done?"
