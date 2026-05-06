---
name: ralph-flow
description: Use when PRD 기반 장기 작업을 Ralph 방식으로 쪼개고 prd.json, progress.txt, passes 상태 기반 반복 실행 흐름을 정리하거나 적용해야 할 때.
---

# Ralph Flow

Ralph는 기본 개발 흐름이 아니라 PRD 기반 장기 반복 실행 방식이다.
기본 작업은 Superpowers로 진행하고, 여러 story를 상태 파일로 추적하며 반복 처리해야 할 때만 이 스킬을 쓴다.

## 핵심

```text
Superpowers = 기본 개발 진행
Ralph = PRD 기반 반복 실행
Compound = 완료 후 지식 기록
```

- `$superpowers-flow` 안에 Ralph 세부 절차를 섞지 않는다.
- Ralph는 별도 흐름으로 다룬다.
- 기본은 가이드 스킬로 사용한다.
- 자동 반복 실행이 필요하면 `scripts/ralph-codex.sh`를 쓴다.

## 언제 쓰나

- PRD가 있고 여러 user story로 나뉜 장기 작업일 때
- 각 story의 완료 상태를 `passes:false` / `passes:true`로 추적하고 싶을 때
- 한 번에 모든 것을 구현하지 않고 story 하나씩 반복 처리해야 할 때
- context가 길어져도 `prd.json`, `progress.txt`, git history로 이어가야 할 때

## 언제 안 쓰나

- 작은 버그 수정이나 단일 기능 구현
- 요구사항이 아직 흐린 작업
- 검증 루프만 필요한 작업
- story 단위로 쪼갤 만큼 크지 않은 작업

이 경우는 Superpowers의 `brainstorming`, `test-driven-development`, `verification-before-completion`을 우선한다.

## 실행 흐름

1. PRD를 만든다.
2. PRD를 `prd.json`으로 변환한다.
3. 각 user story를 한 iteration 안에 끝낼 크기로 쪼갠다.
4. `passes:false` 중 priority가 가장 높은 story 하나만 고른다.
5. 해당 story만 구현한다.
6. 필요한 검증을 실행한다.
7. 검증이 통과하면 story를 `passes:true`로 바꾼다.
8. `progress.txt`에 구현 내용, 변경 파일, 학습을 append한다.
9. 모든 story가 `passes:true`이면 `COMPLETE`로 종료한다.

## 실행기

반복 실행이 필요하면 이 스킬의 bundled script를 사용한다.

```bash
~/.codex/skills/ralph-flow/scripts/ralph-codex.sh --project "$PWD" --dry-run
~/.codex/skills/ralph-flow/scripts/ralph-codex.sh --project "$PWD" --max-iterations 5
```

기본 실행기는 `codex exec --full-auto`를 사용한다.
무제한 권한이 필요한 경우에만 명시적으로 `--dangerous`를 붙인다.

자주 쓰는 옵션:

- `--prd FILE`: 기본값은 `<project>/prd.json`
- `--progress FILE`: 기본값은 `<project>/progress.txt`
- `--model MODEL`: Codex 모델 지정
- `--commit`: story 완료 후 커밋까지 요청
- `--checkout-branch`: `prd.json`의 `branchName`으로 switch/create
- `--dry-run`: 다음 iteration prompt만 확인

## prd.json 형태

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
      "type": "AFK",
      "blockedBy": [],
      "passes": false,
      "notes": ""
    }
  ]
}
```

## Story 규칙

- story 하나는 한 iteration 안에 끝낼 수 있어야 한다.
- dependency 순서대로 priority를 준다.
- 자동 실행 가능한 story는 `type:"AFK"`, 사람 판단이 필요한 story는 `type:"HITL"`로 표시한다.
- 선행 story가 있으면 `blockedBy`에 story ID를 넣는다.
- schema, migration, backend, UI, aggregate view 순서가 기본이다.
- 모든 story에는 검증 가능한 acceptance criteria를 둔다.
- 모든 story에는 `Typecheck passes`를 넣는다.
- UI story에는 브라우저 검증 기준을 넣는다.
- 실행기는 `AFK`이면서 `blockedBy`가 모두 `passes:true`인 story만 고른다.

## progress.txt 규칙

`progress.txt`는 append-only로 다룬다.

```text
## YYYY-MM-DD HH:mm - US-001
- What was implemented
- Files changed
- Verification run
- Learnings for future iterations
---
```

학습은 story 전용 기록과 재사용 가능한 패턴을 구분한다.
재사용 가능한 패턴은 필요한 경우 가까운 `AGENTS.md`나 프로젝트 지식 문서에 남긴다.

## 완료 기준

- 모든 user story가 `passes:true`
- 각 story의 acceptance criteria가 검증됨
- 테스트, 타입체크, 린트, 브라우저 확인 중 필요한 검증을 실행함
- 남은 실패와 수동 확인 항목이 `progress.txt`에 기록됨

## Superpowers와의 관계

- 요구사항 정리는 `brainstorming`을 우선한다.
- 계획 문서는 `writing-plans`를 우선한다.
- 구현 방식은 필요하면 `test-driven-development`를 적용한다.
- 완료 주장은 `verification-before-completion` 후에만 한다.
- 끝난 뒤 재사용 가능한 해결 과정은 `/prompts:ce-compound`로 기록한다.

## 관련 스킬

- `$ralph-json`: PRD 문서나 요구사항을 `prd.json`으로 변환한다.
- `$ralph-flow`: 준비된 `prd.json`을 story 단위로 반복 실행한다.
