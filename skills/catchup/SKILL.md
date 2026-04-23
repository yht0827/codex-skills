---
name: catchup
description: Use when 이전 handoff 문서를 읽고 새 세션에서 이어가기 전 파일, git 상태, open work를 검증해야 할 때.
---

# Catchup

이전 세션의 handoff를 읽고 현재 코드와 git 상태로 검증한다.
handoff는 가설이지 사실이 아니다. 검증 전에는 구현하지 않는다.

## 입력

기본 위치에서 가장 최근 파일을 찾는다.

```text
.codex/reports/handoff/handoff-*.md
```

없으면 없다고 말하고 멈춘다.

## 검증 흐름

1. 최신 handoff를 읽는다.
2. `git status --short`, `git log --oneline -10`, 필요하면 `git diff --stat`을 확인한다.
3. handoff의 `Relevant Files`를 실제로 읽는다.
4. 각 참조를 분류한다.
5. 보고하고 사용자 지시를 기다린다.

## 분류

- Confirmed: 파일과 내용이 handoff 설명과 맞음
- Shifted: 파일은 있지만 line/content가 이동하거나 바뀜
- Missing: 파일 또는 대상이 없음
- Ambiguous: 참조가 모호해 확인 불가

## 보고 형식

```md
# Catchup Report

Handoff source: `.codex/reports/handoff/handoff-...md`

## Summary
handoff의 요약과 현재 확인 결과.

## File Verification
- Confirmed/Shifted/Missing/Ambiguous `path:line` - 이유

## Git Movement
- 새 커밋, 미커밋 변경, 차이 요약

## Open Work Reconciled
- handoff 항목 - 현재도 맞는지, 끝났는지, 달라졌는지

## Traps Carried Forward
- 계속 주의할 점

## Stop Point
검증만 완료했고 아직 파일을 수정하지 않았음.
```

## 규칙

- catchup 중에는 파일을 수정하지 않는다.
- 오래된 handoff는 stale 가능성을 명시한다.
- 여러 handoff를 자동 병합하지 않는다. 최신 파일만 기준으로 삼는다.
- 구현은 사용자의 다음 지시 후 시작한다.
