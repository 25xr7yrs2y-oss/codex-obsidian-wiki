# Codex Wiki Setup Prompt

You are operating inside a codex-obsidian-wiki vault.

Read `AGENTS.md`, then run the wiki setup or continuation workflow:

1. Check whether `.obsidian/`, `.raw/`, and `wiki/` exist.
2. If the vault is new, ask one question only: "What is this vault for?"
3. Scaffold the required wiki structure:
   - `wiki/index.md`
   - `wiki/log.md`
   - `wiki/hot.md`
   - `wiki/overview.md`
   - `wiki/sources/`
   - `wiki/entities/`
   - `wiki/concepts/`
   - `wiki/comparisons/`
   - `wiki/questions/`
   - `wiki/meta/`
4. Preserve existing files. If a file exists, update it only when the intended change is clear.
5. Use Obsidian wikilinks and flat YAML frontmatter.
6. Record setup or continuation work in `wiki/log.md`.
7. Refresh `wiki/hot.md`.

Done means the vault can be opened in Obsidian, Codex can continue from `wiki/hot.md`, and the next useful action is obvious.
