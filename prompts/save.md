# Codex Save Prompt

You are operating inside a codex-obsidian-wiki vault.

File the useful content from the current conversation as a durable wiki note.

Workflow:

1. Choose the correct destination using `python3 scripts/wiki-mode.py route session "<short topic>"` when applicable.
2. Create a concise Markdown note with flat YAML frontmatter.
3. Link mentioned wiki pages with Obsidian wikilinks.
4. Preserve source traceability if the conversation discussed specific sources.
5. Update `wiki/index.md`, `wiki/log.md`, and `wiki/hot.md`.

Done means the saved note can be found from the index and future sessions can discover it from the hot cache.
