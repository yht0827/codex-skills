#!/usr/bin/env zsh
set -euo pipefail

script_dir="${0:A:h}"
subject="$script_dir/ralph-codex.sh"
tmpdir="$(mktemp -d)"
trap 'rm -rf "$tmpdir"' EXIT

project="$tmpdir/project"
mkdir -p "$project"

cat > "$project/prd.json" <<'JSON'
{
  "project": "TestProject",
  "branchName": "ralph/test-project",
  "description": "Test PRD",
  "userStories": [
    {
      "id": "US-001",
      "title": "Already done",
      "description": "Done story",
      "acceptanceCriteria": ["Typecheck passes"],
      "priority": 1,
      "passes": true,
      "notes": "done"
    },
    {
      "id": "US-002",
      "title": "Next story",
      "description": "Next story",
      "acceptanceCriteria": ["Typecheck passes"],
      "priority": 2,
      "passes": false,
      "notes": ""
    }
  ]
}
JSON

output="$("$subject" --project "$project" --dry-run --max-iterations 1)"

if ! print -r -- "$output" | grep -q 'US-002 - Next story'; then
  echo "expected dry-run to select first incomplete story" >&2
  exit 1
fi

if ! test -f "$project/progress.txt"; then
  echo "expected progress.txt to be initialized" >&2
  exit 1
fi

relative_output="$(
  cd "$tmpdir"
  "$subject" --project project --prd prd.json --progress progress-relative.txt --dry-run --max-iterations 1
)"

if ! print -r -- "$relative_output" | grep -q 'PRD file: '"$project"'/prd.json'; then
  echo "expected relative --prd to resolve from project root" >&2
  exit 1
fi

if ! test -f "$project/progress-relative.txt"; then
  echo "expected relative --progress to resolve from project root" >&2
  exit 1
fi

cat > "$project/prd.json" <<'JSON'
{
  "project": "TestProject",
  "branchName": "ralph/test-project",
  "description": "Test PRD",
  "userStories": [
    {
      "id": "US-001",
      "title": "Done",
      "description": "Done",
      "acceptanceCriteria": ["Typecheck passes"],
      "priority": 1,
      "passes": true,
      "notes": "done"
    }
  ]
}
JSON

complete_output="$("$subject" --project "$project" --dry-run --max-iterations 1)"
if ! print -r -- "$complete_output" | grep -q '<promise>COMPLETE</promise>'; then
  echo "expected complete PRD to emit COMPLETE promise" >&2
  exit 1
fi

echo "ok"
