---
name: deprecate
description: Manage deprecation and migration of old systems, APIs, or features. Use when removing legacy code, sunsetting features, consolidating duplicate implementations, or planning the lifecycle of a new system. Don't use for one-off refactors (use `refactor-plan`), in-flight code simplification, or removing dead code with zero callers (just delete it).
---

# Deprecate

Code is a liability, not an asset. Every line carries ongoing cost: tests, docs, security patches, dependency updates, mental overhead. Deprecation is the discipline of removing code that no longer earns its keep. Migration is the process of moving users safely from the old to the new.

Most teams build well, few remove well. This skill addresses the gap.

## Core Principles

### Code is a liability

Functionality has value; code has cost. When the same functionality can be provided with less code or better abstractions, the old code should go.

### Hyrum's Law makes removal hard

With enough users, every observable behavior becomes depended on — including bugs, timing quirks, and undocumented side effects. Deprecation requires **active migration**, not just announcement. Users can't "just switch" when they depend on behaviors the replacement doesn't replicate.

### Plan deprecation at design time

When building something new, ask: "How would we remove this in 3 years?" Clean interfaces, feature flags, and minimal surface area are easier to deprecate.

## The deprecation decision

Before deprecating anything:

```
1. Does this system still provide unique value?
   → Yes: maintain it. No: proceed.

2. How many users/consumers depend on it?
   → Quantify the migration scope. If unknown, find out before announcing.

3. Does a replacement exist?
   → No: build the replacement first. Never deprecate without an alternative.

4. Who owns the deprecation?
   → Without a named owner, deprecations stall indefinitely.

5. What is the timeline?
   → Open-ended deprecations never finish. Pick a date.
```

## Migration phases

### Phase 1 — Announce

- Document the deprecation: what, why, replacement, timeline
- Mark the deprecated surface in code (`@deprecated` JSDoc, runtime warning, etc.)
- Notify consumers (changelog, docs banner, direct comms for known integrators)
- Provide a migration guide with concrete before/after examples

### Phase 2 — Migrate

- Track migration progress with a concrete metric (call sites converted, users moved, traffic shifted)
- Help consumers migrate: PRs into their code, office hours, pair sessions
- Block new usage of the deprecated path (lint rule, CI check, runtime warning escalating to error in non-production)

### Phase 3 — Remove

- Verify zero callers / zero traffic / zero users on the old path
- Remove the code in a single PR that ONLY removes (no behavioral changes in same commit)
- Update docs and changelog with removal date

### Phase 4 — Postmortem (optional)

- What did we learn about how the system got used?
- How would the next deprecation go faster?

## When to maintain vs. migrate

| Signal | Suggests |
|--------|----------|
| Replacement exists and is mature | Migrate |
| Old system has acute pain (security CVEs, perf cliff, can't hire for it) | Migrate urgently |
| Old system works, new system speculative | Maintain — don't migrate for novelty |
| Migration cost > 5x maintenance cost | Maintain unless strategic reason |
| Single consumer, can be coordinated 1:1 | Migrate, low ceremony |
| Many consumers, behaviors leaked | Migrate carefully, long timeline |

## Anti-patterns

- **Deprecate without replacement**: forces users to find their own alternative; they won't migrate
- **Open-ended timeline**: "deprecated, will be removed eventually" — never gets removed
- **Silent removal**: breaks consumers who never saw the warning
- **Removal in a behavior-change PR**: makes blame harder, makes reverts harder
- **Hyrum-blind announcement**: assumes consumers will migrate without knowing what they actually depend on

## Rules

- Never deprecate without a replacement that exists and is mature
- Always name an owner with end-to-end responsibility
- Always pick a removal date — open-ended deprecations stall
- Block new usage of the deprecated path during migration (lint rule, runtime warning)
- Remove in a dedicated PR with no behavioral changes mixed in
- Record migration progress with a concrete metric, not vibes

## Red flags

- "We'll deprecate this someday" — without a date, never
- "Just remove it, no one uses it" — without measurement, assumption
- Multiple "deprecated since v1.x" markers in code with v3.x shipped
- Replacement is "almost ready" — it's not. Don't announce.
- No migration guide — consumers can't follow even if they want to

## Verification

After completing a deprecation:

- [ ] Replacement is documented, used internally, and stable
- [ ] Owner named, timeline set
- [ ] Consumers notified (changelog, banner, direct comms for known integrators)
- [ ] Migration guide with before/after exists
- [ ] New usage blocked (lint rule or runtime warning)
- [ ] Migration progress metric is moving toward zero
- [ ] Removal PR has zero behavioral changes
