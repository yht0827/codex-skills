#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source_dir="$repo_root/skills"
codex_home="${CODEX_HOME:-$HOME/.codex}"
target_dir="$codex_home/skills"

if [ ! -d "$source_dir" ]; then
  echo "[install] skills directory not found: $source_dir" >&2
  exit 1
fi

mkdir -p "$target_dir"

for skill_path in "$source_dir"/*; do
  [ -d "$skill_path" ] || continue
  skill_name="$(basename "$skill_path")"
  if [ ! -f "$skill_path/SKILL.md" ]; then
    echo "[install] skip $skill_name: missing SKILL.md" >&2
    continue
  fi
  mkdir -p "$target_dir/$skill_name"
  rsync -a --delete --exclude '.DS_Store' "$skill_path/" "$target_dir/$skill_name/"
  echo "[install] installed $skill_name"
done

echo "[install] done: $target_dir"
