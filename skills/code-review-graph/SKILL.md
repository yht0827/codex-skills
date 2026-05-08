---
name: code-review-graph
description: Use when code-review-graph, CRG, graph-based review context, blast-radius analysis, Codex MCP setup, or structural code graph commands are needed for a repository.
---

# Code Review Graph

`code-review-graph` CLI/MCP를 안전하게 설치, 설정, 빌드, 조회한다.
이 스킬은 그래프 기반 변경 영향 범위와 리뷰 컨텍스트를 얻기 위한 wrapper다.

기존 `$codegraph` 스킬과 혼동하지 않는다.
`$codegraph`는 로컬 `python3 -m codegraph scan` 기반 시각화이고, 이 스킬은 `code-review-graph` CLI와 MCP 연동을 다룬다.

## 언제 쓰나

- 사용자가 `code-review-graph`, `CRG`, `blast radius`, `영향 범위`, `graph review`를 말할 때
- Codex에 `code-review-graph` MCP를 연결하거나 점검해야 할 때
- 현재 repo의 구조 그래프를 만들고 변경 영향 범위를 보고 싶을 때
- PR/커밋 전 변경 파일의 위험도를 그래프 기반으로 확인하고 싶을 때
- 인터랙티브 그래프 HTML, GraphML, SVG, Obsidian export가 필요할 때

단순 코드 구조 읽기 보고서는 `$code-explore`를 우선한다.
품질 점수와 개선 우선순위 보고서는 `$code-quality`를 우선한다.

## 기본 확인

먼저 현재 머신 상태를 확인한다.

```bash
command -v code-review-graph
code-review-graph --help
```

설치되어 있지 않으면 `pipx`를 우선 권장한다.

```bash
pipx install code-review-graph
```

`pipx`가 없으면 사용자에게 설치 방식을 확인한 뒤 `pip install code-review-graph` 또는 프로젝트별 가상환경 설치를 사용한다.

## Codex MCP 설정

MCP나 Codex 설정을 바꾸기 전에는 반드시 dry-run을 먼저 실행한다.

```bash
code-review-graph install --platform codex --dry-run
```

dry-run 출력으로 변경 대상 파일과 명령을 설명한 뒤, 사용자가 명시적으로 원할 때만 실제 설정을 적용한다.

```bash
code-review-graph install --platform codex
```

설정 적용 후에는 Codex 재시작이 필요할 수 있음을 알려준다.

## 프로젝트 그래프 작업

항상 분석할 프로젝트 루트에서 실행한다.
프로젝트 루트가 불명확하면 `git rev-parse --show-toplevel`로 확인한다.

```bash
code-review-graph build
code-review-graph status
```

이미 그래프가 있거나 변경분만 반영하면:

```bash
code-review-graph update
code-review-graph update --base origin/main
```

생성물과 캐시는 보통 `.code-review-graph/` 아래에 생긴다.
gitignore 대상 여부를 확인하고, repo 정책에 맞지 않으면 추적하지 않는다.

## 변경 영향 분석

현재 변경의 리뷰 컨텍스트가 필요하면:

```bash
code-review-graph detect-changes
code-review-graph detect-changes --brief
```

기준 브랜치가 필요하면:

```bash
code-review-graph detect-changes --base origin/main --brief
```

결과를 해석할 때는 다음을 구분한다.

- 실제 변경 파일
- 그래프가 추정한 영향 범위
- 테스트 gap
- 위험도가 높은 호출 흐름
- false positive 가능성이 있는 보수적 경고

## 시각화와 내보내기

사용자가 그래프를 보고 싶다고 하면:

```bash
code-review-graph visualize
```

필요한 형식에 따라:

```bash
code-review-graph visualize --format graphml
code-review-graph visualize --format svg
code-review-graph visualize --format obsidian
code-review-graph visualize --format cypher
```

HTML 결과가 생성되면 파일 경로를 알려준다.
브라우저로 열 필요가 있으면 사용자가 요청했을 때만 연다.

## Watch / Daemon

일회성 리뷰에는 daemon을 켜지 않는다.
사용자가 여러 repo를 계속 감시하겠다고 명시할 때만 daemon을 설정한다.

```bash
code-review-graph daemon add /path/to/repo --alias repo-name
code-review-graph daemon start
code-review-graph daemon status
```

중지:

```bash
code-review-graph daemon stop
```

## 제외 규칙

인덱싱 제외가 필요하면 repo 루트에 `.code-review-graphignore`를 둔다.

```text
generated/**
*.generated.ts
vendor/**
node_modules/**
```

git repo에서는 보통 `git ls-files` 기준으로 추적 파일만 인덱싱된다.
이미 gitignore된 대형 산출물은 별도 제외가 필요 없을 수 있다.

## 완료 기준

- CLI 설치 여부 또는 미설치 상태를 확인했다.
- Codex MCP 설정 변경은 dry-run을 먼저 보여줬다.
- 프로젝트 루트에서 `build`, `update`, `status`, `detect-changes` 중 요청에 맞는 명령을 실행했다.
- 결과가 생성된 경로와 남은 리스크를 짧게 보고했다.
- `.code-review-graph/` 같은 생성물이 불필요하게 커밋 대상에 들어가지 않았는지 확인했다.
