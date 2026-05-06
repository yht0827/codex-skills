# Codex Skills

Personal Codex skill toolkit for PRD writing, Ralph-style story tracking, TDD team workflows, codebase analysis, session handoff, and Spring Boot project setup.

이 저장소는 `~/.codex/skills` 아래에서 쓰는 개인용 Codex 스킬 모음이다. Claude Code 전용 marketplace가 아니라, Codex에서 바로 복사해 쓸 수 있는 portable skill repo로 관리한다.

## Skills

| Skill | Purpose |
|---|---|
| `$prd` | 기능 아이디어와 요구사항을 구현 가능한 PRD로 정리 |
| `$ralph-json` | PRD나 요구사항을 Ralph 실행용 `prd.json`으로 변환/검증 |
| `$ralph-flow` | `prd.json` 기반 장기 작업을 story 단위로 반복 실행 |
| `$tdd-team` | tmux 4분할 Team Lead / Red / Green / Refactor TDD 팀 구성 |
| `$handoff` | 다음 Codex 세션이 이어받을 인계 문서 작성 |
| `$catchup` | handoff를 실제 파일과 git 상태로 검증 |
| `$code-explore` | 새 코드베이스의 구조, entrypoint, 의존성, 테스트 흐름 분석 |
| `$code-quality` | 코드 품질, 테스트 품질, 보안, 성능, 유지보수 위험 평가 |
| `$diagnose` | 버그, 실패 테스트, flaky 현상, 성능 회귀의 원인 추적 |
| `$spring-boot-init` | Spring Initializr 기반 Spring Boot 프로젝트 생성 |
| `$superpowers-flow` | Superpowers 중심 개발 흐름과 Compound 기록 단계 안내 |
| `$quick-help` | 자주 쓰는 스킬만 짧게 확인 |
| `$guide` | 설치된 스킬과 프롬프트 전체 목록 안내 |
| `$mario` | 질문형 코칭으로 코딩테스트/디버깅 사고 정리 |

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

The validator checks that every skill has `SKILL.md`, valid frontmatter basics, and matching `name`.
`$ralph-json` also includes a stricter validator for `prd.json` story shape.

## Typical Workflow

```text
$prd            -> write a clear feature PRD
$ralph-json     -> convert PRD to prd.json
$diagnose       -> build a repro loop before fixing unclear bugs
$tdd-team       -> implement one story through Red / Green / Refactor panes
$ralph-flow     -> optionally run multiple stories through an automated loop
$handoff        -> write session handoff before stopping
$catchup        -> verify handoff in the next session
```

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
$prd "알림 기능 PRD 작성"
-> $ralph-json "tasks/prd-notifications.md를 prd.json으로 변환"
-> $tdd-team "prd.json의 다음 story를 TDD로 진행"
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
