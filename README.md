# codex-obsidian-wiki

An OpenAI Codex CLI-compatible Obsidian vault system for a persistent, compounding Markdown wiki.

You drop sources into `.raw/`. Codex reads them, extracts durable knowledge, writes connected wiki pages, updates indexes and logs, refreshes a short-term hot cache, and keeps everything in plain Markdown that you own.

This is a Codex-first adaptation of Daniel Agrici's upstream [`claude-obsidian`](https://github.com/AgriciDaniel/claude-obsidian) project. The core idea is preserved: a running AI notetaker that builds and maintains a persistent wiki vault based on Andrej Karpathy's [LLM Wiki pattern](https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f).

## What It Does

- Maintains an Obsidian-compatible wiki under `wiki/`.
- Treats `.raw/` as immutable source intake.
- Creates and updates source, concept, entity, comparison, question, and meta pages.
- Maintains `wiki/index.md`, `wiki/log.md`, and `wiki/hot.md` after every meaningful operation.
- Preserves source traceability from wiki claims back to raw files and source summaries.
- Avoids duplicate pages through index and filename checks before creating new notes.
- Flags contradictions instead of silently overwriting older claims.
- Works without MCP by using normal filesystem access.
- Supports optional MCP and Obsidian CLI transports when users want them.

## What Changed From Upstream

The upstream project was Claude Code-first. This fork makes Codex CLI the first-class workflow:

- `AGENTS.md` is now the primary operating protocol for Codex.
- `prompts/` replaces Claude slash-command assumptions with reusable Codex prompt templates.
- `bin/codex-vault` runs or prints Codex workflows for setup, ingest, query, lint, save, hot-cache refresh, and research.
- `docs/codex-mcp.md` documents Codex `config.toml` and `codex mcp` setup.
- Claude plugin assets remain for legacy compatibility under `.claude-plugin/`, `commands/`, and `CLAUDE.md`.

## Prerequisites

- OpenAI Codex CLI. Check with:

```bash
codex --version
```

- Obsidian from https://obsidian.md.
- Git.
- Python 3 for validation and optional retrieval helpers.
- Optional: `obsidian-cli`, an Obsidian MCP server, `ollama`, or DragonScale helpers.

## Installation

Clone this Codex fork:

```bash
git clone https://github.com/25xr7yrs2y-oss/codex-obsidian-wiki.git
cd codex-obsidian-wiki
bash bin/setup-vault.sh
```

Open the folder in Obsidian:

```text
Obsidian -> Manage Vaults -> Open folder as vault -> select this folder
```

Use Codex in the same folder:

```bash
codex
```

Codex will read `AGENTS.md` automatically as project guidance.

## Codex CLI Setup

No plugin install is required. The simplest path is direct filesystem mode:

```bash
bin/codex-vault setup "Research vault for my AI notetaking project"
bin/codex-vault ingest .raw/example.md
bin/codex-vault query "What do we know about the hot cache?"
bin/codex-vault lint
```

To inspect the prompt instead of running Codex:

```bash
bin/codex-vault --print ingest .raw/example.md
```

You can also paste the templates from `prompts/` into an interactive Codex session.

## Main Workflow

1. Put raw material in `.raw/`.
2. Ask Codex to ingest it:

```bash
bin/codex-vault ingest .raw/articles/source.md
```

3. Codex reads the source, checks `.raw/.manifest.json`, and searches existing wiki pages.
4. Codex creates or updates wiki pages with Obsidian wikilinks and source traceability.
5. Codex updates:
   - `.raw/.manifest.json`
   - `wiki/index.md`
   - relevant folder `_index.md` files
   - `wiki/log.md`
   - `wiki/hot.md`

Done means the source has been absorbed into the persistent wiki, not merely summarized in chat.

## Ingest Sources

Supported source patterns:

- Markdown files in `.raw/`.
- Web clips saved into `.raw/articles/`.
- Meeting transcripts in `.raw/transcripts/`.
- Research notes in `.raw/research/`.
- Image descriptions saved as Markdown source notes.
- Batches of multiple files.

Rules Codex follows:

- `.raw/` source files are read-only.
- Existing pages are updated before new pages are created.
- Large sources are chunked by headings or stable ranges.
- Every durable claim should point to a source page or raw source path.
- Contradictions use Obsidian callouts and preserve both claims.

## Query and Update the Vault

Ask questions from the wiki:

```bash
bin/codex-vault query "What do we know about compounding knowledge?"
```

Codex reads `wiki/hot.md`, then `wiki/index.md`, then the smallest useful set of pages. Answers should cite wiki pages with wikilinks. If the answer is worth keeping, ask Codex to save it as a question page:

```bash
bin/codex-vault save "Save this answer as a question note about compounding knowledge"
```

Refresh continuity context:

```bash
bin/codex-vault hot
```

Run maintenance:

```bash
bin/codex-vault lint
```

## MCP Setup

MCP is optional. Codex can run the full wiki workflow with filesystem access alone.

For Codex MCP setup, see [`docs/codex-mcp.md`](docs/codex-mcp.md). The Codex path uses `~/.codex/config.toml`, trusted project `.codex/config.toml`, and `codex mcp`.

Do not use upstream Claude MCP commands as the default setup path for this fork.

## File Structure

```text
.
├── AGENTS.md                 # Codex operating protocol
├── prompts/                  # Codex workflow prompts
├── bin/codex-vault           # Codex workflow runner
├── .raw/                     # immutable sources
├── wiki/
│   ├── index.md              # master catalog
│   ├── log.md                # append-only operation history
│   ├── hot.md                # recent context cache
│   ├── overview.md
│   ├── sources/
│   ├── entities/
│   ├── concepts/
│   ├── comparisons/
│   ├── questions/
│   └── meta/
├── skills/                   # portable workflow references
├── docs/codex-mcp.md
├── CLAUDE.md                 # legacy Claude compatibility
├── commands/                 # legacy Claude command files
└── .claude-plugin/           # legacy Claude plugin manifest
```

## Troubleshooting

| Problem | Fix |
| --- | --- |
| Codex does not follow the vault protocol | Make sure you started Codex from the repository root and that `AGENTS.md` is present. |
| Ingest creates duplicate pages | Ask Codex to run `bin/codex-vault lint`, then merge duplicates and update wikilinks. |
| Source was already ingested | Check `.raw/.manifest.json`; use "force re-ingest" only when you want to reprocess changed assumptions. |
| MCP tools do not appear | Run `codex mcp list` and check `docs/codex-mcp.md`; continue in filesystem mode if MCP is unavailable. |
| Obsidian graph is noisy | Keep `.raw/` hidden in Obsidian settings and use `wiki/` for durable pages. |
| Hot cache feels stale | Run `bin/codex-vault hot` after a long session or manual edits. |

## Migrate From Upstream claude-obsidian

1. Copy or pull this fork over your existing vault carefully, preserving your `wiki/`, `.raw/`, and `.vault-meta/` folders.
2. Keep `CLAUDE.md`, `.claude-plugin/`, and `commands/` only if you still use Claude Code.
3. Start Codex from the vault root and let it read `AGENTS.md`.
4. Run:

```bash
bin/codex-vault lint
bin/codex-vault hot
```

5. Review `docs/codex-mcp.md` if you previously configured a Claude MCP server. Codex uses a different configuration file and command surface.

## Validation

Run the project tests:

```bash
make test
```

Run Codex-specific validation:

```bash
bash scripts/validate-codex-docs.sh
bash scripts/sample-codex-workflow-smoke.sh
```

## Attribution

This project is adapted from [`AgriciDaniel/claude-obsidian`](https://github.com/AgriciDaniel/claude-obsidian), created by Daniel Agrici. Original credit, project history, and community references are preserved in `ATTRIBUTION.md`, `CLAUDE.md`, historical wiki pages, and legacy compatibility files.

## License

MIT. See [`LICENSE`](LICENSE).
