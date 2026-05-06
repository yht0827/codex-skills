# Workflow

This repo keeps the user's Codex workflow portable across machines and accounts.

## Feature Work

```text
idea
  -> $prd
  -> tasks/prd-[feature].md
  -> $ralph-json
  -> prd.json
  -> $tdd-team or $ralph-flow
```

Use `$tdd-team` when strict role separation and visible tmux panes matter.
Use `$ralph-flow` when the work is long and can be repeated story by story.
Use `$diagnose` before implementation when the bug cause is not yet proven.

## TDD Team

`$tdd-team` opens a 4-pane tmux team:

- `team-lead`: requirements, task splitting, phase gates
- `red`: failing tests only
- `green`: minimum production code only
- `refactor`: behavior-preserving cleanup only

The generated prompts live under the project:

```text
.tdd-team/prompts/
```

## Ralph JSON

`$ralph-json` creates a `prd.json` backlog:

```json
{
  "project": "ProjectName",
  "branchName": "ralph/feature-name",
  "description": "Feature description",
  "userStories": []
}
```

Each story should be small enough for one focused iteration.
Mark each story as `AFK` or `HITL`:

- `AFK`: Codex can implement the story with the written acceptance criteria.
- `HITL`: the story needs product, design, domain, access, or manual approval.

Use `blockedBy` to list prerequisite story IDs. `$ralph-flow` selects only incomplete `AFK` stories whose blockers are already `passes:true`.

See `examples/ralph-prd.json` for a small working shape.

## Diagnose

Use `$diagnose` for unclear bugs, flaky behavior, failing tests, and performance regressions.

The expected shape is:

```text
repro loop -> reproduce symptom -> hypotheses -> instrument -> regression test -> fix -> cleanup
```

Do not start with a speculative fix if there is no runnable pass/fail signal.

## Session Handoff

Before stopping a long session:

```text
$handoff
```

At the start of the next session:

```text
$catchup
```

`$catchup` treats handoff notes as hypotheses and verifies them against live files and git state before any implementation.

## Codebase Reading

Use `$code-explore` before modifying unfamiliar code.
Use `$code-quality` when you need risk-based improvement priorities.

## Spring Learning Projects

Use `$spring-boot-init` for small Spring Boot projects, especially web/JSON API and JPA/H2 learning projects.
