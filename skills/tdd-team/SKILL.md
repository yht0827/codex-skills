---
name: tdd-team
description: 'TDD를 수행하는 agent team을 구성할 때 쓰는 스킬. Team Lead가 개발 요구사항을 받아 task로 나누고, Red agent는 실패 테스트 작성과 실패 확인, Green agent는 테스트 통과를 위한 최소 구현, Refactor agent는 통과 상태를 유지하며 리팩터링을 담당한다. tmux 4분할 agent team이 필요할 때 사용한다.'
---

# TDD Team

Team Lead + Red + Green + Refactor 4개 역할로 TDD를 진행한다.

## 사용 시점

사용자가 기능을 TDD로 구현하거나, 테스트를 먼저 만들고 Red → Green → Refactor 순서로 진행하고 싶다고 할 때 사용한다.

단순히 기존 테스트를 실행하거나, 이미 구현된 코드에 테스트만 추가하거나, 일반 디버깅만 요청한 경우에는 이 스킬을 자동으로 쓰지 않는다.

## 역할

| 역할 | 책임 |
|---|---|
| Team Lead | 요구사항 분석, task 분할, phase gate 관리, 커밋/진행 판단 |
| Red | 실패 테스트 작성, 테스트 실행 후 실패 확인 |
| Green | 실패 테스트 통과를 위한 최소 production code 작성 |
| Refactor | 테스트 통과 상태를 유지하며 리팩터링 |

## 진행 규칙

| 순서 | Phase | 완료 조건 |
|---:|---|---|
| 1 | Lead | 요구사항을 작은 task로 분할 |
| 2 | Red | 실패 테스트 + 의도한 실패 확인 |
| 3 | Green | 최소 구현 + 테스트 통과 확인 |
| 4 | Refactor | 동작 유지 정리 + 테스트 통과 확인 |
| 5 | Lead | 결과 검토, 커밋, 다음 task 진행 |

## 핵심 원칙

- Red → Green → Refactor는 순차 진행한다.
- horizontal Red를 하지 않는다. 한 task 안에서도 `테스트 하나 → 최소 구현 → 다음 테스트` vertical slice로 진행한다.
- 테스트는 내부 구현 세부가 아니라 public behavior와 observable outcome을 검증한다.
- Red는 상상한 전체 설계를 테스트로 고정하지 않고, 지금 검증할 동작 하나만 테스트한다.
- 같은 파일을 동시에 수정하지 않는다.
- 한 task는 하나의 작은 동작 또는 edge case만 다룬다.
- Red는 production code를 쓰지 않는다.
- Red 테스트는 컴파일되어야 하며, 의도한 이유로 실패해야 한다.
- Green은 리팩터링이나 추가 기능을 하지 않는다.
- Green은 테스트 파일을 수정하지 않는다.
- Refactor는 동작을 바꾸지 않는다.
- Refactor는 새 기능이나 새 테스트를 추가하지 않는다.
- Team Lead가 요구사항을 받고 task와 phase를 통제한다.

## Team Lead 운영

Team Lead는 먼저 프로젝트의 언어, 빌드 도구, source/test 디렉터리, 테스트 명령을 확인한다.
`open-tdd-team`은 다음 파일을 기준으로 기본 테스트 명령을 prompt에 넣는다.

- `build.gradle.kts` 또는 `build.gradle`: `./gradlew test` 또는 `gradle test`
- `pom.xml`: `./mvnw test` 또는 `mvn test`
- `package.json`: `npm test`
- `Cargo.toml`: `cargo test`
- `go.mod`: `go test ./...`
- `pyproject.toml` 또는 `pytest.ini`: `pytest`

추정값이 틀리거나 확인이 필요하면 Team Lead가 사용자에게 묻거나 실제 프로젝트 설정에 맞게 교정한다.

각 task마다 진행 상태를 다음처럼 표시한다.

```text
[x] 완료
[>] 현재 진행
[ ] 대기
```

각 cycle이 끝나면 Team Lead는 Red 실패 이유, Green 테스트 결과, Refactor 변경 여부, 변경 파일, 다음 task 진행 가능 여부를 요약한다.

## Ralph JSON과 같이 쓰기

`ralph-json`은 PRD나 기능 설명을 `prd.json`의 user story backlog로 만든다.
`tdd-team`은 그중 story 하나를 Red → Green → Refactor로 실행하는 팀이다.

기본 흐름:

1. `$prd` 또는 직접 작성한 요구사항으로 PRD를 만든다.
2. `$ralph-json`으로 `prd.json`을 만든다.
3. `validate-prd-json.sh prd.json`으로 schema를 확인한다.
4. `$tdd-team`을 실행한다.
5. Team Lead가 `passes:false` 중 priority가 가장 낮은 story를 읽고 TDD task로 나눈다.
6. Red/Green/Refactor와 검증이 끝난 뒤에만 `passes:true` 전환과 `progress.txt` 기록을 판단한다.

자동 반복 실행이 필요하면 `$ralph-flow`의 `ralph-codex.sh`를 쓴다.
엄격한 역할 분리와 visible tmux pane이 필요하면 `ralph-flow` 자동 실행기 대신 `tdd-team`을 사용한다.

## 실행

tmux 안에서 실행하면 현재 window를 그대로 쓰고 4개 pane으로 분할한다.
현재 pane은 `team-lead`로 유지하고, 새 pane 3개에 `red`, `green`, `refactor`를 실행한다.
pane title은 위쪽에만 표시하며, title 글자에만 역할별 색상을 적용한다.

현재 디렉터리:

```bash
~/.codex/skills/tdd-team/scripts/open-tdd-team "$PWD" "요구사항"
```

특정 프로젝트:

```bash
~/.codex/skills/tdd-team/scripts/open-tdd-team ~/Desktop/board-example "게시판 JPA 예제를 계획 파일 기준으로 TDD 구현"
```

tmux 밖에서 실행하면 기존처럼 `tdd-team-<디렉터리명>` 세션을 새로 만들고 attach한다.
tmux 안에서도 별도 세션을 강제로 만들고 싶으면:

```bash
TDD_TEAM_FORCE_NEW_SESSION=1 ~/.codex/skills/tdd-team/scripts/open-tdd-team "$PWD" "요구사항"
```

## tmux pane 구성

| 위치 | 역할 |
|---|---|
| 왼쪽 위 | `team-lead` |
| 오른쪽 위 | `red` |
| 왼쪽 아래 | `green` |
| 오른쪽 아래 | `refactor` |

## 오류 대응

- Red 테스트가 이미 통과하면 `ALREADY_PASSES`로 보고하고 Green으로 억지 진행하지 않는다.
- Red가 컴파일 실패라면 테스트가 실패한 것이 아니라 빌드가 깨진 것이다. Red가 컴파일 문제를 먼저 고친다.
- Green 후 다른 테스트가 깨지면 구현을 줄이거나 다른 접근을 선택한다.
- Refactor 후 테스트가 깨지면 해당 리팩터링을 되돌리고 더 작은 단위로 다시 시도한다.
- 이미 HEAD가 Green 상태라 Red 실패를 재현할 수 없으면 rollback이나 sabotage를 하지 않고 현재 상태를 보고한다.

## 사용 예

```text
$tdd-team 게시판 JPA 예제를 TDD로 진행해줘
```

```text
TDD 팀 구성해줘. Team Lead가 요구사항을 task로 나누고 Red, Green, Refactor를 순차 진행하게 해줘.
```
