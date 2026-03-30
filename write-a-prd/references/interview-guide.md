# Interview Guide

Walk through these branches in order. Skip any that are already answered by the user's initial description or codebase exploration.

## Scope & Surface

- Where does this feature live? New page, new tab, or integrated into existing UI?
- Single view or multiple views (overview + detail)?
- Which user roles interact with this feature?

## Data & Definitions

For each metric or concept the feature introduces:
- How is it defined precisely? (e.g., "completion" = all lessons finished, or all quizzes passed?)
- What data already exists in the schema to support it?
- What's missing?

## Filtering & Time

- Should data be filterable by time range? Which ranges?
- Does the time filter apply uniformly to all metrics, or selectively?
- Are there metrics that are inherently cumulative (no time filter makes sense)?

## Display & Interaction

- Numbers, tables, charts, or a combination?
- Is the data sortable, searchable, or exportable?
- Should views be shareable (URL-driven state)?

## Access & Privacy

- Who can see what? Instructor sees own courses only? Admin sees all?
- Are there privacy concerns with showing student-level data?

## Boundaries

- What is explicitly out of scope?
- Are there adjacent features the user is tempted to include but should defer?

## Integration

- Does this require schema changes or new tables?
- New service module or extension of existing services?
- Any external dependencies (charting library, email service)?
