---
name: write-a-prd
description: Create a PRD through codebase exploration, user interview, and module design. Use when user wants to write a PRD, create a product requirements document, or plan a new feature. Don't use for refactoring plans, bug reports, or small changes.
---

# PRD Writing

If user provided a description via arguments, skip straight to Step 2.

## Workflow

### 1. Gather problem description
Ask the user for a detailed description of the problem and any solution ideas they have in mind.

### 2. Explore codebase
Use the Agent tool with subagent_type=Explore to verify the user's assertions and understand: relevant data models, existing services, API routes, and frontend structure. Note what already exists vs. what needs to be built.

### 3. Interview
Adopt the [grill-me](../grill-me/SKILL.md) style — one question at a time, lead with your recommended answer, let the user confirm or correct. Resolve each decision branch before moving to the next. See [references/interview-guide.md](references/interview-guide.md) for the question tree.

If a question can be answered by exploring the codebase, explore instead of asking.

### 4. Design modules
Sketch major modules to build or modify. Favor [deep modules](references/deep-modules.md) — simple interface, rich implementation, testable in isolation. Present to user and ask which modules need tests.

### 5. Write PRD
Use template from [assets/template.md](assets/template.md). Save to `specs/<kebab-case-name>.md` in the project root (create the `specs/` directory if it doesn't exist).

## Rules

- No specific file paths or code snippets in the PRD — they go stale fast
- User stories must use: "As an \<actor\>, I want \<feature\>, so that \<benefit\>"
- Revenue/money fields: always note storage format (e.g. cents) and display conversion
- Separate concerns: schema changes, API contracts, and UI decisions in distinct subsections

## Error Handling

- If `specs/` directory doesn't exist → create it before writing
- If codebase exploration reveals scope is much larger than expected → surface this and re-scope with user before continuing
- If user gives terse answers during interview → offer concrete options (A/B/C) rather than open-ended questions
