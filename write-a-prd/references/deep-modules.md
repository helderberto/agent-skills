# Deep Modules

A **deep module** has a simple interface hiding a large implementation. The interface rarely changes even as the implementation evolves.

## Why it matters for PRDs

When designing the module breakdown in a PRD, deep modules let you:
- Define stable interfaces that won't invalidate the PRD when implementation details shift
- Create testable boundaries — test the public interface, not internals
- Reduce coupling between the feature and the rest of the codebase

## Example: analyticsService

**Shallow** (bad) — many small functions with nearly 1:1 mapping to SQL queries:
- `getTotalRevenue(courseId)`
- `getRevenueByDay(courseId, from, to)`
- `getTransactionList(courseId, from, to)`
- `getRevenueForInstructor(instructorId)`

**Deep** (good) — one function that returns everything a consumer needs:
- `getCourseRevenueSummary({ courseId, from, to })` → returns total, time-series, and transactions

The caller doesn't know or care how the data is assembled internally.

## Signals you're designing shallow modules

- The module's interface has nearly as many functions as implementation lines
- Callers need to call 3+ functions and assemble the result themselves
- Adding a new metric requires changing the interface
- Every function maps 1:1 to a database query

## Signals you're designing deep modules

- The interface is small (1-3 functions per concern)
- Callers get a complete result from a single call
- New metrics can be added internally without changing the interface
- The module owns its own data assembly and aggregation
