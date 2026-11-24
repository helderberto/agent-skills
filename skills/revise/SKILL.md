---
name: revise
description: Edit any prose in place — restructure a draft (reorder, cut, collapse) or polish it (typos, dashes, filler). Use when asked to "revise", "edit", "improve", or "fix typos" in existing text, commit and PR messages included, or asked whether a draft needs reordering or cutting. Don't use for code style (/check), or writing new text from scratch (/to-doc, /draft).
---

# Revise

Edit prose in place without changing the author's voice or meaning. Preserve code blocks, code references, technical terms, and proper nouns exactly. If no file is given, ask which.

Three depths:

- **Full revise** — a draft to restructure: steps 1–4.
- **Polish only** — the ask is typos, dashes, AI tells, or formatting: step 4.
- **Question** — "worth reordering?", "anything to cut?", "can a section collapse?": run the step the question names, then answer with numbered candidates, each with a recommendation. Edit nothing until the user picks.

Constraints the user sets during the session (a term to keep, a rule like "no counts") bind every later pass.

## 1. Reader and takeaway

Name the doc type. It sets the reader and where the takeaway lives:

| Type | Reader | Takeaway lives in |
| --- | --- | --- |
| Article | engineers reading a public post | the opening, reinforced by the conclusion |
| Design or architecture doc | reviewers deciding | the TL;DR, as the decision |
| Docs or README | someone doing a task | the first line: what it's for |
| Commit or PR message | a future `git log` reader | the subject: the change. The body says why |

Ask for the takeaway only when the draft doesn't state it.

## 2. Analyze structure

Every concept is **grounded** before a passage leans on it: the reader brings it, or an earlier section introduced it. Ground a term where it's first used, so a glossary block up front becomes definitions at first use.

Check each section for:

- **Ungrounded concepts**: used before introduced.
- **Cuts**: "if I cut this, what breaks?" Nothing → cut it. A section that repeats what the body already states folds away; rejected options go in one table (We go with | Instead of | Because).
- **Owned elsewhere**: detail another doc or the code owns (implementation, full option lists) → a link.
- **Collapse**: a section most readers skip → an expand, its lead sentence visible.
- **Format**: prose carries an argument, a list carries parallel items, a table carries a shape repeated 3+ times.
- **Roadmap**: an intro that lists sections names only the ones that exist, in their order.

Present the outline and the proposed changes. **Wait for confirmation before rewriting.** Done when every section has been run through every check.

## 3. Rewrite section by section

Edit in place, one section at a time:

- **Lead with the point** — first sentence states what the section proves or teaches
- **Max 240 characters per paragraph** — split longer ones
- **One job per sentence** — a sentence doing two jobs splits. After merging or splitting, reread each changed sentence on its own
- **Smooth transitions** — each opening connects to the previous conclusion
- **Show, don't tell** — concrete examples over abstract claims
- **A code name you add exists** — grep the source before writing it

Re-read the whole for flow: the takeaway lands where step 1 put it.

## 4. Polish

Re-read the file before every write and keep the user's edits. On a page with open inline comments, keep the words under each comment anchor.

One pass per category, in order: formatting → typos → AI tells → clarity. This pass only removes or substitutes; it never adds words, and never rewrites a sentence that is already clear.

**Formatting**

| Issue                           | Replace with                                              |
| ------------------------------- | --------------------------------------------------------- |
| `—`, `–`, or `--` (with spaces) | Period, comma, colon, or parentheses depending on context |
| Em dash `—` (no spaces)         | Split into two sentences or use comma                     |
| Double spaces                   | Single space                                              |

Run `grep -nE '—| – | -- '` before and after to confirm none remain outside code.

**Typos**: misspellings, wrong word form ("teh", "dont"), missing apostrophes in contractions.

**AI tells**: cut or swap when vague, keep when it's the precise term ("robust estimator").

- "leverage", "utilize" → "use"; "delve into" → "look at"
- Cut "robust", "seamless", "powerful"
- Cut throat-clearing: "it's worth noting that", "let's dive in", "in conclusion"
- "It's not X, it's Y" → state Y
- Cut a closing sentence that only restates its paragraph
- Bold mid-sentence, emoji in headings → plain text

**Clarity**:

- Remove filler ("very", "just", "really", "basically", "actually")
- Split run-on sentences
- Flatten weak constructions ("is able to" → "can", "in order to" → "to")
- One term per concept, the same everywhere
- A lead-in names the category, not the count ("these rules:"), so it stays true as items change. Check with `grep -nE '\b(two|three|four|five|six|seven|eight|nine|ten)\b [a-z ]+:'`
- A cross-reference uses its target heading's exact text

Report structural changes (full revise), then polish changes by category, then the session constraints applied.
