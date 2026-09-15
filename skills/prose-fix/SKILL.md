---
name: prose-fix
effort: low
description: Fix prose formatting, typos, and clarity in markdown or text files. Use when asked to "fix dashes", "fix typos", "clean up text", or "improve sentences". Don't use for code style, linting, or full rewrites (/revise).
---

# Prose Fix

Fix formatting, typos, and weak prose in place without changing the author's voice or meaning. One pass per category, in order: formatting → typos → clarity. If no file is given, ask which.

## Formatting

| Issue                     | Replace with                                              |
| ------------------------- | --------------------------------------------------------- |
| Em dash `—` (with spaces) | Period, comma, colon, or parentheses depending on context |
| Em dash `—` (no spaces)   | Split into two sentences or use comma                     |
| Double spaces             | Single space                                              |

Grep for `—` before and after to confirm none remain.

## Typos

Misspellings, wrong word form ("teh", "dont"), missing apostrophes in contractions.

## Clarity

- Remove filler ("very", "just", "really", "basically", "actually")
- Split run-on sentences
- Flatten weak constructions ("is able to" → "can", "in order to" → "to")

Never rewrite a sentence that is already clear. Only remove or substitute — don't add words. Preserve technical terms, code references, and proper nouns exactly. Report changes by category.
