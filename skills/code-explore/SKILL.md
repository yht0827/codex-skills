---
name: code-explore
description: Use when 새 코드베이스, 모듈, 디렉터리, 큰 변경 범위를 구현 전 구조적으로 읽고 architecture, entrypoint, dependency, test 흐름을 파악해야 할 때.
---

# Code Explore

코드베이스를 깊게 읽고 구조 보고서를 만든다.
수정하지 않는다. 분석과 읽기 순서 추천이 목표다.

기본 출력:

```text
code-[target]-YYYYMMDD-HHMMSS.md
```

## 흐름

1. 대상 경로를 정한다. 없으면 현재 디렉터리.
2. `rg --files`로 파일 목록을 만든다.
3. build/config/README/AGENTS 문서를 읽는다.
4. entrypoint, 주요 모듈, 테스트 위치를 찾는다.
5. 대표 흐름 2-3개를 추적한다.
6. 보고서를 저장한다.

## 제외

`node_modules`, `vendor`, `dist`, `build`, `target`, `.next`, `coverage`, `__pycache__`, generated files는 분석에서 제외한다.

## 보고서 형식

```md
# [Target] Codebase Analysis

## Executive Summary
- 가장 중요한 발견 3-5개

## 1. Topology and Entry Points
구조, 주요 entrypoint, 실행 흐름.

## 2. Dependencies and Boundaries
외부 라이브러리, DB/API/파일/환경변수, trust boundary.

## 3. Core Abstractions
핵심 타입, 서비스, 인터페이스, domain model.

## 4. Complexity and Risks
큰 파일, 결합도, 변경 hotspot, 위험 지점.

## 5. Testing and Developer Workflow
테스트 구조, 실행 명령, CI, 온보딩.

## 6. Recommended Reading Order
처음 읽을 파일 순서.
```

## 규칙

- 중요한 주장에는 파일 경로를 붙인다.
- 관찰과 추론을 구분한다.
- 모르는 것은 추측하지 않고 `확인 필요`로 남긴다.
- 코드 변경이나 리팩터링 제안은 Top Risks에만 짧게 적는다.
