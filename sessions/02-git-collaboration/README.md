# 10/8 — Git 사용법과 협업 방식

## 목표

수업이 끝나면 HacKHU-HP에서 다음을 혼자 할 수 있다.

1. 이슈를 받고 규칙에 맞는 브랜치를 `origin/develop`에서 만든다.
2. 규칙에 맞는 커밋 메시지로 커밋하고, PR을 올리고, 리뷰를 주고받고, 머지한다.
3. 충돌이 나면 해결한다.

## 진행 (1시간)

| 시간 | 내용 | 자료 |
|---|---|---|
| 0:00 – 0:05 | 준비 확인 — `gh auth status`, clone, `npm install` | [docs/setup.md](../../docs/setup.md) |
| 0:05 – 0:20 | 이론: Git 모델, HacKHU-HP 브랜치·커밋·PR 규칙 | [theory.md](theory.md) 1 ~ 6절 |
| 0:20 – 0:30 | 실습 1 (개인·로컬): merge 충돌 해결 | [lab/01-conflict.md](lab/01-conflict.md) 시나리오 1 |
| 0:30 – 0:55 | 실습 2 (짝·원격): 이슈 → 브랜치 → PR → 리뷰 → 머지 | [lab/02-first-pr.md](lab/02-first-pr.md) |
| 0:55 – 1:00 | 정리, 질문 | [cheatsheet.md](cheatsheet.md) |

## 수업 후 복습 (선택)

S2 시작 전에 해 두면 좋다.

| 내용 | 자료 |
|---|---|
| rebase 충돌 해결 | [lab/01-conflict.md](lab/01-conflict.md) 시나리오 2 |
| 원격 충돌과 `--force-with-lease` (짝과 함께) | [lab/03-pair-conflict.md](lab/03-pair-conflict.md) |
| 사고 복구 — amend, reset, revert, reflog, stash, 시크릿 커밋 | [lab/04-recovery.md](lab/04-recovery.md) |
| release 브랜치 → main 흐름 (PL이 할 일) | [lab/05-release-demo.md](lab/05-release-demo.md) |
| 리뷰 방법, squash merge 후 정리 | [theory.md](theory.md) 7 ~ 9절 |

## 이 저장소의 규칙

이 저장소에는 **HacKHU-HP와 같은 규칙**이 걸려 있다. 오늘 겪는 검사가 S2부터 매일 겪을 검사다.

| 규칙 | 검사하는 곳 |
|---|---|
| PR 제목 `type: 한글 설명` | `Lint PR / pr-title` (CI) |
| 커밋 메시지 형식 | `commit-msg` 훅 (로컬, `npm install` 시 설치) |
| `main`에는 `release/vX.Y.Z`만 PR | `Lint PR / pr-title` (CI) |
| 시크릿 금지 | `Security / gitleaks` (CI) |
| `develop`·`main` 직접 push 금지 | 저장소 ruleset |
