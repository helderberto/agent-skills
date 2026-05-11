---
name: pr-reply
description: Draft friendly, concise replies to pull request review comments. Use when user pastes a PR comment, asks to "reply to a PR comment", "/pr-reply", "answer this reviewer", or wants help responding to review feedback. Don't use for posting comments to GitHub, creating new PRs, or reviewing PRs.
---

# PR Reply

Draft replies to reviewer comments grounded in the project's source of truth (specs, ADRs, CHANGELOG, code, prior PRs). Output is text only — the user posts to GitHub themselves.

## Pre-loaded context

- Branch: !`git rev-parse --abbrev-ref HEAD`
- Recent log: !`git log --oneline -15`
- Spec dir: !`ls docs/specs/ docs/adrs/ 2>/dev/null`

## Inputs

Accept any of:

1. **Quoted comment + file reference** (most common, fastest)
   ```
   @src/foo.ts
   > Why are we wrapping JSON.stringify here?
   ```

2. **GitHub permalink to a review comment** — fetch with `gh`:
   ```bash
   # https://github.com/<owner>/<repo>/pull/<n>#discussion_r<id>
   gh api /repos/<owner>/<repo>/pulls/comments/<id>
   ```
   Returns body, path, line, diff_hunk, user, in_reply_to_id. Use those fields to skip the "ask for file/line" step.

3. **PR number** — fetch all review comments to triage in bulk:
   ```bash
   gh api /repos/<owner>/<repo>/pulls/<n>/comments --jq \
     '.[] | {id, path, line, user: .user.login, body, in_reply_to_id}'
   ```
   When user says "reply to all open comments on PR #289", iterate.

4. **Code block pasted inline** — treat the same as quoted text; extract the file path from a leading `@path` or fenced header.

Always confirm file + line before drafting if not derivable from input.

## Workflow

0. **Resolve input** — if a permalink or PR number is given, fetch via `gh` (see Inputs). Extract: comment body, file path, line, prior replies.

1. **Locate sources of truth** in this order, stopping when sufficient:
   - `docs/specs/*.md` — architecture decisions, design rationale
   - `docs/adrs/*.md` — legacy ADR location (if no specs/)
   - `CHANGELOG.md` — historical context for "why does X exist"
   - `git log -- <file>` — when the line was introduced and why
   - `gh pr list --search` — prior debate on the same topic
   - The code itself

2. **Classify the comment** — picks the response shape:

   | Type | Shape |
   |---|---|
   | Already-decided | Acknowledge + link to spec/decision + offer to revisit on concrete pain |
   | Valid in-scope | Acknowledge + plan the change inline |
   | Valid out-of-scope | Acknowledge + commit to follow-up + scope out of current PR |
   | Misconception | Correct gently with one fact + restate decision |
   | Praise / nit | One-liner |

3. **Draft response** following the rules below.

4. **Iterate on request** — user often asks shorter, friendlier, or rephrased.

## Tone Rules

- **English only.** Even if user writes in another language.
- **Sound like a human.** No em dashes (`—`). Use commas, periods, parentheses, "but", "so", "and" instead. Em dashes read as AI-generated.
- **Friendly but not sycophantic.** "Good question", "Good catch", "Good call". Pick one, don't stack.
- **Concise.** 1–3 sentences typical, 1 paragraph max. Sacrifice grammar for brevity.
- **Specific.** Reference file/decision/PR number when pointing at sources.
- **No conditional fluff.** "I think maybe we could possibly..." → cut.
- **Emoji.** Default off. Add 🙌 / ✅ only if the repo's existing PR comments use them.
- **End with engagement** when appropriate: "Happy to revisit if...", "Want me to address it in this PR or follow-up?"

## Response Templates

**Already-decided:**
> {Acknowledgment}. We landed on this in {spec/PR link}, {one-line reason}. Happy to revisit if there's a concrete pain point.

**Out-of-scope:**
> {Acknowledgment}. {One-line answer}. Out of scope for this PR, but happy to address it in a follow-up.

**Misconception:**
> {Acknowledgment}. Quick clarification: {correct fact}. {Restate intent if needed}.

**In-scope fix:**
> {Acknowledgment}. I'll {specific action}. {One-line rationale if non-obvious}.

## Rules

- NEVER fabricate decisions, spec sections, or PR numbers — only cite what you've verified
- NEVER post to GitHub — output is text for the user to paste
- ALWAYS verify cited line numbers / PR numbers exist before referencing
- When pointing at specs, link with the actual filename (`docs/specs/<file>.md`), not a hallucinated path
- If multiple comments are pasted at once, draft replies separately, one per comment

## Examples

**Already-decided (string-only contract debate):**

> We landed on this in a [previous discussion](pr-link). String-only simplifies the library but pushes parsing, defaults, and type assertions to every call site. We'd also lose compile-time enforcement (`setDarkMode("yes")` would compile), and migration logic would scatter across MFEs instead of staying in the getter. Happy to revisit if there's a concrete pain point.

**Out-of-scope (postbuild shim):**

> Good catch! The shim isn't browser-storage-specific. It was added earlier for `utils/` to support consumers on older Jest versions that don't follow `exports`. Out of scope for this PR, but happy to revisit in a follow-up.

**Misconception (browser quota):**

> Good call, conservative start is easier to expand than retract. Quick clarification: 4KB isn't the browser cap (browsers allow ~5-10MB per origin), it's our soft ceiling against the 50KB per-MFE budget. Principle still applies though, so I'll drop the default to 2KB.

**In-scope fix (missing CHANGELOG):**

> Good catch! Looks like the previous bumps landed without updating the CHANGELOG. I'll backfill the missing entries in this PR to avoid pushing the gap further.

## Error Handling

- No PR comment provided — ask for the quoted text + file/line
- Spec/decision referenced doesn't exist — say so and re-classify the comment
- Reviewer's question reveals a real bug — flag to user, suggest fixing in-scope rather than just replying

## See Also

- [code-review](../code-review/SKILL.md) — review a PR (opposite direction)
- [create-pull-request](../create-pull-request/SKILL.md) — create the PR being commented on
