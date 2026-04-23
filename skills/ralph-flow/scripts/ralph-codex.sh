#!/usr/bin/env zsh
set -euo pipefail

script_name="${0:t}"
codex_bin="${CODEX_BIN:-codex}"
project_dir="$PWD"
prd_file=""
progress_file=""
max_iterations=10
model=""
sandbox="workspace-write"
dry_run=0
dangerous=0
commit=0
checkout_branch=0

usage() {
  cat <<EOF
Usage: $script_name [options]

Run a Ralph-style Codex loop over prd.json.

Options:
  --project DIR          Project root. Default: current directory
  --prd FILE             PRD JSON file. Default: <project>/prd.json
  --progress FILE        Progress log. Default: <project>/progress.txt
  --max-iterations N     Max Codex iterations. Default: 10
  --model MODEL          Optional Codex model
  --sandbox MODE         Codex sandbox mode. Default: workspace-write
  --dangerous            Use Codex dangerous no-sandbox mode
  --commit               Ask Codex to commit a completed story
  --checkout-branch      Create/switch to prd.json branchName before running
  --dry-run              Print the next iteration prompt and exit
  -h, --help             Show this help

Examples:
  $script_name --project . --dry-run
  $script_name --project ~/Desktop/my-app --max-iterations 5
EOF
}

die() {
  print -ru2 -- "[ralph-codex] $*"
  exit 1
}

abs_path() {
  local path="$1"
  if [[ "$path" == /* ]]; then
    print -r -- "$path"
  else
    print -r -- "$PWD/$path"
  fi
}

project_path() {
  local path="$1"
  if [[ "$path" == /* ]]; then
    print -r -- "$path"
  else
    print -r -- "$project_dir/$path"
  fi
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --project)
      [[ $# -ge 2 ]] || die "--project requires a value"
      project_dir="$2"
      shift 2
      ;;
    --project=*)
      project_dir="${1#*=}"
      shift
      ;;
    --prd)
      [[ $# -ge 2 ]] || die "--prd requires a value"
      prd_file="$2"
      shift 2
      ;;
    --prd=*)
      prd_file="${1#*=}"
      shift
      ;;
    --progress)
      [[ $# -ge 2 ]] || die "--progress requires a value"
      progress_file="$2"
      shift 2
      ;;
    --progress=*)
      progress_file="${1#*=}"
      shift
      ;;
    --max-iterations)
      [[ $# -ge 2 ]] || die "--max-iterations requires a value"
      max_iterations="$2"
      shift 2
      ;;
    --max-iterations=*)
      max_iterations="${1#*=}"
      shift
      ;;
    --model)
      [[ $# -ge 2 ]] || die "--model requires a value"
      model="$2"
      shift 2
      ;;
    --model=*)
      model="${1#*=}"
      shift
      ;;
    --sandbox)
      [[ $# -ge 2 ]] || die "--sandbox requires a value"
      sandbox="$2"
      shift 2
      ;;
    --sandbox=*)
      sandbox="${1#*=}"
      shift
      ;;
    --dangerous)
      dangerous=1
      shift
      ;;
    --commit)
      commit=1
      shift
      ;;
    --checkout-branch)
      checkout_branch=1
      shift
      ;;
    --dry-run)
      dry_run=1
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      die "unknown option: $1"
      ;;
  esac
done

[[ "$max_iterations" == <-> ]] || die "--max-iterations must be a positive integer"
(( max_iterations > 0 )) || die "--max-iterations must be greater than zero"

project_dir="$(abs_path "$project_dir")"
[[ -d "$project_dir" ]] || die "project directory does not exist: $project_dir"

[[ -n "$prd_file" ]] || prd_file="$project_dir/prd.json"
[[ -n "$progress_file" ]] || progress_file="$project_dir/progress.txt"
prd_file="$(project_path "$prd_file")"
progress_file="$(project_path "$progress_file")"

command -v jq >/dev/null 2>&1 || die "jq is required"
command -v "$codex_bin" >/dev/null 2>&1 || die "Codex CLI not found: $codex_bin"
[[ -f "$prd_file" ]] || die "prd.json not found: $prd_file"

jq -e '.userStories and (.userStories | type == "array")' "$prd_file" >/dev/null \
  || die "prd.json must contain a userStories array"

mkdir -p "${progress_file:h}" "$project_dir/.ralph"
if [[ ! -f "$progress_file" ]]; then
  {
    print -r -- "# Ralph Progress Log"
    print -r -- "Started: $(date '+%Y-%m-%d %H:%M:%S')"
    print -r -- "---"
  } > "$progress_file"
fi

branch_name="$(jq -r '.branchName // empty' "$prd_file")"
if (( checkout_branch )) && [[ -n "$branch_name" ]]; then
  git -C "$project_dir" rev-parse --is-inside-work-tree >/dev/null 2>&1 \
    || die "--checkout-branch requires a git repository"
  if git -C "$project_dir" rev-parse --verify "$branch_name" >/dev/null 2>&1; then
    git -C "$project_dir" switch "$branch_name"
  else
    git -C "$project_dir" switch -c "$branch_name"
  fi
fi

story_count() {
  jq '[.userStories[] | select(.passes != true)] | length' "$prd_file"
}

next_story_json() {
  jq -c '
    [.userStories[] | select(.passes != true)]
    | sort_by(.priority // 999999, .id // "")
    | first // empty
  ' "$prd_file"
}

write_prompt() {
  local story_json="$1"
  local story_id="$2"
  local story_title="$3"
  local commit_instruction

  if (( commit )); then
    commit_instruction="If all verification passes and this is a git repository, create one focused commit for ${story_id}. Use the repository commit style if documented."
  else
    commit_instruction="Do not create a git commit unless project instructions explicitly require it."
  fi

  cat <<EOF
You are running one Ralph Codex iteration.

Project root: $project_dir
PRD file: $prd_file
Progress file: $progress_file
Branch name from PRD: ${branch_name:-"(none)"}

Work only on this story:

\`\`\`json
$story_json
\`\`\`

Rules:
- Read the project instructions and relevant code before editing.
- Implement only the selected story: $story_id - $story_title.
- Do not start later stories or unrelated refactors.
- Keep the diff small and reversible.
- Run the verification needed by the story acceptance criteria.
- If verification passes, update only this story in prd.json:
  - set passes to true
  - add concise notes with verification evidence
- If verification does not pass, leave passes as false and record the blocker in notes.
- Append a timestamped entry to progress.txt with:
  - story id and title
  - changed files
  - verification run and result
  - blockers or learnings for future iterations
- $commit_instruction

Completion signal:
- If this story passes and all stories in prd.json are now passes:true, include <promise>COMPLETE</promise> in your final message.
- Otherwise include the next useful status, but do not include the COMPLETE promise.
EOF
}

for iteration in $(seq 1 "$max_iterations"); do
  remaining="$(story_count)"
  if [[ "$remaining" == "0" ]]; then
    print -r -- "[ralph-codex] all stories complete"
    print -r -- "<promise>COMPLETE</promise>"
    exit 0
  fi

  story_json="$(next_story_json)"
  [[ -n "$story_json" ]] || die "could not select next story"
  story_id="$(jq -r '.id // "UNKNOWN"' <<< "$story_json")"
  story_title="$(jq -r '.title // "(untitled)"' <<< "$story_json")"
  timestamp="$(date '+%Y%m%d-%H%M%S')"
  safe_story_id="$(printf '%s' "$story_id" | tr -c '[:alnum:]_-' '-')"
  prompt_file="$project_dir/.ralph/prompt-${timestamp}-${safe_story_id}.md"
  output_file="$project_dir/.ralph/output-${timestamp}-${safe_story_id}.txt"

  write_prompt "$story_json" "$story_id" "$story_title" > "$prompt_file"

  print -r -- "[ralph-codex] iteration $iteration/$max_iterations: $story_id - $story_title"
  print -r -- "[ralph-codex] remaining stories: $remaining"
  print -r -- "[ralph-codex] prompt: $prompt_file"

  if (( dry_run )); then
    print -r -- "----- prompt preview -----"
    sed -n '1,220p' "$prompt_file"
    exit 0
  fi

  codex_args=(exec --cd "$project_dir" --output-last-message "$output_file")
  if (( dangerous )); then
    codex_args+=(--dangerously-bypass-approvals-and-sandbox)
  else
    codex_args+=(--full-auto --sandbox "$sandbox")
  fi
  [[ -z "$model" ]] || codex_args+=(-m "$model")
  codex_args+=(-)

  "$codex_bin" "${codex_args[@]}" < "$prompt_file"

  if jq -e --arg id "$story_id" '
    .userStories[]
    | select(.id == $id)
    | .passes == true
  ' "$prd_file" >/dev/null; then
    print -r -- "[ralph-codex] story marked passing: $story_id"
  else
    print -r -- "[ralph-codex] story still not passing: $story_id"
  fi
done

remaining="$(story_count)"
if [[ "$remaining" == "0" ]]; then
  print -r -- "[ralph-codex] all stories complete"
  print -r -- "<promise>COMPLETE</promise>"
  exit 0
fi

print -ru2 -- "[ralph-codex] reached max iterations with $remaining stories still incomplete"
print -ru2 -- "[ralph-codex] check $progress_file and $prd_file"
exit 1
