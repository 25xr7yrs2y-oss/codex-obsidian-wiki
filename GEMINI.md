# codex-obsidian-wiki: Gemini CLI Companion Instructions

This repo is a knowledge base companion that builds persistent, compounding Obsidian wiki vaults using Andrej Karpathy's LLM Wiki pattern. The primary maintained path in this fork is Codex CLI via `AGENTS.md` and `prompts/`; the skills are also written in a cross-platform Agent Skills style so Gemini CLI / Antigravity can reuse the same vault conventions.

## Skills Discovery

Skills live in `skills/<name>/SKILL.md`. To make them available to Gemini CLI:

```bash
ln -s "$(pwd)/skills" ~/.gemini/skills/codex-obsidian-wiki
```

Or run the bundled installer:

```bash
bash bin/setup-multi-agent.sh
```

## Skills

| Skill | What it does |
|---|---|
| `wiki` | Scaffolds a new vault, manages hot cache, routes to sub-skills |
| `wiki-ingest` | Reads sources (files, URLs, images) and creates 8-15 wiki pages each |
| `wiki-query` | Answers questions from the wiki with three depth modes |
| `wiki-lint` | Health checks: orphans, dead links, stale claims, gaps |
| `save` | Files the current conversation as a wiki note |
| `autoresearch` | Autonomous research loop: search → fetch → synthesize → file |
| `canvas` | Creates and edits Obsidian canvas (.canvas) files |
| `defuddle` | Cleans web pages before ingest (saves 40-60% tokens) |
| `obsidian-markdown` | Obsidian Flavored Markdown syntax reference |
| `obsidian-bases` | Obsidian Bases (.base files): native database views |

## Trigger Phrases (Examples)

- "set up wiki" → `wiki`
- "ingest this article" → `wiki-ingest`
- "ingest https://example.com/article" → `wiki-ingest` (URL mode)
- "what do you know about X" → `wiki-query`
- "lint the wiki" → `wiki-lint`
- "save this conversation" → `save`
- "research [topic]" → `autoresearch`

## Vault Conventions

- `.raw/`: source documents, immutable (never modify)
- `wiki/`: agent-generated knowledge (you own this)
- `wiki/hot.md`: recent context cache (~500 tokens), read first at session start
- `wiki/index.md`: master catalog
- `.raw/.manifest.json`: delta tracking for ingest

## Bootstrap

On first session:
1. Read this file + the project `AGENTS.md`
2. If `wiki/hot.md` exists, silently read it to restore recent context
3. Wait for the user to ask for setup, ingest, query, lint, save, or research

## Project Links

- Codex fork: this repository
- Upstream project: https://github.com/AgriciDaniel/claude-obsidian
- Community early-access mirror (Pro): https://github.com/AI-Marketing-Hub
- Pattern: https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f
