# Codex Source Ingest Prompt

You are operating inside a codex-obsidian-wiki vault.

Read `AGENTS.md`, `wiki/hot.md`, `wiki/index.md`, and `.raw/.manifest.json` if they exist. Then ingest the source requested by the user.

Follow this workflow:

1. Confirm the source is under `.raw/` or is a URL/content the user explicitly wants imported.
2. Hash local source files and skip unchanged sources unless the user asked to force re-ingest.
3. Read the source completely. For large files, chunk by headings or stable ranges and keep chunk provenance.
4. Search existing wiki pages and `wiki/index.md` before creating new pages.
5. Create or update the source summary page, entity pages, concept pages, comparison pages, and domain pages as needed.
6. Acquire `scripts/wiki-lock.sh` locks before mutating `wiki/` files.
7. Add source traceability in frontmatter and body.
8. Flag contradictions instead of overwriting older claims.
9. Update `.raw/.manifest.json`, `wiki/index.md`, relevant `_index.md` files, `wiki/log.md`, and `wiki/hot.md`.
10. Report created pages, updated pages, skipped duplicates, and unresolved gaps.

Done means durable knowledge was filed, no duplicate pages were introduced, and the vault's index, log, hot cache, and manifest are current.
