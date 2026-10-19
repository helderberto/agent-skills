# Quality Axes

Review every changed file, not just the latest commit. Read the tests first.

## Approval standard

Approve when the change definitely improves overall code health, even if it isn't perfect. Don't block a change because it isn't how you would have written it. If it improves the codebase and follows its conventions, approve.

Too large to review well (~1000+ changed lines) → asking for a split is a valid outcome. Suggest a strategy: stack (small change, next one based on it), by file group, horizontal (shared code first, then consumers), or vertical (one end-to-end slice per PR). A refactor mixed with new behavior is two changes.

## 1. Correctness

- Logic bugs, off-by-ones, race conditions, unhandled states, missing error paths
- Edge cases: null, empty, boundary values, repeated or out-of-order calls
- Tests: do they test behavior, cover the edge cases, and catch a regression? Branch checked out → answer the last one by experiment: in a scratch copy under `$TMPDIR`, invert one condition the change adds and run its tests. Still green → name the missing test. Skip when `test-auditor` runs alongside: it already runs mutants.

## 2. Readability & simplicity

- Names that don't reveal what a thing does or holds
- Functions > 50 lines, nesting > 2 levels, clever tricks, nested ternaries
- Dead code, unused imports, no-op variables, `// removed` comments, compat shims
- Could this be fewer lines? Does each abstraction earn its complexity?
- A new conditional bolted onto an unrelated flow: a design smell, not a nit

## 3. Architecture

- Follows existing patterns, or introduces a new one with a reason
- A near-duplicate of a canonical helper; feature logic leaking into a shared module
- Dependencies flow the right way, no cycles
- Reduces complexity, or only relocates it? Prefer deleting an abstraction to polishing it.
- Type boundaries: `any`, unjustified assertions, silent fallbacks over an unclear invariant; in-place mutation of shared data

## 4. Security

- Exposed secrets, in code or logs
- External data (input, APIs, files, LLM output) used unvalidated
- Missing authn/authz, string-built SQL, unencoded output

A deep trust-boundary pass is `harden`'s job.

## 5. Performance

- N+1 queries, unbounded loops or fetches, missing pagination
- O(n²) where O(n) works, large allocations in hot paths
- Unnecessary re-renders

## Dependency upgrades

Manifest or lockfile in the diff: one dependency per change, since a bulk bump that breaks hides which package did it. Verify against the changelog, not the version number. Review the lockfile diff: one direct bump pulls dozens of transitive changes. Flag hand-edited lockfiles.

## Smells

Match the diff against [smells.md](smells.md). The repo's documented style overrides it.

## Structural remedies

Flag a structural problem with the move, not just the problem:

- Conditional chain → typed model or explicit dispatcher
- Duplicate branches → one clearer flow
- Orchestration tangled with business logic → separate them
- Feature logic in a shared module → move it to its owner
- Bespoke near-duplicate → the canonical helper
- Pass-through wrapper → delete it
- Large function or file → extract, split

Prefer the remedy that removes moving pieces over one that spreads them around.
