#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

python3 - "$repo_root" <<'PY'
from pathlib import Path
import re
import sys

root = Path(sys.argv[1])
skills_dir = root / "skills"
failures = []

if not skills_dir.is_dir():
    failures.append("skills directory not found")
else:
    for skill in sorted(p for p in skills_dir.iterdir() if p.is_dir()):
        skill_md = skill / "SKILL.md"
        if not skill_md.exists():
            failures.append(f"{skill.name}: missing SKILL.md")
            continue

        text = skill_md.read_text(encoding="utf-8")
        match = re.match(r"^---\n(.*?)\n---", text, re.S)
        if not match:
            failures.append(f"{skill.name}: invalid or missing frontmatter")
            continue

        frontmatter = match.group(1)
        name_match = re.search(r"^name:\s*['\"]?([^'\"\n]+)['\"]?\s*$", frontmatter, re.M)
        desc_match = re.search(r"^description:\s*['\"]?(.+?)['\"]?\s*$", frontmatter, re.M)

        if not name_match:
            failures.append(f"{skill.name}: missing name")
            continue

        declared_name = name_match.group(1).strip()
        if declared_name != skill.name:
            failures.append(f"{skill.name}: name mismatch ({declared_name})")

        if not re.match(r"^[a-z0-9-]+$", declared_name):
            failures.append(f"{skill.name}: name is not hyphen-case")

        if not desc_match:
            failures.append(f"{skill.name}: missing description")

        openai_yaml = skill / "agents" / "openai.yaml"
        if openai_yaml.exists() and "default_prompt:" not in openai_yaml.read_text(encoding="utf-8"):
            failures.append(f"{skill.name}: openai.yaml missing default_prompt")

if failures:
    print("Validation failed:")
    for failure in failures:
        print(f"- {failure}")
    sys.exit(1)

print("All skills valid.")
PY
