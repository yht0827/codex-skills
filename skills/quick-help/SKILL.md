---
name: quick-help
description: '자주 쓰는 스킬만 짧게 볼 때 쓰는 스킬'
---

# Quick Help

Use this skill when the user enters exactly `help` or `skills`, invokes `$quick-help`, or asks for a short everyday command list.

## Output Goal

- Show only high-frequency commands that currently exist in this setup.
- Keep the answer short and scan-friendly.
- Write in Korean.
- Do not include commands that are not present on disk.

## Output Format

Render exactly these sections in this order:

1. `# 자주 쓰는 명령`
2. `# 언제 쓰면 좋은지`
3. `# 전체 목록`

## Command Set

Always include these if present on disk:

- `$guide`: 전체 스킬과 프롬프트 목록을 볼 때
- `$quick-help`: 자주 쓰는 명령만 짧게 볼 때
- `$superpowers-flow`: Superpowers 전체 흐름과 단계별 스킬을 볼 때
- `$prd`: 기능 아이디어를 구현 가능한 PRD로 정리할 때
- `$ralph-flow`: PRD 기반 장기 반복 실행 흐름을 볼 때
- `$ralph-json`: PRD나 요구사항을 Ralph용 prd.json으로 바꿀 때
- `$handoff`: 세션을 끝내기 전 다음 세션용 인계 문서를 남길 때
- `$catchup`: 이전 handoff를 검증하고 이어갈 상태를 확인할 때
- `$code-explore`: 새 코드베이스나 큰 모듈 구조를 읽고 보고서로 정리할 때
- `$code-quality`: 코드 품질과 개선 우선순위를 점검할 때
- `$diagnose`: 버그 원인을 재현 loop로 좁히고 수정 검증까지 할 때
- `$spring-boot-init`: Spring Boot 새 프로젝트를 만들 때
- `$job-apply-fit`: 채용공고 링크를 보고 Java/Spring 재취업 적합도와 지원 기록을 남길 때
- `$humanizer`: AI 티 나는 글이나 문장을 자연스럽게 다듬을 때
- `$research`: 여러 관점으로 넓게 조사할 때
- `$playwright`: 실제 브라우저 자동화가 필요할 때
- `$tdd-team`: Team Lead/Red/Green/Refactor 4역할 TDD tmux 작업공간을 열 때
- `$gh-fix-ci`: GitHub Actions 실패 원인을 볼 때
- `/prompts:ce-compound`: 해결한 문제를 프로젝트 지식으로 기록할 때
- `/prompts:ce-compound-refresh`: 오래된 `docs/solutions/` 지식을 정리할 때

Also include these Superpowers skills if present through the installed `superpowers@openai-curated` plugin:

- `brainstorming`: 코딩 전 요구사항과 설계를 정리할 때
- `systematic-debugging`: 버그 원인을 먼저 좁히고 수정할 때
- `test-driven-development`: 기능/버그 수정 전에 테스트부터 잡을 때
- `verification-before-completion`: 완료 주장 전에 검증 체크를 할 때

## Rules

- Each command gets one short Korean line.
- Explain Superpowers skills as Superpowers skills, not `$...` commands, unless the installed command is actually invoked with `$...` in the current client.
- Under `# 전체 목록`, always end with:
  - `전체 스킬+프롬프트 목록은 $guide`
- Do not mention `/help` unless the client explicitly supports it.
- Do not mention removed or unavailable commands unless they exist on disk again.
