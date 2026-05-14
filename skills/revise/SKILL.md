---
name: revise
description: Structurally edit and improve article drafts — reorder sections, tighten arguments, improve clarity. Use when user asks to "revise", "improve my article", "edit my draft", or "/revise". Don't use for typo fixes or formatting (use prose-fix), code documentation, or non-article content.
---

# Revise

Structurally edit an article draft through an interactive, section-by-section process. Unlike prose-fix (cosmetic polish), this skill rewrites for clarity, flow, and argument strength.

## Step 1 — Understand Context

Before editing, ask the user (skip questions they already answered). Use AskUserQuestion when available; otherwise ask directly:

1. **Audience**: "Who is the target audience?" — Options: "Beginners", "Experienced developers", "General tech readers"
2. **Venue**: "Where will this be published?" — Options: "Blog post", "Newsletter", "Documentation"
3. **Takeaway**: "What is the one thing the reader should remember?" — ask separately as text (too specific for predefined options)

## Step 2 — Analyze Structure

Read the full article. Map the sections as an information DAG — each concept depends on prior concepts. Identify:

- **Dependency violations**: concept used before it is introduced
- **Redundant sections**: same point made twice in different places
- **Missing sections**: logical gaps the reader needs bridged
- **Weak intro**: does the first paragraph hook and set expectations?
- **Weak conclusion**: does it reinforce the one takeaway?

Present the current section outline and a proposed reordering. **Wait for user confirmation before proceeding.**

## Step 3 — Rewrite Section by Section

For each section, in order:

1. **Lead with the point** — first sentence states what the section proves or teaches
2. **Max 240 characters per paragraph** — split longer paragraphs
3. **Cut ruthlessly** — remove sentences that don't serve the section's point
4. **Smooth transitions** — each section's opening should connect to the previous section's conclusion
5. **Show, don't tell** — prefer concrete examples over abstract claims

Edit the file in place, one section at a time.

## Step 4 — Final Check

After all sections are revised:

1. Re-read the full article for flow
2. Verify the intro promises what the article delivers
3. Verify the conclusion reinforces the one takeaway
4. Check that no concept is used before it is introduced
5. Report a summary of structural changes made

## Step 5 — Polish Pass

After structural edits, run a single cosmetic pass over the file. Order: formatting → typos → clarity.

### Formatting
| Issue | Replace with |
|-------|-------------|
| Em dash ` — ` (with spaces) | Period, comma, colon, or parentheses depending on context |
| Em dash `—` (no spaces) | Split into two sentences or use comma |
| Double spaces | Single space |

### Typos
- Misspelled words
- Wrong word form (e.g. "teh" → "the", "dont" → "don't")
- Missing apostrophes in contractions

### Sentence Clarity
- Remove filler words ("very", "just", "really", "basically", "actually")
- Split run-on sentences into two
- Flatten weak constructions ("is able to" → "can", "in order to" → "to")

Workflow: grep for `—` first, fix all formatting, then typos, then clarity. Grep again to confirm no em dashes remain. Never add words — only remove or substitute. Never rewrite a sentence that is already clear.

Report what was changed by category.

## Rules

- Always read the file before editing
- Always confirm structural changes with the user before rewriting (Steps 1–3)
- Preserve the author's voice — restructure and tighten, don't impose a new style
- Preserve code blocks, technical terms, and proper nouns exactly
- If the article is already well-structured, skip to Step 5 (or suggest prose-fix instead for a lighter pass)

## Scope

- Works on `.md` files
- If no file is specified, ask the user which file to revise
