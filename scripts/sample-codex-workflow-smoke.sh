#!/usr/bin/env bash
# Deterministic smoke test for the Codex-oriented wiki workflow contract.
# It builds a tiny sample vault and verifies index/log/hot/manifest updates.

set -euo pipefail

tmpdir="$(mktemp -d)"
trap 'rm -rf "$tmpdir"' EXIT

mkdir -p "$tmpdir/.raw" "$tmpdir/wiki/sources" "$tmpdir/wiki/concepts" "$tmpdir/wiki/entities" "$tmpdir/wiki/meta"

cat > "$tmpdir/.raw/sample.md" <<'RAW'
# Sample Source

Codex Obsidian Wiki is a persistent Markdown vault workflow. It keeps durable notes,
updates a hot cache, and preserves source traceability.
RAW

cat > "$tmpdir/wiki/index.md" <<'MD'
---
type: meta
title: "Wiki Index"
updated: 2026-06-07
---
# Wiki Index

## Sources
- [[Sample Source]] - Sample source for workflow validation.

## Concepts
- [[Persistent Markdown Vault]] - Durable notes owned by the user.
MD

cat > "$tmpdir/wiki/log.md" <<'MD'
---
type: meta
title: "Wiki Log"
updated: 2026-06-07
---
# Wiki Log

## 2026-06-07 ingest | Sample Source
- Source: `.raw/sample.md`
- Summary: [[Sample Source]]
- Pages created: [[Sample Source]], [[Persistent Markdown Vault]]
- Key insight: Codex keeps a persistent Markdown vault coherent across sessions.
MD

cat > "$tmpdir/wiki/hot.md" <<'MD'
---
type: meta
title: "Hot Cache"
updated: 2026-06-07T00:00:00
---
# Recent Context

## Key Recent Facts
- The sample vault validates Codex-oriented index, log, and hot-cache continuity.
MD

cat > "$tmpdir/wiki/sources/Sample Source.md" <<'MD'
---
type: source
title: "Sample Source"
created: 2026-06-07
updated: 2026-06-07
tags: [source, codex]
status: developing
sources:
  - ".raw/sample.md"
---
# Sample Source

This validates the Codex ingestion contract.
MD

cat > "$tmpdir/.raw/.manifest.json" <<'JSON'
{
  "sources": {
    ".raw/sample.md": {
      "hash": "sample-smoke",
      "ingested_at": "2026-06-07",
      "pages_created": ["wiki/sources/Sample Source.md"],
      "pages_updated": ["wiki/index.md", "wiki/log.md", "wiki/hot.md"]
    }
  }
}
JSON

test -s "$tmpdir/wiki/index.md"
test -s "$tmpdir/wiki/log.md"
test -s "$tmpdir/wiki/hot.md"
test -s "$tmpdir/.raw/.manifest.json"
grep -q '\[\[Sample Source\]\]' "$tmpdir/wiki/index.md"
grep -q 'ingest | Sample Source' "$tmpdir/wiki/log.md"
grep -q 'Recent Context' "$tmpdir/wiki/hot.md"
python3 -m json.tool "$tmpdir/.raw/.manifest.json" >/dev/null

echo "Sample Codex workflow smoke test passed."
