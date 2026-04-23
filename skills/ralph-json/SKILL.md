---
name: ralph-json
description: Use when PRD markdown, 요구사항 문서, 기능 설명을 Ralph 실행용 prd.json으로 변환하거나 기존 prd.json의 story 크기, priority, acceptance criteria, passes 상태를 검증해야 할 때.
---

# Ralph JSON

PRD, 요구사항, 기능 설명을 Ralph 실행기가 읽을 수 있는 `prd.json`으로 바꾼다.
이 스킬은 구현하지 않는다. `prd.json`을 만들거나 검증하는 데만 집중한다.

## 입력

입력은 다음 중 하나다.

- PRD markdown 파일
- 요구사항 문서
- 대화에 적힌 기능 설명
- 기존 `prd.json` 수정 요청

파일 경로가 있으면 먼저 읽고, 프로젝트 구조가 필요한 경우 관련 문서와 `AGENTS.md`를 확인한다.

## 출력

기본 출력 위치는 프로젝트 루트의 `prd.json`이다.
기존 `prd.json`이 있으면 덮어쓰기 전에 같은 feature인지 확인하고, 다르면 사용자에게 위험을 짧게 알린다.

필수 schema:

```json
{
  "project": "ProjectName",
  "branchName": "ralph/feature-name",
  "description": "Feature description",
  "userStories": [
    {
      "id": "US-001",
      "title": "Small story title",
      "description": "As a user, I want a focused behavior so that I get a clear benefit.",
      "acceptanceCriteria": [
        "Specific verifiable criterion",
        "Typecheck passes"
      ],
      "priority": 1,
      "passes": false,
      "notes": ""
    }
  ]
}
```

## 변환 규칙

1. 기능 이름에서 `project`, `branchName`, `description`을 만든다.
2. 큰 요구사항을 user story로 쪼갠다.
3. story 하나는 Ralph iteration 하나에서 끝낼 수 있는 크기로 제한한다.
4. dependency 순서로 priority를 부여한다.
5. 모든 story는 `passes:false`, `notes:""`로 시작한다.
6. ID는 `US-001`, `US-002`처럼 순차 부여한다.
7. acceptance criteria는 실제로 확인 가능한 문장만 쓴다.
8. 모든 story에 `Typecheck passes`를 넣는다.
9. 테스트 가능한 로직 story에는 `Tests pass`를 넣는다.
10. UI story에는 브라우저 검증 기준을 넣는다.

## Story 크기

좋은 크기:

- DB column 또는 migration 하나 추가
- endpoint 또는 server function 하나 추가
- 기존 화면에 UI component 하나 추가
- 목록에 filter 하나 추가
- 한 가지 interaction 저장 흐름 추가

너무 큰 크기:

- 전체 dashboard 구현
- 인증 전체 구현
- API 전체 리팩터링
- 설정 페이지 전체 구현

story를 2-3문장으로 설명하기 어렵다면 더 쪼갠다.

## Priority 기준

기본 순서:

1. schema, migration, storage
2. backend, service, server action, API
3. data loading, query, integration
4. UI display
5. UI interaction
6. aggregate view, polish, settings

앞 story가 뒤 story에 의존하면 안 된다.

## Acceptance Criteria 기준

좋은 기준:

- `notifications` storage includes `userId`, `title`, `body`, `readAt`, `createdAt`
- `GET /notifications` returns current user's notifications sorted by `createdAt` descending
- Header badge displays unread count
- Clicking a notification sets `readAt` and updates the badge
- Typecheck passes
- Tests pass

나쁜 기준:

- Works correctly
- Good UX
- Handles edge cases
- Clean code

## 검증

`prd.json`을 만든 뒤 bundled script로 형식을 확인한다.

```bash
~/.codex/skills/ralph-json/scripts/validate-prd-json.sh prd.json
```

검증은 schema와 기본 품질만 확인한다.
story가 실제로 충분히 작은지는 작성자가 다시 읽고 판단한다.

## 다음 단계

`prd.json`이 준비되면 `$ralph-flow`를 사용한다.

```bash
~/.codex/skills/ralph-flow/scripts/ralph-codex.sh --project "$PWD" --dry-run
```
