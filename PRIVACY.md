# Privacy

## Data Handling

codex-obsidian-wiki is a Codex CLI-oriented Obsidian vault system that runs over
plain Markdown files on your local filesystem. The project code does not collect,
transmit, or store personal data, and it includes no telemetry, analytics, or
usage tracking.

The upstream project was `claude-obsidian`; legacy Claude Code assets may remain
in the repository for compatibility, but they are not the default path in this
fork.

## What Stays Local

- Ingesting sources, answering queries, linting, and updating the hot cache run
  through Codex CLI prompts or direct filesystem scripts.
- All wiki content (`wiki/`) is plain Markdown saved to your local filesystem.
- The `wiki-retrieve` BM25 index and optional ollama-based reranking run fully
  locally. Without an explicit opt-in flag, retrieval never leaves your machine.

## Optional Network Egress (opt-in, consent-gated)

Network calls happen only when you explicitly enable them. By default everything
is local.

| Feature | Service | Data sent | Gate |
|---------|---------|-----------|------|
| `wiki-retrieve` contextual prefix | Optional configured model provider | Wiki page chunks for prefix generation | Off by default. Requires the `--allow-egress` consent flag on `scripts/contextual-prefix.py`; without it, retrieval uses local or synthetic prefixes. |
| `autoresearch` | Web search + fetch | Your research query and fetched URLs | Opt-in; only runs when you invoke the research loop. |
| `defuddle` | Web fetch | URLs you ask it to extract | Opt-in; only runs when you invoke it. |
| ollama rerank | `localhost` only | Query + candidate chunks | Local by default. Remote ollama hosts are refused unless you pass `--allow-remote-ollama`. |
| Codex MCP servers | User-configured MCP process | Whatever that server is configured to read or send | Optional. Configure explicitly in Codex; the filesystem workflow works without MCP. |

## Credentials

- API keys are read from environment variables or your local `.env`, never
  hard-coded by this project.
- Credentials are never committed to the repository (blocked by `.gitignore`).
- The included demo vault and configuration ship with placeholder values only.

## Security Disclosure

To report a security or privacy issue, see [`SECURITY.md`](SECURITY.md).
