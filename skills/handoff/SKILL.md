---
name: handoff
description: Compact the current conversation into a handoff document for a fresh agent.
disable-model-invocation: true
argument-hint: "What will the next session be used for?"
---

Write a handoff document summarising the current conversation so a fresh agent can continue the work. Save to `$TMPDIR`, else `/tmp` (`%TEMP%` on Windows) - not the current workspace - and print the absolute path.

Include a "suggested skills" section in the document, which suggests skills that the agent should invoke.

Do not duplicate content already captured in other artifacts (PRDs, plans, ADRs, issues, commits, diffs). Reference them by path or URL instead.

Redact any sensitive information, such as API keys, passwords, or personally identifiable information.

If the user passed arguments, treat them as a description of what the next session will focus on and tailor the doc accordingly.

Next: in the fresh session, `/hb:triage` with the handoff path, or the first suggested command from the doc.
