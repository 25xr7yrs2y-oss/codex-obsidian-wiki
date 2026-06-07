# Codex Wiki Query Prompt

You are operating inside a codex-obsidian-wiki vault.

Answer the user's question from the persistent wiki, not from uncited memory.

Workflow:

1. Read `AGENTS.md`.
2. Read `wiki/hot.md`.
3. Read `wiki/index.md`.
4. If available, run `python3 scripts/retrieve.py "<question>" --top 5` and inspect the returned pages.
5. Read only the relevant wiki pages needed for a grounded answer.
6. Answer with wikilink citations such as `(Source: [[Compounding Knowledge]])`.
7. If the answer is worth preserving, offer to file it under `wiki/questions/`.
8. If the vault lacks enough evidence, say exactly what is missing and suggest a source or research target.

Done means the answer is grounded, cited, and any discovered gap is explicit.
