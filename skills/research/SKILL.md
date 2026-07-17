---
name: research
effort: medium
description: Investigate a question against primary sources and capture the findings as a cited Markdown file. Use when the user wants a topic researched, docs or API facts gathered, or reading legwork delegated to a background agent. Don't use for implementing against pinned dependency versions (use source-driven) or searching the current codebase (use grep/explore).
---

# Research

Spin up a **background agent** to do the reading, so the user keeps working while it investigates.

Give the agent this job:

1. **Investigate against primary sources** — official docs, source code, specs, first-party APIs — never a secondary write-up of them. Follow every claim back to the source that owns it.
2. **Write the findings to a single Markdown file**, citing each claim's source inline (link or path).
3. **Save it where the repo already keeps such notes.** Match the existing convention; if there is none, put it in `.specs/research/<slug>.md` and say where.

Report the file path back when the agent finishes. Don't summarize the findings inline unless asked — the cited file is the deliverable.
