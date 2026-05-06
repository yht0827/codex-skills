---
name: guide
description: '사용 가능한 스킬과 프롬프트 명령을 한글로 길게 안내할 때 쓰는 스킬'
---

# Guide

Use this skill when the user asks for the full command list, all skills, all prompts, or a command cheat sheet.

## Output Goal

- Show only commands that actually exist on disk.
- Write concise Korean descriptions.
- Keep the result scan-friendly, not exhaustive prose.
- Render these sections in order:
  1. `# Skills ($...)`
  2. `# Prompts (/prompts:...)`
  3. `# 빠른 예시`

## Data Sources

### Skills

Read skill frontmatter from these roots:

- `~/.agents/skills/*/SKILL.md`
- `~/.codex/skills/*/SKILL.md`
- `~/.codex/skills/.system/*/SKILL.md`
- `~/.codex/plugins/cache/*/*/*/skills/*/SKILL.md` for installed plugin skill sets such as Superpowers

Use the parent directory name as the skill name. Read `description:` from the YAML frontmatter. If the same skill appears in multiple roots, list it once.

### Prompts

Read prompt frontmatter from:

- `~/.codex/prompts/*.md`

Use the filename without `.md` as the prompt name. Read `description:` from the YAML frontmatter. If missing, use `설명 없음`.

## Collection Command

Prefer a small script or equivalent native file reads. This Python snippet is the reference behavior:

```bash
python3 - <<'PY'
from pathlib import Path
import re
home = Path.home()
skills = {}
roots = [home/'.agents/skills', home/'.codex/skills']
plugin_cache = home/'.codex/plugins/cache'
if plugin_cache.exists():
    roots.extend(p for p in plugin_cache.glob('*/*/*/skills') if p.is_dir())

for root in roots:
    if not root.exists():
        continue
    files = list(root.glob('*/SKILL.md')) + list(root.glob('*/*/SKILL.md'))
    for f in files:
        name = f.parent.name
        text = f.read_text(errors='ignore')[:2000]
        m = re.search(r'^description:\s*[\'\"]?(.*?)[\'\"]?\s*$', text, re.M)
        skills[name] = m.group(1).strip() if m else '설명 없음'

prompts = {}
prompt_root = home/'.codex/prompts'
if prompt_root.exists():
    for f in prompt_root.glob('*.md'):
        text = f.read_text(errors='ignore')[:2000]
        m = re.search(r'^description:\s*[\'\"]?(.*?)[\'\"]?\s*$', text, re.M)
        prompts[f.stem] = m.group(1).strip() if m else '설명 없음'

print('SKILLS')
for name in sorted(skills):
    print(f'{name}\t{skills[name]}')
print('PROMPTS')
for name in sorted(prompts):
    print(f'{name}\t{prompts[name]}')
PY
```

## Rendering Rules

- Render skills as `- $name: 설명`.
- Render prompts as `- /prompts:name: 설명`.
- Translate English descriptions naturally into Korean.
- Do not invent commands not found on disk.
- Do not mention commands that are not present on disk unless they are present on disk.
- Do not tell the user to use `/help` unless the client explicitly supports it.
- If a folder is missing, continue with the remaining folders and mention the missing source only if it materially affects the result.

## Preferred Descriptions

Use these fixed Korean lines when the matching command exists:

- `$humanizer`: `AI 티가 나는 글을 자연스럽고 사람 같은 문장으로 다듬는 글쓰기 스킬`
- `$quick-help`: `자주 쓰는 명령만 짧게 보여주는 스킬`
- `$superpowers-flow`: `Superpowers 전체 개발 흐름과 Compound 기록 단계를 참고하는 스킬`
- `$prd`: `기능 아이디어와 요구사항을 구현 가능한 PRD로 정리하는 스킬`
- `$ralph-flow`: `PRD 기반 장기 작업을 Ralph 방식으로 story 단위 반복 실행하는 흐름을 참고하는 스킬`
- `$ralph-json`: `PRD 문서나 요구사항을 Ralph 실행용 prd.json으로 변환하고 검증하는 스킬`
- `$handoff`: `다음 Codex 세션이 이어받을 수 있는 인계 문서를 작성하는 스킬`
- `$catchup`: `handoff를 실제 파일과 git 상태로 검증하고 이어갈 상태를 확인하는 스킬`
- `$code-explore`: `코드베이스 구조, entrypoint, 의존성, 테스트 흐름을 분석하는 스킬`
- `$code-quality`: `코드 품질, 테스트 품질, 보안, 성능, 유지보수 위험을 평가하는 스킬`
- `$diagnose`: `버그, 실패 테스트, flaky 현상, 성능 회귀의 원인을 재현 loop로 좁히는 스킬`
- `$spring-boot-init`: `Spring Initializr로 작은 Spring Boot 프로젝트를 생성하는 스킬`
- `$job-apply-fit`: `채용공고 링크를 확인해 Java/Spring 재취업 적합도를 판단하고 파일 DB에 기록하는 스킬`
- `$guide`: `사용 가능한 전체 스킬과 프롬프트를 한글로 안내하는 스킬`
- `$ce-compound`: `해결한 문제와 배운 점을 docs/solutions에 기록해 프로젝트 지식으로 축적하는 스킬`
- `$ce-compound-refresh`: `오래되거나 중복된 docs/solutions 지식을 갱신·통합·정리하는 스킬`
- `$brainstorming`: `코딩 전에 요구사항, 대안, 설계를 먼저 정리하는 Superpowers 필수 스킬`
- `$test-driven-development`: `구현 전에 실패 테스트부터 작성하는 Superpowers TDD 스킬`
- `$tdd-team`: `Team Lead/Red/Green/Refactor 4역할 TDD tmux 작업공간을 여는 스킬`
- `$verification-before-completion`: `완료를 주장하기 전에 실제 검증 결과를 확인하는 Superpowers 스킬`

## 빠른 예시

Include only examples backed by installed commands. Prefer:

- `$quick-help`
- `$guide`
- `$prd 알림 기능 PRD로 정리해줘`
- `$handoff 세션 끝내기 전에 정리해줘`
- `$catchup 이전 handoff 검증하고 이어갈 준비해줘`
- `$code-explore src 구조 분석해줘`
- `$code-quality 이 모듈 품질 점검해줘`
- `$diagnose 테스트 실패 원인부터 찾아줘`
- `$spring-boot-init 바탕화면에 웹 JSON API 프로젝트 만들어줘`
- `$job-apply-fit 이 채용공고 링크 보고 지원할지 판단하고 기록해줘`
- `$mario 코딩테스트 문제 같이 풀자`
- `/prompts:ce-compound 이번 버그 해결 과정 정리`
- `/prompts:ce-compound-refresh auth`
- `문장을 좀 덜 AI처럼 바꿔줘` → `$humanizer`
