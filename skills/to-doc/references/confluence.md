# Confluence through the Atlassian MCP

Call `getContentFormatGuide` with `toolName: "createConfluencePage"` (or `"updateConfluencePage"`) before writing the body. The guide is canonical: where it and this file differ, follow the guide.

## Patterns

| Element | HTML |
|---|---|
| Header | a `details` bodied extension (Page Properties) holding the statuses line and a `th`/`td` table: see [template.md](template.md) |
| Status | `<span data-type="status" data-color="COLOR" data-status-style="bold">DRAFT</span>`: neutral for ABANDONED and DRAFT, blue IN PROGRESS, yellow IN REVIEW, green APPROVED |
| Person | `<span data-type="mention" data-user-id="AAID">@Name</span>`. The author's AAID comes from `atlassianUserInfo`, others' from `lookupJiraAccountId`. No AAID → plain `[@Name]`: an invented ID breaks the mention |
| TL;DR panel | `<div data-type="panel-info"><p>…</p></div>`, paragraphs only: a panel can't hold a table, an expand or another panel |
| Table of contents | the `toc` extension in [template.md](template.md) |
| Mermaid diagram | a bare `<pre><code class="language-mermaid">` at the top level, `<`, `>`, `&` and `"` escaped |
| Expand | `<details><summary>Title</summary>…</details>` |
| Source, ticket or page in a list | `<a href="URL" data-card-appearance="inline"></a>`: the card shows the live title, so leave the anchor empty |
| Link inside a sentence | `<a href="URL">text</a>`: a card would drop the text |
| Date | `<time datetime="YYYY-MM-DD">Month D, YYYY</time>` |

## Gotchas

- **The converter builds the diagram.** A top-level Mermaid code block becomes the Mermaid app macro, then a "Diagram" expand holding the source. Wrap it in `<details>` yourself and the expand gets a second macro.
- **Diagrams stay on the page.** An external renderer (mermaid.ink and the like) sends the diagram text out on every page view, and the MCP can't upload attachments. The code block is the only path.
- **Storage XML renders as raw text.** Write the guide's HTML, never `<ac:structured-macro>` or `<ri:page>`.
- **A retitle sends the full body.** Fetch the page as `html` and send that body back unchanged with the new title.
- **Only `adf` shows macros.** `markdown` and `html` both show a diagram as a bare code block, macro and expand gone. A large `adf` read is saved to a file. Outline that file with `scripts/adf-outline.sh`, so the body never enters the context.
