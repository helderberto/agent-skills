---
name: revise
description: Structurally edit and improve article drafts — reorder sections, tighten arguments, improve clarity. Use when user asks to "revise", "improve my article", or "edit my draft". Don't use for typo fixes or formatting (/prose-fix), code documentation, or non-article content.
---

# Revise

Structurally edit an article draft, section by section. Unlike `prose-fix` (cosmetic polish), this rewrites for clarity, flow, and argument strength while preserving the author's voice. If no file is given, ask which.

## 1. Context

Ask, unless already answered: target audience, publication venue, and the **one takeaway** the reader should remember.

## 2. Analyze structure

Map the sections as an information DAG — each concept depends on prior concepts. Identify dependency violations (concept used before introduced), redundant sections, missing bridges, a weak intro (hook + expectations) or weak conclusion (does it reinforce the takeaway?).

Present the current outline and a proposed reordering. **Wait for confirmation before rewriting.** Already well-structured → skip to step 4 or suggest `prose-fix`.

## 3. Rewrite section by section

Edit in place, one section at a time:

- **Lead with the point** — first sentence states what the section proves or teaches
- **Max 240 characters per paragraph** — split longer ones
- **Cut ruthlessly** — drop sentences that don't serve the section's point
- **Smooth transitions** — each opening connects to the previous conclusion
- **Show, don't tell** — concrete examples over abstract claims

Preserve code blocks, technical terms, and proper nouns exactly. Re-read the whole for flow: intro promises what the article delivers, conclusion reinforces the takeaway.

## 4. Polish pass

Invoke `/prose-fix` on the file — it owns the formatting/typo/clarity rules. Report structural changes and what the polish pass changed.
