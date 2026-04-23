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
