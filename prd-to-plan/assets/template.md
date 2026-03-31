# Plan Template

Use this template when writing `plans/<name>.md`. Replace all `<placeholder>` values with content derived from the PRD.

---

```markdown
# <Feature Name>

> Source PRD: `prds/<name>.md`
> Phase strategy: <layer-by-layer | vertical-slice | inferred>
> Generated: <YYYY-MM-DD>

## Summary

<1–2 sentences: what is being built and how many phases it takes.>

---

## Phase 1 — <Goal>

**Goal:** <One sentence: what this phase delivers and why it must come first.>

### Tasks

- [ ] <Verb> <specific deliverable derived from PRD>
- [ ] <Verb> <specific deliverable derived from PRD>

### Done when

<A specific, testable condition. Example: "Schema migrations run cleanly and all service unit tests pass.">

---

## Phase 2 — <Goal>

**Goal:** <One sentence. Note which Phase 1 deliverable this depends on.>

### Tasks

- [ ] <Verb> <specific deliverable>
- [ ] <Verb> <specific deliverable>

### Done when

<Testable condition.>

---

## Phase N — <Goal>

**Goal:** <Final phase typically covers integration, UI wiring, and non-happy-path coverage.>

### Tasks

- [ ] <Verb> <specific deliverable>
- [ ] <Verb> <specific deliverable>

### Done when

<The last phase's done-when should confirm all PRD User Stories are exercisable end-to-end.>

---

## Out of Scope

<Carry the PRD's Out of Scope section forward verbatim. Do not add to it.>

## Open Questions

<Any gaps found in the PRD that need resolution before or during implementation. Leave blank if none.>
```

---

## Phase Count Guidelines

- 2–3 phases: small feature, single module
- 3–5 phases: multi-module feature with schema changes
- 5+ phases: large feature — consider splitting the PRD first
