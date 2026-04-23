---
name: code-quality
description: Use when 코드 품질, 테스트 품질, 유지보수성, 보안, 성능, 의존성 위험을 점수화하거나 개선 우선순위를 보고서로 정리해야 할 때.
---

# Code Quality

대상 코드의 품질을 평가하고 개선 우선순위를 문서화한다.
수정하지 않는다. 평가와 추천이 목표다.

기본 출력:

```text
quality-YYYYMMDD.md
```

## 평가 항목

- Readability
- Consistency
- Maintainability
- Extensibility
- Testability
- Test Quality
- Performance
- Security
- Dependency Management

각 항목은 0-100으로 점수화한다.

## 흐름

1. 대상 경로를 정한다. 없으면 현재 디렉터리.
2. 언어, 빌드 도구, 테스트 명령, source/test 파일 수를 확인한다.
3. 대표 파일과 테스트 파일을 읽는다.
4. 위험이 큰 파일과 패턴을 찾는다.
5. 상위 5개 개선 항목을 뽑는다.
6. 보고서를 저장한다.

## 보고서 형식

```md
# [Target] Code Quality Report

## Score Summary
- Overall: NN/100
- Readability: NN
- Consistency: NN
- Maintainability: NN
- Extensibility: NN
- Testability: NN
- Test Quality: NN
- Performance: NN
- Security: NN
- Dependency Management: NN

## Findings
항목별 근거와 파일 참조.

## Top Issues
1. Severity - 문제 - 영향 - 추천

## Test Gaps
실제 리스크를 막지 못하는 테스트 공백.

## Recommended Next Steps
가장 작은 개선 순서.
```

## 규칙

- 점수는 근거와 함께 준다.
- 보안/성능 문제는 확신도가 낮으면 `의심`으로 표시한다.
- 스타일 취향보다 유지보수 위험을 우선한다.
- 큰 리팩터링보다 작은 개선 단위를 먼저 추천한다.
