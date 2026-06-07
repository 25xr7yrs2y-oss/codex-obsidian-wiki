# MCP Setup

MCP lets Codex use Obsidian-aware tools, but it is optional. The default codex-obsidian-wiki workflow works through direct Markdown file access.

For the full current Codex setup guide, read [`docs/codex-mcp.md`](../../../docs/codex-mcp.md).

## Recommended Order

1. **Filesystem mode**: no MCP, always available.
2. **Obsidian CLI**: use `obsidian-cli` when available; detected by `scripts/detect-transport.sh`.
3. **MCPVault**: filesystem-based MCP server, no Obsidian plugin required.
4. **mcp-obsidian**: Local REST API based MCP server, useful when you want REST-backed note operations.

## Codex Configuration Shape

Codex stores MCP settings in `~/.codex/config.toml` or trusted project `.codex/config.toml`.

Each server uses a table:

```toml
[mcp_servers.obsidian-vault]
command = "npx"
args = ["-y", "@bitbonsai/mcpvault@latest", "/absolute/path/to/your/vault"]
startup_timeout_sec = 20
tool_timeout_sec = 60
```

You can also add servers with:

```bash
codex mcp add obsidian-vault -- npx -y @bitbonsai/mcpvault@latest /absolute/path/to/your/vault
```

Verify with:

```bash
codex mcp list
```

In interactive Codex, use `/mcp`.

## Local REST API Notes

If using mcp-obsidian:

1. Install the Obsidian Local REST API community plugin.
2. Copy the API key.
3. Configure Codex MCP with the API key and localhost settings as shown in `docs/codex-mcp.md`.

Security note: the Local REST API plugin uses a self-signed localhost certificate. Some MCP setups use `NODE_TLS_REJECT_UNAUTHORIZED = "0"` for that local process. Use this only for `127.0.0.1`.

## Legacy Claude Code

The upstream project included Claude Code MCP commands. They remain relevant only when running the legacy `.claude-plugin/` path. Codex users should use `codex mcp` and `config.toml` instead.
