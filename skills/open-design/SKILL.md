---
name: open-design
description: 'Open Design 로컬 앱으로 웹/모바일 프로토타입, 대시보드, 랜딩, 덱 산출물을 만들거나 설치/실행/agent 감지/Codex 연결을 점검해야 할 때 쓰는 스킬'
---

# Open Design

Use this skill when the user wants to use, install, run, or evaluate `nexu-io/open-design`, or when they want Codex to help generate a design artifact through Open Design.

Treat Open Design as a local-first design product and agent wrapper. Do not treat it as a replacement for Superpowers, do not copy its bundled skills into Codex skills, and do not use it as the default path for normal frontend implementation work.

## 기본 판단

- Use Open Design for prototype/deck/design-output work: SaaS landing pages, dashboards, mobile flows, pricing pages, docs pages, visual experiments, and slide-like HTML decks.
- Use normal repo implementation flow for production code changes.
- Use Superpowers for the active development workflow. Use Open Design only for the design artifact or design exploration step.
- If the user asks for current install commands, releases, supported agents, or model/provider details, verify the upstream README, QUICKSTART, release page, or docs first because those details can drift.

## 빠른 확인

When setup or debugging is requested, first check the local state:

```bash
node -v
corepack pnpm --version
which codex
codex --version
docker compose version
```

Interpret the checks:

- Source mode expects Node 24.x and the pnpm version pinned by the repo.
- Codex mode needs `codex` on `PATH`; Open Design auto-detects supported agent CLIs on daemon start.
- Docker mode is useful for trying the web app, but published images do not bundle local agent CLIs.
- If no local agent CLI is available, use BYOK/API mode from Open Design settings.

## 실행 경로 선택

Prefer the smallest path that matches the user's goal:

- Desktop app: best first path for normal use. Point the user to the latest GitHub release after verifying it.
- Source mode: best for local development, debugging, or patching Open Design.
- Docker mode: best for quick web app evaluation or container deployment.
- BYOK/API mode: best when no local agent CLI should be spawned.

Source-mode baseline after verifying the upstream docs:

```bash
git clone https://github.com/nexu-io/open-design
cd open-design
nvm install 24
nvm use 24
corepack enable
corepack pnpm --version
pnpm install
pnpm tools-dev run web
```

For fixed local ports, use the repo-supported `tools-dev` flags after checking the current QUICKSTART:

```bash
pnpm tools-dev run web --daemon-port 17456 --web-port 17573
```

Docker baseline after verifying `deploy/README.md`:

```bash
cd deploy
OPEN_DESIGN_IMAGE=docker.io/vanjayak/open-design:latest docker compose up -d --no-build
```

Do not expose the daemon directly on a public or shared network. If remote access is needed, require an authenticated reverse proxy, SSH tunnel, or VPN and set allowed origins according to the current deployment docs.

## Skill 선택 가이드

Choose the Open Design skill by target artifact:

- Generic web prototype: `web-prototype`
- SaaS or product landing: `saas-landing`
- Internal tool or admin view: `dashboard`
- Pricing surface: `pricing-page`
- Documentation page: `docs-page`
- Mobile app screen flow: `mobile-app` or `mobile-onboarding`
- Presentation/deck: `simple-deck` or the bundled magazine-style deck skill if available
- Existing artifact critique: `critique`
- Small visual changes: `tweaks`

Then choose a design system that matches the brand or visual direction. If the user has no preference, start with the neutral default and ask for one visual constraint such as "enterprise", "editorial", "developer-tool", or "consumer mobile".

## 프롬프트 작성

Use a concrete artifact brief. Include domain, target user, surface, required sections, interaction states, and export intent.

Template:

```text
Create a [surface type] for [product/domain].
Target user: [primary user].
Goal: [what the user should understand or do].
Required sections/screens: [list].
State coverage: include empty, loading, error, and success states where relevant.
Visual direction: [brand/design-system cue].
Output: one polished HTML artifact suitable for Open Design preview and export.
```

For Korean users, keep the planning and final explanation in Korean, but let artifact copy follow the product's target language.

## 결과 확인

After generation:

- Confirm the artifact rendered in the preview.
- Save it to disk when the user wants a reusable file.
- Report the saved path, usually under `./.od/artifacts/<timestamp>-<slug>/index.html`.
- If production implementation is the next step, treat the artifact as reference material and re-read the target repo before coding.

## 문제 해결

- `no agents found on PATH`: check `which codex` or another supported CLI, then restart the Open Design daemon.
- Node or native addon errors: switch to the repo-required Node version and rerun install.
- Codex loads too much plugin context: start Open Design with `OD_CODEX_DISABLE_PLUGINS=1` if the current docs still support it.
- Daemon chat errors: inspect daemon logs and verify the selected agent CLI accepts the generated argv.
- Artifact does not render: check whether the model emitted the required artifact wrapper; try a stricter skill, clearer prompt, or stronger model.

## 완료 기준

- The chosen execution path is clear: desktop, source, Docker, or BYOK/API.
- Local prerequisites or blockers are reported.
- Open Design skill and design system choices are named.
- The prompt brief is concrete enough to generate a usable artifact.
- Saved artifact path and remaining risks are reported.
