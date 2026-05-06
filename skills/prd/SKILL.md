---
name: prd
description: Use when 기능 아이디어, 요구사항, feature spec, PRD, user story, acceptance criteria를 구현 전에 명확한 문서로 정리해야 할 때.
---

# PRD

기능 아이디어를 구현 가능한 PRD로 정리한다. 이 스킬은 구현하지 않는다.
출력은 기본적으로 프로젝트 루트의 `tasks/prd-[feature-name].md`에 저장한다.

## 흐름

1. 프로젝트 파일, README, 최근 계획 문서가 있으면 먼저 읽는다.
2. 불명확한 부분은 3-5개 질문으로 좁힌다.
3. PRD를 작성한다.
4. 저장 전 검증한다.
5. 다음 단계로 `$ralph-json`, `$tdd-team`, `$ralph-flow` 중 맞는 흐름을 안내한다.

## 질문 규칙

질문은 선택지형으로 짧게 묻는다.

```text
1. 이번 기능의 1차 목표는 무엇인가요?
   A. 최소 기능 출시
   B. 기존 기능 개선
   C. 버그/운영 문제 해결
   D. 기타: 직접 설명
```

질문 없이도 요구사항이 충분히 명확하면 바로 PRD를 작성한다.

## PRD 형식

```md
# [Feature Name] PRD

## Overview
문제와 기능을 2-4문장으로 설명한다.

## Goals
- 측정 가능한 목표

## User Stories
### US-001: [작은 story 제목]
Description: As a [user], I want [behavior] so that [benefit].

Acceptance Criteria:
- [ ] 구체적이고 검증 가능한 기준
- [ ] Typecheck passes
- [ ] Tests pass

## Functional Requirements
1. 명확하고 테스트 가능한 요구사항

## Non-Goals
- 이번 범위에서 하지 않을 것

## Design Notes
UI/UX가 있으면 기본 상태, 빈 상태, 오류 상태를 적는다.

## Module Candidates
- 만들거나 수정할 주요 module 후보와 책임

## Implementation Decisions
- 이미 확정된 구현 결정, trade-off, API/schema 영향

## Testing Decisions
- 어떤 behavior를 어떤 test surface에서 검증할지

## Technical Notes
연동 지점, 기존 코드 제약, 테스트/빌드 명령을 적는다.

## Open Questions
- 남은 질문
```

## 작성 원칙

- story 하나는 `$ralph-json`의 `prd.json` story 하나로 옮길 수 있을 만큼 작게 쓴다.
- acceptance criteria는 `Works correctly`처럼 모호하게 쓰지 않는다.
- 모든 story에는 `Typecheck passes`를 넣는다.
- 테스트 가능한 로직 story에는 `Tests pass`를 넣는다.
- UI story에는 브라우저 확인 기준을 넣는다.
- module 후보, 구현 결정, 테스트 결정은 코드 경로보다 책임과 behavior 중심으로 쓴다.
- PRD는 junior developer나 새 Codex 세션이 바로 읽고 구현 계획을 세울 수 있어야 한다.

## 저장

```bash
mkdir -p tasks
```

파일명은 feature 이름을 kebab-case로 바꿔 `tasks/prd-[feature-name].md`로 저장한다.

## 다음 단계

- 여러 story를 상태 파일로 관리하려면 `$ralph-json`으로 `prd.json`을 만든다.
- story 하나를 엄격한 Red/Green/Refactor로 구현하려면 `$tdd-team`을 쓴다.
- 여러 story를 자동 반복 실행하려면 `$ralph-flow`를 쓴다.
