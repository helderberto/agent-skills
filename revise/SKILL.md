---
name: revise
description: Structurally edit and improve article drafts — reorder sections, tighten arguments, improve clarity. Use when user asks to "revise", "improve my article", "edit my draft", or "/revise". Don't use for typo fixes or formatting (use prose-fix), code documentation, or non-article content.
---

# Revise

Structurally edit an article draft through an interactive, section-by-section process. Unlike prose-fix (cosmetic polish), this skill rewrites for clarity, flow, and argument strength.

## Step 1 — Understand Context

Before editing, ask the user (skip questions they already answered):

1. **Who is the audience?** (beginners, experienced devs, general tech readers)
2. **What is the one takeaway?** (the single thing the reader should remember)
3. **Where will it be published?** (blog, newsletter, docs — affects tone and length)

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

## Rules

- Always read the file before editing
- Always confirm structural changes with the user before rewriting
- Preserve the author's voice — restructure and tighten, don't impose a new style
- Preserve code blocks, technical terms, and proper nouns exactly
- Do not fix typos or formatting — that is prose-fix's job
- If the article is already well-structured, say so and suggest prose-fix instead

## Scope

- Works on `.md` files
- If no file is specified, ask the user which file to revise
