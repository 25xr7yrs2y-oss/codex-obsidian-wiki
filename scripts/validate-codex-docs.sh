#!/usr/bin/env bash
# Validate that Codex-first documentation and prompt helpers are present.

set -euo pipefail

required=(
  AGENTS.md
  README.md
  docs/codex-mcp.md
  prompts/wiki.md
  prompts/ingest.md
  prompts/query.md
  prompts/lint.md
  prompts/hot.md
  bin/codex-vault
)

for path in "${required[@]}"; do
  if [ ! -e "$path" ]; then
    echo "missing required Codex path: $path" >&2
    exit 1
  fi
done

if ! grep -q "Codex CLI Operating Protocol" AGENTS.md; then
  echo "AGENTS.md does not contain the Codex operating protocol" >&2
  exit 1
fi

if grep -nE "claude plugin marketplace add|claude plugin install|claude mcp add-json|claude mcp list" README.md docs/install-guide.md docs/codex-mcp.md AGENTS.md; then
  echo "Claude-first setup command found in the Codex main path" >&2
  exit 1
fi

rendered_prompt="$(bin/codex-vault --print ingest .raw/example.md)"
if ! printf '%s\n' "$rendered_prompt" | grep -q "Source Ingest"; then
  echo "bin/codex-vault did not render the ingest prompt" >&2
  exit 1
fi

echo "Codex docs and helper validation passed."
