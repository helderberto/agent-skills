---
name: doubt-driven-development
description: Subject every non-trivial decision to a fresh-context adversarial review before it stands. Use when correctness matters more than speed, when working in unfamiliar code, when stakes are high (production, security-sensitive logic, irreversible operations), or any time a confident output would be cheaper to verify now than to debug later. Don't use for mechanical operations (renames, formatting), one-line changes with obvious correctness, or when the user has explicitly asked for speed over verification.
---

# Doubt-Driven Development

A confident answer is not a correct one. Long sessions accumulate context that quietly turns assumptions into "facts" without anyone noticing. Doubt-driven development is the discipline of materializing a fresh-context reviewer — biased to **disprove**, not approve — before any non-trivial output stands.

This is **not** `code-review` or `review`. Those are verdicts on finished artifacts. Doubt-driven is an **in-flight posture**: non-trivial decisions get cross-examined while course-correction is still cheap.

## When a decision is "non-trivial"

At least one of these holds:

- Introduces or modifies branching logic
- Crosses a module or service boundary
- Asserts a property the type system or compiler cannot verify (thread safety, idempotence, ordering, invariants)
- Correctness depends on context the future reader cannot see
- Blast radius is irreversible (production deploy, data migration, public API change)

Apply when:

- About to make an architectural decision under uncertainty
- About to commit non-trivial code
- About to claim a non-obvious fact ("this is safe", "this scales", "this matches the spec")
- Working in code you don't fully understand

## The 5-step process

### 1. ARTIFACT

Write down precisely what was decided / will be done. One paragraph. Concrete enough that a stranger could implement it.

### 2. CONTRACT

State the property the artifact must satisfy. Invariants, edge cases, error modes. What must remain true if this is correct?

### 3. DOUBT

Spawn a **fresh-context reviewer** whose only job is to disprove the artifact against the contract. The reviewer:

- Has not seen any prior reasoning in this session
- Receives only ARTIFACT + CONTRACT
- Tries to find counterexamples, edge cases, hidden coupling, false assumptions
- Outputs a verdict: HOLDS or BREAKS (with specific failure)

In Claude Code, this means spawning a subagent (e.g., `general-purpose` or `junior-engineer`) with a self-contained prompt. The reviewer must NOT inherit the orchestrator's confidence.

### 4. RECONCILE

If reviewer returns HOLDS → proceed.
If reviewer returns BREAKS → either:
- Fix the artifact to address the break, then loop back to step 3
- Demonstrate the break is non-applicable (write down why)
- Escalate to the human if the break reveals genuine ambiguity

### 5. STAND

Only after RECONCILE produces a clean HOLDS does the decision stand. Record the HOLDS in a code comment, ADR, or commit message when the property is non-obvious.

## When NOT to apply (avoid analysis paralysis)

- Mechanical operations: renames, formatting, file moves
- Clear, unambiguous user instruction with no ambiguity
- Reading or summarizing existing code
- One-line changes with obvious correctness
- Pure tooling operations (running tests, listing files)
- The user has explicitly asked for speed over verification

If you doubt every keystroke, you ship nothing. This is a tool for **non-trivial decisions only**.

## Spawning the reviewer

The reviewer prompt must be self-contained — it has no memory of this session:

```
ARTIFACT:
<paste the one-paragraph description>

CONTRACT:
<paste invariants and edge cases>

Your job: disprove the artifact against the contract. Find a counterexample,
hidden coupling, false assumption, or edge case the artifact doesn't handle.
Output one of:
- HOLDS — explain why every invariant is preserved
- BREAKS — give the specific scenario that breaks it

Do not approve out of politeness. Find the flaw.
```

## Loading constraints

Do **not** add this skill to a subagent persona's frontmatter. A persona that follows step 3 would spawn another persona — anti-pattern. Doubt-driven runs in the **main session** that has spawn authority.

If applied from inside a subagent (where nested spawn is blocked): flag to the user that doubt-driven needs main-session authority and let them handle it. As a degraded fallback only: rewrite ARTIFACT + CONTRACT as a fresh self-prompt with a hard mental separator from prior reasoning. Flag the result as degraded — it's not fresh-context review, you carry your own context with you.

## Rules

- Apply only to non-trivial decisions (definition above)
- Reviewer must have fresh context — no inherited reasoning
- Reviewer is biased to disprove, not approve
- BREAKS findings either fix the artifact or get explicitly dismissed with a recorded reason
- Record non-obvious HOLDS as a comment / ADR / commit message
- Never silent-approve when the reviewer has not actually run

## Red flags

- Skipping the reviewer because "it's probably fine"
- Reviewer agreeing too easily — prompt may be leaking confidence
- Re-running with a different prompt until HOLDS appears (cherry-picking)
- Applying to trivial work (creates ceremony, not safety)

## Verification

After standing a non-trivial decision:

- [ ] ARTIFACT written explicitly
- [ ] CONTRACT enumerates invariants and edge cases
- [ ] Fresh-context reviewer ran and returned HOLDS
- [ ] If HOLDS was non-obvious, it's recorded somewhere the future reader will find
