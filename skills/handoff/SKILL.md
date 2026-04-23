---
name: handoff
description: Use when 세션을 끝내기 전 다음 Codex 세션이 이어받을 인계 문서, handoff, 작업 정리, 다음 세션 준비가 필요할 때.
---

# Handoff

다음 세션이 이어받을 수 있도록 짧은 인계 문서를 작성한다.
인계는 사실 확정 문서가 아니라 다음 세션이 검증할 가설이다.

기본 저장 위치:

```text
.codex/reports/handoff/handoff-YYYYMMDD-HHMMSS.md
```

## 작성 전 확인

- `git status --short`
- `git log --oneline -10`
- `git diff --stat`
- 이번 세션에서 바뀐 파일과 결정
- 실패한 접근과 피해야 할 함정

git repo가 아니면 git 항목은 생략하고 그 사실을 적는다.

## 문서 형식

```md
# Handoff - YYYY-MM-DD HH:mm

## Summary
이번 세션의 목표와 현재 상태를 1-3문장으로 적는다.

## Key Decisions
- 결정 - 이유. 대안과 기각 이유.

## Traps to Avoid
- 실패한 접근 또는 헷갈리기 쉬운 제약 - 왜 위험한지.

## Working Agreements
- 이번 세션에서 확인된 사용자 선호나 진행 규칙.

## Relevant Files
- `path/to/file:line` - 다음 세션이 확인해야 하는 이유.

## Open Work
- 상태 문장으로 쓴다. 명령형으로 쓰지 않는다.

## Prompt for New Chat
> `.codex/reports/handoff/handoff-...md`를 읽고, 인용된 파일과 git 상태를 먼저 검증한 뒤 보고하고 대기해 주세요.
```

## 규칙

- Open Work는 `구현하라`, `고쳐라` 같은 명령형으로 쓰지 않는다.
- 파일 참조에는 가능한 한 line number를 붙인다.
- `AGENTS.md`에 이미 있는 일반 규칙은 반복하지 않는다.
- 실패한 접근은 꼭 남긴다.
- 2000 tokens 안팎으로 짧게 유지한다.
- 자동 커밋하지 않는다.
