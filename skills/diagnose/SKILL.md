---
name: diagnose
description: Use when a bug, failing test, broken behavior, flaky issue, or performance regression needs disciplined root-cause diagnosis before fixing.
---

# Diagnose

버그를 바로 고치지 않고, 먼저 재현 가능한 feedback loop를 만든다. 이 스킬은 원인 추적과 수정 검증을 위한 절차다.

## 언제 쓰나

- 사용자가 "디버깅", "원인", "깨짐", "실패", "느림", "flaky"를 말할 때
- 증상은 보이지만 원인이 불명확할 때
- 테스트 실패나 운영 버그를 고쳐야 할 때
- 성능 회귀를 측정하고 좁혀야 할 때

단순 오타나 이미 원인이 명확한 작은 수정이면 일반 작업으로 처리한다.

## 흐름

1. feedback loop를 만든다.
2. 사용자가 말한 증상이 그 loop에서 재현되는지 확인한다.
3. 3-5개 가설을 세우고, 각 가설의 예측을 적는다.
4. 한 번에 하나의 예측만 검증한다.
5. 올바른 test seam이 있으면 regression test를 먼저 만든다.
6. 최소 수정으로 원래 증상과 regression test를 모두 통과시킨다.
7. 임시 로그, 실험 파일, debug hook을 제거한다.

## Feedback Loop 우선순위

빠르고 결정적인 pass/fail 신호를 만든다.

1. 실패 테스트: unit, integration, e2e 중 실제 증상에 닿는 가장 작은 test
2. HTTP/curl script: 서버 동작이면 재현 요청을 script로 고정
3. CLI fixture: 입력과 기대 출력을 고정
4. Browser automation: UI bug면 DOM, console, network assertion 포함
5. Trace replay: 실제 payload, log, HAR, event를 저장해 재생
6. Throwaway harness: 문제 경로만 부르는 작은 실행 코드
7. 반복 loop: flaky면 재현율을 높이고 seed/time/network를 고정

loop가 없으면 가설 수정으로 넘어가지 않는다. 불가능하면 시도한 방법과 필요한 artifact를 사용자에게 말한다.

## 가설 규칙

가설은 falsifiable 해야 한다.

```text
If <원인> 이 맞다면, <관찰/변경> 했을 때 <결과>가 나와야 한다.
```

- 3-5개를 우선순위로 정한다.
- 가장 그럴듯한 하나에 고정하지 않는다.
- domain 지식이나 최근 변경 이력이 있으면 순위를 조정한다.

## Instrumentation 규칙

- debugger나 REPL로 확인 가능하면 먼저 쓴다.
- log는 boundary를 구분하는 곳에만 넣는다.
- 임시 로그 prefix는 고유하게 붙인다: `[DEBUG-xxxx]`
- 완료 전 prefix 검색으로 전부 제거한다.
- 성능 문제는 log보다 baseline measurement, profiler, query plan, bisect를 우선한다.

## 완료 기준

- 원래 feedback loop에서 증상이 재현되지 않는다.
- regression test가 있으면 실패 → 수정 → 통과 흐름이 확인된다.
- 임시 debug artifact가 제거됐다.
- regression test를 만들 수 없는 구조라면, test seam 부재를 남은 리스크로 기록한다.
