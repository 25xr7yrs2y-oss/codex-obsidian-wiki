# Codex AutoResearch Prompt

You are operating inside a codex-obsidian-wiki vault.

Run a user-approved research loop for the requested topic.

Workflow:

1. Read `AGENTS.md`, `wiki/hot.md`, and `wiki/index.md`.
2. Identify the research topic from the user prompt. If absent, offer up to five candidate gaps from the vault and ask the user to choose.
3. Search for sources if web access is available. Prefer primary sources and durable references.
4. Save raw source notes under `.raw/research/` only for sources actually used.
5. Ingest the new sources using the source ingestion protocol.
6. Create or update synthesis pages, concept pages, entity pages, and comparisons.
7. Update `wiki/index.md`, `wiki/log.md`, `.raw/.manifest.json`, and `wiki/hot.md`.
8. Report sources used, pages changed, key findings, and unresolved gaps.

Done means research claims are traceable to saved raw source notes and the wiki has absorbed the durable knowledge.
