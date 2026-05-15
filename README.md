# Codex Skills

Portable Codex skills for PRD writing, Ralph-style story tracking, TDD team workflows, codebase analysis, design prototyping, session handoff, and Spring Boot project setup.

Korean documentation: [README.ko.md](README.ko.md)

This repository is a plain file-based skill toolkit. It is not a Claude Code marketplace package. Install copies the folders under `skills/` into `~/.codex/skills/` so Codex can discover them locally.

## Skills

### Planning And Execution

- [`$prd`](skills/prd/SKILL.md): turn feature ideas and requirements into implementation-ready PRDs
- [`$ralph-json`](skills/ralph-json/SKILL.md): convert PRDs or requirements into Ralph-style `prd.json` backlogs
- [`$ralph-flow`](skills/ralph-flow/SKILL.md): run long PRD work story by story from `prd.json`
- [`$tdd-team`](skills/tdd-team/SKILL.md): open a Team Lead / Red / Green / Refactor TDD workflow

### Code Reading And Review

- [`$code-explore`](skills/code-explore/SKILL.md): map unfamiliar codebases, entrypoints, dependencies, and test flow
- [`$code-review-graph`](skills/code-review-graph/SKILL.md): inspect graph-based review context and change impact radius
- [`$code-quality`](skills/code-quality/SKILL.md): assess code quality, test quality, security, performance, and maintenance risk
- [`$diagnose`](skills/diagnose/SKILL.md): narrow bugs, failing tests, flaky behavior, and regressions through a repro loop

### Design And Prototyping

- [`$open-design`](skills/open-design/SKILL.md): guide Open Design setup, Codex connection, and design artifact generation

### Session And Setup

- [`$handoff`](skills/handoff/SKILL.md): write a handoff note for the next Codex session
- [`$catchup`](skills/catchup/SKILL.md): verify a prior handoff against live files and git state
- [`$spring-boot-init`](skills/spring-boot-init/SKILL.md): create small Spring Boot projects from Spring Initializr
- [`$superpowers-flow`](skills/superpowers-flow/SKILL.md): explain the Superpowers-first workflow and Compound capture step
- [`$quick-help`](skills/quick-help/SKILL.md): show a short everyday command list
- [`$guide`](skills/guide/SKILL.md): list installed skills and prompts

## Install

Clone this repo and run:

```bash
git clone https://github.com/yht0827/codex-skills.git
cd codex-skills
./scripts/install.sh
```

The installer copies each folder under `skills/` into `~/.codex/skills/`.
It only replaces matching skill folders. It does not delete unrelated skills.

To install into a different Codex home:

```bash
CODEX_HOME="$HOME/.codex-other" ./scripts/install.sh
```

## Update

```bash
cd codex-skills
git pull --ff-only
./scripts/install.sh
```

## Validate

```bash
./scripts/validate.sh
```

The validator checks that every skill has `SKILL.md`, valid frontmatter basics, and a matching `name`.
`$ralph-json` also includes a stricter validator for `prd.json` story shape.

## Typical Workflow

- [`$prd`](skills/prd/SKILL.md) -> write a clear feature PRD
- [`$ralph-json`](skills/ralph-json/SKILL.md) -> convert PRD to prd.json
- [`$diagnose`](skills/diagnose/SKILL.md) -> build a repro loop before fixing unclear bugs
- [`$code-review-graph`](skills/code-review-graph/SKILL.md) -> inspect graph context or change blast radius
- [`$open-design`](skills/open-design/SKILL.md) -> create or inspect design artifacts when needed
- [`$tdd-team`](skills/tdd-team/SKILL.md) -> implement one story through Red / Green / Refactor panes
- [`$ralph-flow`](skills/ralph-flow/SKILL.md) -> optionally run multiple stories through an automated loop
- [`$handoff`](skills/handoff/SKILL.md) -> write session handoff before stopping
- [`$catchup`](skills/catchup/SKILL.md) -> verify handoff in the next session

See [docs/workflow.md](docs/workflow.md) for the longer flow.

## Quick Examples

Small feature:

```text
Use Superpowers for brainstorming/planning
-> implement with TDD
-> verify before completion
```

Large feature:

```text
$prd "Write a notifications feature PRD"
-> $ralph-json "Convert tasks/prd-notifications.md into prd.json"
-> $tdd-team "Run the next prd.json story with TDD"
```

Design prototype:

```text
$open-design "Prepare a dashboard prototype workflow with Codex"
```

Ralph story metadata:

```json
{
  "type": "AFK",
  "blockedBy": ["US-001"]
}
```

Use `AFK` for story slices Codex can run alone, `HITL` for slices that need human judgment. `blockedBy` keeps `$ralph-flow` from starting a story before its dependencies pass. See [examples/ralph-prd.json](examples/ralph-prd.json).

Growing commerce project:

```text
tasks/prd-commerce-mvp.md
tasks/prd-coupon.md
tasks/prd-product-review.md
tasks/prd-payment-webhook.md

$prd            -> write one PRD per feature
$ralph-json     -> turn the current PRD into story backlog
$tdd-team       -> implement one story with visible Red/Green/Refactor panes
$handoff        -> write session handoff before stopping
$catchup        -> verify handoff before continuing
```

## Public Repo Safety

This repo intentionally does not include:

- `~/.codex/config.toml`
- tokens, API keys, auth files, or MCP secrets
- session logs
- generated handoff reports
- project-specific `.tdd-team/`, `prd.json`, or `progress.txt`

## License

MIT
