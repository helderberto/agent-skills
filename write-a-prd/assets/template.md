# PRD Template

Use this template when writing PRDs. Save to `specs/<kebab-case-name>.md` in the project root.

```markdown
## Problem Statement

The problem the user is facing, from the user's perspective. Focus on pain and impact, not implementation.

## Solution

The solution from the user's perspective. Describe the experience, not the architecture.

## User Stories

A LONG, numbered list. Each story follows: "As an <actor>, I want <feature>, so that <benefit>".

Example:
1. As a mobile bank customer, I want to see balance on my accounts, so that I can make better informed decisions about my spending

Cover all aspects: happy path, edge cases, filtering, navigation, error states.

## Implementation Decisions

Organized by concern:

### New Modules
- Module name, purpose, and public interface (function signatures with parameter types)
- Why each module exists as a separate unit

### Architectural Decisions
- Key definitions (e.g., what "completion" means precisely)
- How data flows from storage to display
- Time filtering strategy
- State management approach (URL params, local state, etc.)

### Schema Changes
- New tables or columns needed (or "None required" if existing schema suffices)
- Note storage formats (e.g., prices in cents)

### API Contracts
- New routes or loader changes
- Request/response shapes

### Navigation
- Where the feature is accessed from
- New routes or links added

Do NOT include specific file paths or code snippets — they go stale fast.

## Testing Decisions

- What makes a good test for this feature (test behavior, not implementation)
- Which modules need tests
- Key test cases to cover (empty state, boundaries, isolation, ordering)
- Prior art: existing test patterns to follow in the codebase

## Out of Scope

Explicit list of what this PRD does NOT cover. Be specific — vague exclusions invite scope creep.

## Further Notes

Data format caveats, privacy considerations, performance concerns, or anything that could surprise an implementer.
```

## Filename Convention

Use kebab-case derived from the feature name: `specs/instructor-analytics-dashboard.md`

Add a top-level heading matching the feature title.

## Example

`specs/instructor-analytics-dashboard.md`:

```markdown
# Instructor Analytics Dashboard

## Problem Statement

Instructors have no visibility into how their courses are performing. They cannot see revenue, enrollment trends, whether students complete courses, how students perform on quizzes, or where students abandon their learning journey.

## Solution

Two analytics surfaces:

1. **Overview metrics on the existing instructor page** — total revenue, total enrollments, average completion rate across all courses, with a time filter and per-course breakdown.
2. **A dedicated per-course analytics page** — revenue chart + transaction table, enrollment chart, completion rate, quiz pass rates per module, and a lesson-level drop-off funnel.

All metrics filterable by last 30 days, last 90 days, or all time via URL search param.

## User Stories

1. As an instructor, I want to see total revenue across all my courses on the overview page, so that I can understand my overall earnings at a glance.
2. As an instructor, I want to filter all overview metrics by last 30 days, last 90 days, or all time, so that I can track trends over different periods.
3. As an instructor, I want to see a revenue chart over time for a specific course, so that I can identify growth trends or revenue drops.
4. As an instructor, I want to see individual transactions including student name, email, amount paid, country, and date, so that I have a full audit trail.
5. As an instructor, I want to see quiz pass rates broken down by module, so that I can identify which modules students struggle with most.
6. As an instructor, I want to see a lesson-level drop-off funnel, so that I can pinpoint where students disengage.

## Implementation Decisions

### New Modules

- **`analyticsService`** — single service owning all analytics queries. Deep module with few entry points:
  - `getInstructorOverview({ instructorId, from, to })` → totals + per-course breakdown
  - `getCourseRevenueSummary({ courseId, from, to })` → total + transactions with student data
  - `getCourseEnrollmentSummary({ courseId, from, to })` → total + time-series
  - `getCourseCompletionRate({ courseId, from, to })` → percentage
  - `getModuleQuizPassRates({ courseId, from, to })` → per module: attempts + pass %
  - `getLessonDropoff({ courseId })` → ordered list with % never started

### Architectural Decisions

- **Completion** = enrolled student with `completedAt` set (finished all lessons)
- **Drop-off** = student has zero progress records for a lesson (never started it); structural metric, no time filter
- **Quiz pass rate** = latest attempt per student per quiz (retries don't count as extra failures)
- Time range via `?range=30d|90d|all` URL search param — shareable, bookmarkable
- Charts rendered client-side; server returns pre-aggregated `{ date, value }[]`

### Schema Changes

None required. All data exists in purchases, enrollments, lesson progress, and quiz attempts tables.

### Navigation

Add "Analytics" link to per-course instructor navigation alongside existing tabs.

## Testing Decisions

- Test `analyticsService` public interface against real in-memory database — no mocks
- Cover: empty state, date boundaries, multi-course isolation, partial completions, latest-attempt quiz logic, drop-off ordering
- Follow existing service test patterns in the codebase

## Out of Scope

- CSV/PDF export
- Email digest reports
- Student drill-down from drop-off funnel
- Refund tracking or net revenue
- Cohort analysis or retention curves
- Period-over-period comparison
- Admin-level cross-instructor analytics

## Further Notes

- Prices stored in cents — convert before display
- Purchases and enrollments are separate (coupon redemption creates enrollment without purchase)
- PPP pricing means same course may have different prices per country — show actual price paid, not list price
```
