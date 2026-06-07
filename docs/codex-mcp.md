# Codex MCP Setup

MCP is optional for codex-obsidian-wiki. Codex can maintain the vault by reading and writing Markdown files directly. Use MCP only when you want Codex to access Obsidian-specific tools, a Local REST API bridge, or another vault-aware server.

## What Was Verified

- Local Codex CLI is available and reports `codex-cli 0.130.0`.
- `codex --help` and `codex exec --help` are available locally.
- Current OpenAI Codex documentation says Codex stores user configuration in `~/.codex/config.toml`, can use trusted project `.codex/config.toml`, and configures MCP servers under `[mcp_servers.<server-name>]`.
- Current OpenAI Codex documentation says MCP can be managed with `codex mcp`, and `/mcp` in the Codex TUI shows active servers.

References:

- OpenAI Codex MCP docs: https://developers.openai.com/codex/mcp
- OpenAI Codex config reference: https://developers.openai.com/codex/config-reference

## What Remains User-Configurable

- Which Obsidian MCP server you prefer.
- Whether secrets live in shell environment variables or inline in `~/.codex/config.toml`.
- Whether configuration is global (`~/.codex/config.toml`) or project-scoped (`.codex/config.toml` in a trusted project).
- Whether Codex should require the server at startup with `required = true`.

## Recommended: Filesystem MCPVault

This option does not require the Obsidian Local REST API plugin.

```bash
codex mcp add obsidian-vault -- npx -y @bitbonsai/mcpvault@latest /absolute/path/to/your/vault
```

Equivalent TOML:

```toml
[mcp_servers.obsidian-vault]
command = "npx"
args = ["-y", "@bitbonsai/mcpvault@latest", "/absolute/path/to/your/vault"]
startup_timeout_sec = 20
tool_timeout_sec = 60
```

## REST API Option: mcp-obsidian

This option requires the Obsidian Local REST API plugin.

1. In Obsidian, install and enable the Local REST API community plugin.
2. Copy its API key.
3. Export the key in your shell profile or current terminal:

```bash
export OBSIDIAN_API_KEY="your-key"
```

4. Add the server:

```bash
codex mcp add obsidian-vault \
  --env OBSIDIAN_API_KEY="$OBSIDIAN_API_KEY" \
  --env OBSIDIAN_HOST=127.0.0.1 \
  --env OBSIDIAN_PORT=27124 \
  --env NODE_TLS_REJECT_UNAUTHORIZED=0 \
  -- uvx mcp-obsidian
```

Equivalent TOML:

```toml
[mcp_servers.obsidian-vault]
command = "uvx"
args = ["mcp-obsidian"]
startup_timeout_sec = 20
tool_timeout_sec = 60

[mcp_servers.obsidian-vault.env]
OBSIDIAN_API_KEY = "your-key"
OBSIDIAN_HOST = "127.0.0.1"
OBSIDIAN_PORT = "27124"
NODE_TLS_REJECT_UNAUTHORIZED = "0"
```

Security note: `NODE_TLS_REJECT_UNAUTHORIZED = "0"` disables TLS certificate verification for the MCP server process. Use it only for the localhost Obsidian REST API self-signed certificate. Prefer MCPVault or direct filesystem mode if you do not want that bypass.

## Verify MCP in Codex

```bash
codex mcp --help
codex mcp list
```

In interactive Codex, use:

```text
/mcp
```

Then ask Codex to list or read a known note in `wiki/`.

## Fallback Without MCP

No MCP is required for the core workflow.

Use:

```bash
bin/codex-vault ingest .raw/example.md
bin/codex-vault query "What do we know about this topic?"
bin/codex-vault lint
```

Codex will use normal filesystem access to maintain `.raw/`, `wiki/`, and `.vault-meta/`.

## Legacy Claude MCP

The upstream project used Claude-specific MCP commands. Those commands are kept only in legacy Claude documentation. They are not the main setup path for this Codex fork.
