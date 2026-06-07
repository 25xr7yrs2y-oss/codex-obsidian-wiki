# codex-obsidian-wiki: Codex CLI Operating Protocol

This repository is an Obsidian vault kit for OpenAI Codex CLI. Its job is to maintain a persistent, compounding wiki vault over plain Markdown files the user owns.

The core purpose is unchanged from the upstream `claude-obsidian` project: a running AI notetaker that ingests sources, writes connected wiki pages, preserves traceability, and keeps `wiki/index.md`, `wiki/log.md`, and `wiki/hot.md` current across sessions.

## Repository Roles

- `.raw/`: immutable source intake. Read source files here, but do not edit user-provided files. The only agent-maintained file in this folder is `.raw/.manifest.json`.
- `wiki/`: Codex-maintained knowledge base. Create and update Markdown pages here.
- `wiki/index.md`: master catalog of pages. Update on every ingest, filed query, rename, or meaningful reorganization.
- `wiki/log.md`: append-only operation history. New entries go at the top. Do not rewrite older log entries except to fix a broken link caused by a deliberate rename.
- `wiki/hot.md`: short-term continuity cache. Read it at session start and refresh it after every meaningful operation.
- `_templates/`: page templates and frontmatter examples.
- `.vault-meta/`: runtime metadata, locks, transport detection, retrieval indexes, and optional methodology mode state.
- `skills/`: portable workflow instructions retained from upstream. Use them as detailed references, but prefer this Codex protocol when instructions conflict.
- `commands/` and `.claude-plugin/`: legacy Claude Code compatibility. They are not the primary Codex path.
- `prompts/`: Codex prompt templates that replace Claude slash commands.

## Codex Startup Checklist

When starting work in this vault:

1. Read this file.
2. Read `wiki/hot.md` if it exists.
3. Read `wiki/index.md` if the task touches existing knowledge.
4. Check `.raw/.manifest.json` before re-ingesting sources.
5. Prefer safe, narrow edits to existing Markdown pages over broad rewrites.
6. Use `scripts/wiki-lock.sh acquire <vault-relative-path>` before mutating any `wiki/` page, then release the lock after writing.

## Main Codex Workflows

Use natural prompts in Codex, or run the helper:

```bash
bin/codex-vault setup "What this vault is for"
bin/codex-vault ingest .raw/example.md
bin/codex-vault query "What do we know about X?"
bin/codex-vault lint
bin/codex-vault hot
```

The helper prints or runs the prompt templates in `prompts/`. The same text can be pasted into an interactive `codex` session.

## Source Ingestion Protocol

When the user asks to ingest a source:

1. Identify the source path or URL. For local files, source material belongs under `.raw/`. If the user gives content directly, save a copy under `.raw/manual/` only with explicit user approval.
2. Compute a source hash and check `.raw/.manifest.json`. If the same file hash is already recorded, report that it is unchanged unless the user asked to force re-ingest.
3. Read the source completely. For large sources, chunk by stable headings or 2,000-4,000 word ranges. Keep each chunk traceable to the original file and section.
4. Search `wiki/index.md` and existing wiki filenames before creating pages. Update existing pages when they cover the same durable concept, entity, source, question, or comparison.
5. Create or update a source summary page under the path returned by `python3 scripts/wiki-mode.py route source "<title>"`.
6. Create or update durable entity, concept, comparison, domain, and question pages as needed. One page should represent one durable thing.
7. Add source traceability in frontmatter and body. Cite raw files as code paths and source summary pages as wikilinks.
8. Flag conflicts instead of overwriting older claims. Use `> [!contradiction]` callouts with links to both pages.
9. Update `wiki/index.md`, relevant folder `_index.md` files, `wiki/log.md`, `.raw/.manifest.json`, and `wiki/hot.md`.
10. Report what was created, what was updated, what was skipped, and any follow-up gaps.

Done means: all durable knowledge has a home, no duplicate pages were introduced, source traceability exists, the manifest records the ingest, `index/log/hot` are current, and the user can navigate the result in Obsidian via wikilinks.

## Query Protocol

When answering from the vault:

1. Read `wiki/hot.md` first.
2. Read `wiki/index.md` second.
3. Read the smallest useful set of pages, usually 3-5. Use retrieval scripts when available:
   `python3 scripts/retrieve.py "<query>" --top 5`
4. Answer with citations to wiki pages and source pages. Avoid uncited claims about vault-specific knowledge.
5. If the answer is worth preserving, offer to file it under `wiki/questions/`.
6. If the wiki lacks the answer, say what is missing and suggest an ingest or research target.

Done means: the answer is grounded in existing pages, citations are explicit, and any newly discovered gap is logged or offered as follow-up.

## Vault Maintenance Protocol

Run a lint or maintenance pass when asked, after a batch ingest, or after roughly 10-15 source ingests.

Check for:

- Duplicate pages or near-duplicate titles.
- Dead wikilinks.
- Orphan pages with no inbound links.
- Missing frontmatter fields.
- Stale index entries.
- Concepts or entities mentioned repeatedly but not represented as pages.
- Claims without sources.
- Contradictions that need user review.

Write findings to `wiki/meta/lint-report-YYYY-MM-DD.md` and ask before destructive cleanup. Non-destructive link, index, and frontmatter fixes may be made directly if the intent is clear.

## File Safety Rules

- Never delete or overwrite user source files in `.raw/`.
- Never silently replace a wiki page. Preserve prior claims, add dated updates, and cite the source of changes.
- Never create a duplicate page because of capitalization, pluralization, punctuation, or synonym drift. Search first.
- Prefer Obsidian wikilinks like `[[Compounding Knowledge]]` over path links for internal wiki references.
- Keep filenames stable once linked. If a rename is necessary, update all wikilinks and index entries in the same operation.
- Keep generated pages concise. Split pages that grow beyond about 300 lines.
- Do not commit secrets, API keys, MCP tokens, or local vault paths that reveal private information.

## MCP and Transport

Codex works without MCP by reading and writing Markdown files directly. Optional MCP configuration is documented in `docs/codex-mcp.md`.

Transport preference:

1. Obsidian CLI if available and configured by `bash scripts/detect-transport.sh`.
2. Codex MCP server tools if the user configured an Obsidian MCP server.
3. Direct filesystem edits as the reliable fallback.

If MCP setup is missing or broken, continue with filesystem mode and explain that MCP is optional.

## Legacy Claude Compatibility

This fork preserves upstream Claude Code assets for users migrating from `AgriciDaniel/claude-obsidian`:

- `CLAUDE.md`
- `commands/`
- `.claude-plugin/`
- Claude-specific notes inside historical wiki pages

Those files are legacy compatibility, not the default path for Codex users. Do not add new Claude-first instructions unless the change is explicitly about migration or upstream compatibility.
