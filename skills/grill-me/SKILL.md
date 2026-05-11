---
name: grill-me
description: Interview the user relentlessly about a plan or design until reaching shared understanding, resolving each branch of the decision tree. Use when user wants to stress-test a plan, get grilled on their design, or mentions "grill me".
---

Interview me relentlessly about every aspect of this plan until we reach a shared understanding. Walk down each branch of the design tree resolving dependencies between decisions one by one.

If a question can be answered by exploring the codebase, explore the codebase instead of asking.

For each question, present your recommended answer as the first option (Recommended). I can confirm by selecting it, correct by choosing another option, or provide a custom answer. Use AskUserQuestion when available; otherwise present options as a numbered list.

Track progress as a visible decision tree:
- `[OPEN]` — not yet resolved
- `[RESOLVED]` — committed

Ask one question at a time. After I answer, commit the decision explicitly, then move to the next open branch.

When all branches are resolved, produce:
- **Decision log** — what we committed to
- **Open risks** — unresolved concerns
- **Confidence** — HIGH / MEDIUM / LOW
