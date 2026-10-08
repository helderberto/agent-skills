---
name: revise
description: Edit prose in place — restructure article drafts (reorder sections, tighten arguments) or polish any markdown/text (typos, dashes, filler). Use when asked to "revise", "edit my draft", "improve my article", "fix typos", "fix dashes", "clean up text", or "improve sentences". Don't use for code style or linting (/validate-code).
---

# Revise

Edit prose in place without changing the author's voice or meaning. Preserve code blocks, code references, technical terms, and proper nouns exactly. If no file is given, ask which.

Two depths:

- **Full revise** — an article draft: steps 1–4.
- **Polish only** — the ask is typos, dashes, or formatting, or the file isn't an article: step 4.

## 1. Context

Ask, unless already answered: target audience, publication venue, and the **one takeaway** the reader should remember.

## 2. Analyze structure

Map the sections as an information DAG — each concept depends on prior concepts. Identify dependency violations (concept used before introduced), redundant sections, missing bridges, a weak intro (hook + expectations) or weak conclusion (does it reinforce the takeaway?).

Present the current outline and a proposed reordering. **Wait for confirmation before rewriting.** Already well-structured → skip to step 4.

## 3. Rewrite section by section

Edit in place, one section at a time:

- **Lead with the point** — first sentence states what the section proves or teaches
- **Max 240 characters per paragraph** — split longer ones
- **Cut ruthlessly** — drop sentences that don't serve the section's point
- **Smooth transitions** — each opening connects to the previous conclusion
- **Show, don't tell** — concrete examples over abstract claims

Re-read the whole for flow: intro promises what the article delivers, conclusion reinforces the takeaway.

## 4. Polish

One pass per category, in order: formatting → typos → clarity. This pass only removes or substitutes; it never adds words, and never rewrites a sentence that is already clear.

**Formatting**

| Issue                     | Replace with                                              |
| ------------------------- | --------------------------------------------------------- |
| Em dash `—` (with spaces) | Period, comma, colon, or parentheses depending on context |
| Em dash `—` (no spaces)   | Split into two sentences or use comma                     |
| Double spaces             | Single space                                              |

Grep for `—` before and after to confirm none remain.

**Typos**: misspellings, wrong word form ("teh", "dont"), missing apostrophes in contractions.

**Clarity**:

- Remove filler ("very", "just", "really", "basically", "actually")
- Split run-on sentences
- Flatten weak constructions ("is able to" → "can", "in order to" → "to")

Report structural changes (full revise), then polish changes by category.
