---
name: superpowers-flow
description: 'Superpowers 기본 개발 흐름과 단계별 스킬, 작업 완료 후 Compound의 ce:compound 기록 단계를 짧고 깔끔한 Markdown 표로 안내할 때 쓰는 스킬. 사용자가 전체 흐름, 어떤 스킬을 언제 쓰는지, Superpowers와 Compound를 어떻게 같이 쓰는지 물을 때 사용한다.'
---

# Superpowers Flow

## 핵심

```text
Superpowers = 개발 진행
Compound = 지식 기록
```

- 개발 단계는 Superpowers가 담당한다.
- Compound는 작업이 끝난 뒤 `/prompts:ce-compound`로 기록할 때만 쓴다.
- 오래된 기록 정리는 필요할 때만 `/prompts:ce-compound-refresh <scope>`를 쓴다.
- PRD 기반 장기 반복 실행은 `$ralph-flow`를 별도로 쓴다.
- `ce:brainstorm`, `ce:plan`, `ce:work`, `ce:review`는 쓰지 않는다.

## 흐름

| # | 단계 | 스킬 |
|---:|---|---|
| 1 | 요구사항 정리 | `brainstorming` |
| 2 | 작업 공간 분리 | `using-git-worktrees` |
| 3 | 실행 계획 작성 | `writing-plans` |
| 4 | 계획 실행 | `subagent-driven-development` / `executing-plans` |
| 5 | 테스트 우선 구현 | `test-driven-development` |
| 6 | 리뷰/피드백 | `requesting-code-review` / `receiving-code-review` |
| 7 | 검증/마무리 | `verification-before-completion` / `finishing-a-development-branch` |
| 8 | 지식 기록 | `/prompts:ce-compound` |
| 9 | 기록 정리 | `/prompts:ce-compound-refresh <scope>` |

## 예시

```text
/prompts:ce-compound 이번 캐시 무효화 버그 해결 과정 정리
/prompts:ce-compound-refresh auth
```

## 한 줄 요약

```text
Superpowers로 만들고, Compound로 남긴다.
```

## 출력 규칙

- 위 구조 그대로 짧게 답한다.
- ASCII 박스 표는 쓰지 않는다.
- 중복 표를 만들지 않는다.
- 설명은 한 줄씩만 쓴다.
