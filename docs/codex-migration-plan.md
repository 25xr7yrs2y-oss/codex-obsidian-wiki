# Codex Migration Plan

This was the working migration plan used to adapt the upstream Claude Code-first project into a Codex CLI-first fork.

## Audit Findings

- Root documentation (`README.md`, `docs/install-guide.md`, `WIKI.md`, `CLAUDE.md`) presented Claude Code as the default runtime.
- Claude plugin files (`.claude-plugin/`) and slash command files (`commands/`) were first-class installation paths.
- MCP instructions used `claude mcp add-json`, `claude mcp list`, and Claude-specific verification.
- Several skills referenced Claude tools directly (`Read`, `Write`, `Edit`, WebFetch, slash commands), even though most workflow logic is portable.
- Existing `AGENTS.md` mentioned Codex but delegated important context back to `CLAUDE.md`.
- Tests covered vault helper scripts but not Codex-oriented documentation, prompt templates, or helper command wiring.

## Migration Strategy

1. Make Codex CLI the default path with a complete root `AGENTS.md`.
2. Preserve upstream Claude support as legacy compatibility rather than deleting it.
3. Replace slash command assumptions with prompt templates in `prompts/` and a `bin/codex-vault` runner.
4. Rewrite README and install docs around Codex CLI setup, source ingestion, querying, linting, and migration from upstream.
5. Replace main MCP instructions with Codex `config.toml` and `codex mcp` guidance, while keeping Claude MCP commands in a legacy section.
6. Add validation for docs, prompts, and a small sample wiki workflow so future changes do not regress the Codex path.

## Main Compatibility Boundary

Codex is the maintained default path. Claude-specific files remain only for users who still use Claude Code or need to migrate existing vaults.
