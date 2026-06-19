---
name: prose-fix
description: Fix prose formatting, typos, and clarity issues in markdown or text files. Use when user asks to "fix dashes", "fix typos", "clean up text", "improve sentences", or "/prose-fix". Don't use for code style, linting, or full rewrites.
---

# Prose Fix

Scan the target file(s) for formatting issues, typos, and weak prose. Fix in place without changing the author's voice or intent.

## What to Fix

### Formatting

| Issue                     | Replace with                                              |
| ------------------------- | --------------------------------------------------------- |
| Em dash `—` (with spaces) | Period, comma, colon, or parentheses depending on context |
| Em dash `—` (no spaces)   | Split into two sentences or use comma                     |
| Double spaces             | Single space                                              |

### Typos

- Misspelled words
- Wrong word form (e.g. "teh" → "the", "dont" → "don't")
- Missing apostrophes in contractions

### Sentence Clarity

- Remove filler words ("very", "just", "really", "basically", "actually")
- Split run-on sentences into two
- Flatten weak constructions ("is able to" → "can", "in order to" → "to")

## Rules

- Read the file before editing
- Never change the author's voice, tone, or meaning
- Never rewrite a sentence that is already clear and direct
- Preserve technical terms, code references, and proper nouns exactly
- Do not add words — only remove or substitute
- One pass: formatting first, then typos, then clarity

## Workflow

1. Read the file
2. Grep for `—` to list formatting issues
3. Edit all issues in one pass per category
4. Grep again for `—` to confirm none remain
5. Report a summary of what was changed by category

## Scope

- Works on any `.md` or `.txt` file
- If no file is specified, ask the user which file to fix
