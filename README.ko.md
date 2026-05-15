# Codex Skills

PRD 작성, Ralph 스타일 story 추적, TDD 팀 워크플로, 코드베이스 분석, 디자인 프로토타이핑, 세션 handoff, Spring Boot 프로젝트 생성을 위한 portable Codex 스킬 모음입니다.

English documentation: [README.md](README.md)

이 저장소는 파일 기반 스킬 툴킷입니다. Claude Code 전용 marketplace 패키지가 아닙니다. 설치 스크립트는 `skills/` 아래 폴더를 `~/.codex/skills/`로 복사해 Codex가 로컬에서 발견할 수 있게 합니다.

## Skills

### Planning And Execution

- [`$prd`](skills/prd/SKILL.md): 기능 아이디어와 요구사항을 구현 가능한 PRD로 정리
- [`$ralph-json`](skills/ralph-json/SKILL.md): PRD나 요구사항을 Ralph 스타일 `prd.json` backlog로 변환
- [`$ralph-flow`](skills/ralph-flow/SKILL.md): `prd.json` 기반 장기 작업을 story 단위로 반복 실행
- [`$tdd-team`](skills/tdd-team/SKILL.md): Team Lead / Red / Green / Refactor TDD 흐름 실행

### Code Reading And Review

- [`$code-explore`](skills/code-explore/SKILL.md): 낯선 코드베이스의 구조, entrypoint, 의존성, 테스트 흐름 분석
- [`$code-review-graph`](skills/code-review-graph/SKILL.md): graph 기반 리뷰 컨텍스트와 변경 영향 범위 확인
- [`$code-quality`](skills/code-quality/SKILL.md): 코드 품질, 테스트 품질, 보안, 성능, 유지보수 위험 평가
- [`$diagnose`](skills/diagnose/SKILL.md): 버그, 실패 테스트, flaky 현상, 회귀를 재현 loop로 좁힘

### Design And Prototyping

- [`$open-design`](skills/open-design/SKILL.md): Open Design 실행, Codex 연결, 디자인 산출물 생성 흐름 안내

### Session And Setup

- [`$handoff`](skills/handoff/SKILL.md): 다음 Codex 세션이 이어받을 handoff 작성
- [`$catchup`](skills/catchup/SKILL.md): 이전 handoff를 실제 파일과 git 상태로 검증
- [`$spring-boot-init`](skills/spring-boot-init/SKILL.md): Spring Initializr 기반 작은 Spring Boot 프로젝트 생성
- [`$superpowers-flow`](skills/superpowers-flow/SKILL.md): Superpowers 중심 개발 흐름과 Compound 기록 단계 안내
- [`$quick-help`](skills/quick-help/SKILL.md): 자주 쓰는 명령만 짧게 확인
- [`$guide`](skills/guide/SKILL.md): 설치된 스킬과 프롬프트 목록 확인

## Install

저장소를 clone한 뒤 실행합니다.

```bash
git clone https://github.com/yht0827/codex-skills.git
cd codex-skills
./scripts/install.sh
```

설치 스크립트는 `skills/` 아래 각 폴더를 `~/.codex/skills/`로 복사합니다.
같은 이름의 스킬 폴더만 교체하고, 관련 없는 스킬은 삭제하지 않습니다.

다른 Codex home에 설치하려면:

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

validator는 모든 스킬에 `SKILL.md`가 있는지, frontmatter가 유효한지, `name`이 폴더명과 맞는지 확인합니다.
`$ralph-json`은 `prd.json` story 구조를 더 엄격하게 검증하는 도구도 포함합니다.

## Typical Workflow

- [`$prd`](skills/prd/SKILL.md) -> 명확한 기능 PRD 작성
- [`$ralph-json`](skills/ralph-json/SKILL.md) -> PRD를 prd.json으로 변환
- [`$diagnose`](skills/diagnose/SKILL.md) -> 원인이 불명확한 버그를 고치기 전 repro loop 구성
- [`$code-review-graph`](skills/code-review-graph/SKILL.md) -> graph 컨텍스트 또는 변경 영향 범위 확인
- [`$open-design`](skills/open-design/SKILL.md) -> 필요할 때 디자인 산출물 생성 또는 점검
- [`$tdd-team`](skills/tdd-team/SKILL.md) -> Red / Green / Refactor pane으로 story 하나 구현
- [`$ralph-flow`](skills/ralph-flow/SKILL.md) -> 필요하면 여러 story를 자동 반복 실행
- [`$handoff`](skills/handoff/SKILL.md) -> 세션을 멈추기 전 handoff 작성
- [`$catchup`](skills/catchup/SKILL.md) -> 다음 세션에서 handoff 검증

더 긴 흐름은 [docs/workflow.md](docs/workflow.md)를 참고하세요.

## Quick Examples

작은 기능:

```text
Superpowers로 brainstorming/planning
-> TDD로 구현
-> 완료 전 검증
```

큰 기능:

```text
$prd "알림 기능 PRD 작성"
-> $ralph-json "tasks/prd-notifications.md를 prd.json으로 변환"
-> $tdd-team "prd.json의 다음 story를 TDD로 진행"
```

디자인 프로토타입:

```text
$open-design "Codex로 대시보드 프로토타입 만들 준비"
```

Ralph story metadata:

```json
{
  "type": "AFK",
  "blockedBy": ["US-001"]
}
```

Codex가 혼자 실행할 수 있는 story slice에는 `AFK`를 사용하고, 사람의 제품/디자인/도메인 판단이 필요한 slice에는 `HITL`을 사용합니다. `blockedBy`는 선행 story가 통과하기 전 `$ralph-flow`가 다음 story를 시작하지 않게 합니다. 예시는 [examples/ralph-prd.json](examples/ralph-prd.json)을 참고하세요.

커지는 commerce 프로젝트:

```text
tasks/prd-commerce-mvp.md
tasks/prd-coupon.md
tasks/prd-product-review.md
tasks/prd-payment-webhook.md

$prd            -> 기능별 PRD 작성
$ralph-json     -> 현재 PRD를 story backlog로 변환
$tdd-team       -> Red/Green/Refactor pane으로 story 하나 구현
$handoff        -> 세션을 멈추기 전 handoff 작성
$catchup        -> 이어가기 전 handoff 검증
```

## Public Repo Safety

이 저장소에는 의도적으로 다음을 포함하지 않습니다.

- `~/.codex/config.toml`
- token, API key, auth file, MCP secret
- session log
- 생성된 handoff report
- 프로젝트별 `.tdd-team/`, `prd.json`, `progress.txt`

## License

MIT
