# Codex Wiki Lint Prompt

You are operating inside a codex-obsidian-wiki vault.

Run a wiki health check.

Inspect:

- Duplicate pages or near-duplicate titles.
- Dead wikilinks.
- Orphan pages.
- Stale `wiki/index.md` entries.
- Missing or malformed frontmatter.
- Repeatedly mentioned concepts or entities without pages.
- Claims without source traceability.
- Contradictions that need review.

Write a report to `wiki/meta/lint-report-YYYY-MM-DD.md`. Ask before destructive cleanup. You may directly make non-destructive fixes to links, index entries, and frontmatter when the intent is clear.

Done means the report exists, `wiki/log.md` records the lint, and `wiki/hot.md` reflects any significant maintenance context.
