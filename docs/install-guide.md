# codex-obsidian-wiki Install Guide

Codex + Obsidian persistent wiki vault.

This guide is for the Codex CLI fork of [`AgriciDaniel/claude-obsidian`](https://github.com/AgriciDaniel/claude-obsidian). The upstream project credit and MIT license are preserved.

## Prerequisites

| Tool | Required | Notes |
| --- | --- | --- |
| Codex CLI | Yes | Verify with `codex --version`. |
| Obsidian | Yes | Download from https://obsidian.md. |
| Git | Yes | Used for cloning and local history. |
| Python 3 | Recommended | Used by validation and retrieval helper scripts. |
| MCP | Optional | Codex can operate directly over Markdown files. |

## Install as a Vault

```bash
git clone https://github.com/25xr7yrs2y-oss/codex-obsidian-wiki.git
cd codex-obsidian-wiki
bash bin/setup-vault.sh
```

Open the folder in Obsidian:

```text
Manage Vaults -> Open folder as vault -> select codex-obsidian-wiki/
```

Start Codex from the same folder:

```bash
codex
```

Codex reads `AGENTS.md` as the project operating protocol.

## Run the Main Workflows

Scaffold or continue the vault:

```bash
bin/codex-vault setup "Personal research vault for AI notetaking"
```

Ingest a source:

```bash
mkdir -p .raw/articles
cp /path/to/source.md .raw/articles/source.md
bin/codex-vault ingest .raw/articles/source.md
```

Ask a question:

```bash
bin/codex-vault query "What do we know about the source-first synthesis pattern?"
```

Run maintenance:

```bash
bin/codex-vault lint
```

Refresh recent context:

```bash
bin/codex-vault hot
```

## Prompt-Only Use

If you prefer an interactive Codex session, print a workflow prompt and paste it into Codex:

```bash
bin/codex-vault --print ingest .raw/articles/source.md
```

Prompt templates live in `prompts/`.

## Optional MCP

Codex MCP setup is documented in [`docs/codex-mcp.md`](codex-mcp.md).

The short version:

- Codex uses `~/.codex/config.toml` for user-level configuration.
- Trusted projects may use `.codex/config.toml`.
- MCP servers are configured under `[mcp_servers.<name>]`.
- The CLI command surface is `codex mcp`.

MCP is not required. Filesystem mode is the fallback and supports the core wiki workflow.

## Optional DragonScale and Retrieval

The upstream project includes optional DragonScale and retrieval helpers. They remain available:

```bash
bash bin/setup-dragonscale.sh
bash bin/setup-retrieve.sh
bash bin/setup-mode.sh
```

These are optional. The Codex wiki workflow works without them.

## Obsidian Plugins

The bundled vault configuration includes useful defaults. Recommended community plugins:

| Plugin | Purpose |
| --- | --- |
| Dataview | Dashboard queries. |
| Templater | Template automation. |
| Obsidian Git | Local safety commits. |
| Calendar | Daily note navigation. |
| Excalidraw | Visual notes and diagrams. |

## Validate the Install

```bash
bash scripts/validate-codex-docs.sh
bash scripts/sample-codex-workflow-smoke.sh
make test
```

Expected results:

- Codex docs and helper validation passes.
- Sample workflow smoke test confirms `index/log/hot/manifest` behavior.
- Script test suite passes.

## Migrate From Upstream

If you already have a `claude-obsidian` vault:

1. Back up the vault.
2. Preserve your `wiki/`, `.raw/`, and `.vault-meta/` folders.
3. Add this fork's `AGENTS.md`, `prompts/`, `bin/codex-vault`, and `docs/codex-mcp.md`.
4. Keep `CLAUDE.md`, `.claude-plugin/`, and `commands/` only for legacy Claude Code usage.
5. Run `bin/codex-vault lint` and review the report before doing large ingests.
6. Run `bin/codex-vault hot` so Codex starts future sessions with recent context.

## Troubleshooting

| Problem | Fix |
| --- | --- |
| Codex ignores the vault rules | Start Codex from the vault root and ensure `AGENTS.md` exists. |
| Helper cannot find Codex | Install or update Codex CLI, then rerun `codex --version`. |
| MCP is unavailable | Continue in filesystem mode; MCP is optional. |
| Duplicate pages appear | Run the lint workflow and merge duplicates before further ingest. |
| Obsidian does not show graph colors | Re-run `bash bin/setup-vault.sh` and reopen the vault. |
