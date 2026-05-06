#!/usr/bin/env zsh
set -euo pipefail

file="${1:-prd.json}"

die() {
  print -ru2 -- "[ralph-json] $*"
  exit 1
}

command -v jq >/dev/null 2>&1 || die "jq is required"
[[ -f "$file" ]] || die "file not found: $file"

jq empty "$file" >/dev/null || die "invalid JSON: $file"

jq -e '
  type == "object"
  and (.project | type == "string" and length > 0)
  and (.branchName | type == "string" and test("^ralph/[a-z0-9][a-z0-9-]*$"))
  and (.description | type == "string" and length > 0)
  and (.userStories | type == "array" and length > 0)
' "$file" >/dev/null || die "top-level schema is invalid"

count="$(jq '.userStories | length' "$file")"
ids="$(jq -r '.userStories[].id' "$file" | sort)"
unique_ids="$(jq -r '.userStories[].id' "$file" | sort -u)"

if [[ "$(print -r -- "$ids" | wc -l | tr -d ' ')" != "$(print -r -- "$unique_ids" | wc -l | tr -d ' ')" ]]; then
  die "duplicate story ids found"
fi

for i in $(seq 0 $((count - 1))); do
  story_label="$(jq -r --argjson i "$i" '.userStories[$i].id // ("index " + ($i|tostring))' "$file")"

  jq -e --argjson i "$i" '
    .userStories[$i]
    | type == "object"
    and (.id | type == "string" and test("^US-[0-9]{3}$"))
    and (.title | type == "string" and length > 0)
    and (.description | type == "string" and length > 0)
    and (.acceptanceCriteria | type == "array" and length > 0)
    and all(.acceptanceCriteria[]; type == "string" and length > 0)
    and (.priority | type == "number")
    and ((.type == null) or (.type == "AFK" or .type == "HITL"))
    and ((.blockedBy == null) or (.blockedBy | type == "array" and all(.[]; type == "string" and test("^US-[0-9]{3}$"))))
    and (.passes | type == "boolean")
    and (.notes | type == "string")
  ' "$file" >/dev/null || die "invalid story schema: $story_label"

  jq -e --argjson i "$i" '
    .userStories[$i].acceptanceCriteria
    | any(. == "Typecheck passes")
  ' "$file" >/dev/null || die "missing Typecheck passes: $story_label"

  jq -e --argjson i "$i" '
    .userStories[$i].passes == false
  ' "$file" >/dev/null || die "new prd.json stories must start with passes:false: $story_label"
done

priority_count="$(jq '[.userStories[].priority] | length' "$file")"
priority_unique_count="$(jq '[.userStories[].priority] | unique | length' "$file")"
[[ "$priority_count" == "$priority_unique_count" ]] || die "story priorities must be unique"

jq -e '
  [.userStories[].id] as $ids
  | all(.userStories[]; all((.blockedBy // [])[]; . as $dep | ($ids | index($dep)) != null))
' "$file" >/dev/null || die "blockedBy references unknown story id"

jq -e '
  all(.userStories[]; .id as $id | all((.blockedBy // [])[]; . != $id))
' "$file" >/dev/null || die "story cannot block itself"

print -r -- "[ralph-json] valid: $file"
print -r -- "[ralph-json] stories: $count"
