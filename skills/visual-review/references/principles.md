# Review Lens

The principles each hunk is checked against. Each has a **signal** (what to spot in the diff), a **why** (the reasoning to render in the card — teach, don't just judge), and a `before → after` where the fix is concrete. Tag every finding with one principle name so the HTML can group and colour them.

Severity: **must-fix** (breaks a hard rule below) · **consider** (better but not blocking) · **praise** (a pattern worth reinforcing).

Scope: design and simplification — readability, simplification, SOLID and design principles, testability, reusability, maintainability. Correctness, security, and scope/claim mismatches belong to [`code-review`](../../code-review/SKILL.md) — don't grow this lens toward them.

## Unnecessary memoization

**Signal**: `useMemo` / `useCallback` / `React.memo` wrapping a cheap computation, a value with no stable-reference consumer, or a dependency array that changes every render anyway.

**Why**: memoization trades memory and a dependency array for skipped work. It only pays off when the wrapped work is expensive *and* the reference is consumed by a memoized child or an effect dependency. Guarding a `.map` over ten items, or a callback passed to a plain DOM handler, adds cognitive load and a stale-closure risk for no measurable gain.

```jsx
// before
const total = useMemo(() => items.reduce((a, b) => a + b.price, 0), [items]);
const onClick = useCallback(() => setOpen(true), []);
// after — the sum is trivial; the handler has no memoized consumer
const total = items.reduce((a, b) => a + b.price, 0);
const onClick = () => setOpen(true);
```

## Speculative abstraction

**Signal**: a layer, config flag, generic parameter, or option object introduced for a single caller; "just in case" flexibility that wasn't requested.

**Why**: abstractions cost a reader an indirection hop every time. One caller doesn't justify one. Inline it until a second caller proves the seam; the duplication is cheaper than the wrong abstraction.

## Mutation

**Signal**: `push` / `splice` / `sort` / `reverse` / `arr[i] =` / `obj.key =` / `delete obj.key` on a value that outlives the function or feeds React state.

**Why**: shared mutation makes state changes non-local — a bug becomes "who touched this?" across the whole call graph. Immutable updates keep the change traceable to one expression and let React's referential equality do its job.

```js
// before
items.sort((a, b) => a.order - b.order);
// after
const sorted = [...items].sort((a, b) => a.order - b.order);
```

## Nesting

**Signal**: more than two levels of indentation; nested `if`s; a happy path buried under conditionals.

**Why**: each level is a condition the reader holds in working memory. Guard clauses that return early flatten the branches and put the main path at the left margin where it's read first.

## Naming

**Signal**: `data`, `tmp`, `handleThing`, abbreviations, a boolean not phrased as a predicate, a function name that doesn't say what it returns.

**Why**: the name is the interface. A precise name (`pendingInvoices`, `isEligible`) removes a trip to the definition; a vague one makes every call site ambiguous.

## Dead weight

**Signal**: unreachable branches, commented-out code, unused imports/vars, error handling for impossible states, a comment restating the line below it.

**Why**: every line is read even when it does nothing. Dead code implies intent that isn't there and rots silently. Delete it — git remembers.

## Duplication

**Signal**: the same logic or literal in two hunks of the diff.

**Why**: two copies drift. Extract only when the shared meaning is genuinely one thing (not two that look alike today) — otherwise a premature helper couples unrelated callers.

## Single responsibility (SRP)

**Signal**: a function or module that fetches *and* transforms *and* renders; a name with "and" in it; a change to one concern forcing edits to unrelated lines in the same unit.

**Why**: a unit with one reason to change is the one you can test in isolation and reuse elsewhere. Mixed responsibilities mean every test has to stand up the whole world, and every reuse drags along concerns the caller didn't want.

```js
// before — parses, validates, and persists in one function
function saveUser(raw) {
  const user = JSON.parse(raw);
  if (!user.email.includes("@")) throw new Error("bad email");
  db.insert(user);
}
// after — three units, each testable alone
const parseUser = (raw) => JSON.parse(raw);
const validateUser = (user) => user.email.includes("@");
const saveUser = (user) => db.insert(user);
```

## Dependency inversion & seams (DIP)

**Signal**: a concrete dependency hard-wired inside a unit — `new Client()` in the body, a direct import of a singleton, `Date.now()`/`fetch`/`fs` called inline — with no way for a caller (or a test) to substitute it.

**Why**: depending on a concrete collaborator welds the unit to it. Passing the collaborator in (a parameter, a small interface) inverts the dependency: the unit now states what it needs, the caller decides what to supply, and a test supplies a fake. This is the single biggest lever on testability.

```js
// before — untestable without a real clock and network
function expiry() { return Date.now() + 3600_000; }
// after — the seam makes it deterministic
function expiry(now = Date.now) { return now() + 3600_000; }
```

## Open/closed, Liskov, interface segregation

**Signal (OCP)**: a growing `switch`/`if-else` on a type tag that every new case must edit. **(LSP)**: a subtype that throws on, or no-ops, a method its base promises. **(ISP)**: a caller forced to depend on a fat interface when it uses one method.

**Why**: each is a coupling smell that surfaces later as a shotgun edit. OCP — dispatch through a map or polymorphism so a new case is an *addition*, not a *modification*. LSP — if a subtype can't honor the contract, the hierarchy is wrong; prefer composition. ISP — narrow the parameter type to the methods actually used, so callers and tests supply less.

## Testability (pure core, isolated effects)

**Signal**: business logic tangled with side effects — a calculation that also logs, mutates a global, or writes to disk mid-computation; hidden inputs (time, randomness, env) read inline; a branch reachable only by hard-to-arrange state.

**Why**: a pure function of its inputs is trivially testable — same input, same output, no setup. Push effects (I/O, logging, persistence) to the edges and keep a pure core, and the interesting logic becomes a table of input→output cases instead of an integration test with mocks.

```js
// before — logic + effect fused
function applyDiscount(cart) {
  const total = cart.reduce((a, i) => a + i.price, 0) * 0.9;
  analytics.track("discount", total);   // effect inside the calc
  return total;
}
// after — pure core, effect at the edge
const discountedTotal = (cart) => cart.reduce((a, i) => a + i.price, 0) * 0.9;
// caller: const total = discountedTotal(cart); analytics.track("discount", total);
```

## Coupling & cohesion (reuse, maintainability)

**Signal**: feature envy (a function reaching deep into another object's internals); a long parameter list threaded through several layers just to reach the bottom; a module that imports half the codebase.

**Why**: low coupling and high cohesion are what let a block move, get reused, or get changed without a ripple. A unit that talks to its own data and takes only what it uses is one you can lift into another context; one wired to its neighbors' internals can only live where it was born.
