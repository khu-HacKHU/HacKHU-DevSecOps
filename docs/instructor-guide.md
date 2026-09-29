# 진행자 가이드

## 저장소 설정

10/6 시연과 10/8 실습은 HacKHU-HP와 같은 흐름(develop 기본 브랜치, PR 필수, squash merge)을 전제로 한다. 아래 1 ~ 3은 **9/29에 적용해 두었다.** 바뀌었는지 의심되면 `gh api repos/khu-HacKHU/HacKHU-DevSecOps/rulesets`로 확인한다.

### 1. 브랜치

- `main`, `develop` 두 개. **기본 브랜치는 `develop`**이다.

### 2. 머지 방식

- squash merge, merge commit만 허용 (rebase merge 끔). merge commit은 `release → main`에만 쓴다.
- squash 커밋 제목은 PR 제목 그대로, 본문은 비운다 — PR 템플릿의 체크리스트가 히스토리에 남지 않게.
- 머지 후 원격 브랜치 자동 삭제.

### 3. Ruleset (Settings → Rules → Rulesets)

| 이름 | 대상 | 규칙 |
|---|---|---|
| `develop` | `develop` | PR 필수 (승인 1), 필수 검사 `pr-title`·`gitleaks`, 허용 머지 방식 squash, force push·삭제 금지 |
| `main` | `main` | PR 필수 (승인 1), 필수 검사 `pr-title`·`gitleaks`, 허용 머지 방식 merge, force push·삭제 금지 |
| `release` | `release/**` | PR 필수, 허용 머지 방식 squash, force push·삭제 금지 |

- 우회(bypass) 권한은 아무에게도 주지 않았다. 관리자도 PR과 승인 1명을 거친다 — 진행자가 자료를 고칠 때도 PM 등 다른 사람의 승인이 필요하다.
- 코드 오너 리뷰는 필수로 걸지 않았다. 문서·자료의 오너가 PL 한 명이라, 필수로 걸면 PL이 올린 PR을 승인할 수 있는 사람이 없다. [CODEOWNERS](../.github/CODEOWNERS)는 리뷰어 자동 지정용으로만 쓴다.

### 이슈·PR 템플릿

- 이슈: [작업](../.github/ISSUE_TEMPLATE/1-task.yml), [버그·오류](../.github/ISSUE_TEMPLATE/2-bug.yml), [보안 경고 판별](../.github/ISSUE_TEMPLATE/3-security.yml). 빈 이슈는 웹에서 막았다 (`gh issue create --title --body`는 그대로 된다).
- PR: [pull_request_template.md](../.github/pull_request_template.md)
- 보안 경고 판별 템플릿은 HacKHU-HP [tools.md](https://github.com/khu-HacKHU/HacKHU-HP/blob/develop/docs/security/tools.md)의 판별 규칙과 같다. S2부터 HacKHU-HP에도 같은 템플릿을 두면 1R 담당자가 그대로 쓸 수 있다.

### 4. 권한

- 참가자 전원을 organization 멤버로 초대하고, 이 저장소에 **Write** 권한을 준다 (org 팀을 만들어 팀 단위로 주는 것을 권장).
- Write가 없으면 포크 기반이 되어 실습 흐름이 달라진다.

### 5. 짝 정하기

실습 2는 짝이 서로의 PR을 리뷰한다. 짝을 미리 정해 공지한다. 복습용 실습 3에서도 같은 짝과 짝 번호(1 ~ 20)를 쓴다. 20쌍을 넘으면 [team-rules.md](../sessions/02-git-collaboration/lab/team-rules.md)에 칸을 추가한다.

## 10/6 — 이론 1시간 (시연 포함)

진행표는 [sessions/01-security-tools/README.md](../sessions/01-security-tools/README.md).

### 체크리스트

- [ ] 저장소 설정 1 ~ 3이 그대로인지 확인 — 시연이 `develop` 대상 PR과 `gitleaks` 필수 검사를 쓴다
- [ ] 전날 [demo.md](../sessions/01-security-tools/demo.md) 리허설, 백업 PR과 캡처 준비

### 진행 팁

- 핵심은 이론 7절 **"도구가 못 잡는 것"**이다. SQL 인젝션과 IDOR 예시 코드를 나란히 보여 주고 "어느 쪽을 도구가 잡을까?"를 먼저 물어본다.
- 4절 도구별 설명에서 1R 담당자(SAST·SCA·시크릿·IaC)를 호명해 자기 영역을 인지시키면 S2 준비가 된다.
- 9절 질문 중 1번(지운 시크릿)과 3번(버튼 숨기기)은 거의 모두가 틀린다. 토론 시작용으로 좋다.

## 10/8 — 이론 + 실습 1시간

진행표는 [sessions/02-git-collaboration/README.md](../sessions/02-git-collaboration/README.md).

### 체크리스트

- [ ] 저장소 설정 1 ~ 3 확인, 4 ~ 5 완료
- [ ] 참가자 전원 org 초대 수락 확인 (`gh api orgs/khu-HacKHU/members --paginate --jq '.[].login'`)
- [ ] 테스트 PR로 `pr-title`, `gitleaks` 검사가 도는지 확인
- [ ] 전날 [setup.md](setup.md) 재공지, 짝 공지

### 진행 팁

- 시간이 가장 빠듯한 곳은 실습 2(25분)다. 준비 확인에서 `gh auth status`가 안 되는 사람은 옆 사람과 짝 PR 하나를 같이 진행하게 한다.
- 이론은 15분이라 theory.md 1 ~ 6절만 다룬다. 7 ~ 9절(리뷰, 금지 사항, 로컬 정리)은 복습으로 넘긴다.
- 실습 1은 시나리오 1(merge)만 한다. rebase는 복습.
- 실습 2에서 PR 제목 `:`을 일부러 빠뜨리게 한다. CI에서 막히는 경험이 규칙을 가장 빨리 익힌다.

## 수업 후

- [ ] `participants/`, `team-rules.md`가 쌓인 develop을 main으로 release ([실습 5](../sessions/02-git-collaboration/lab/05-release-demo.md) 흐름으로)
- [ ] 두 수업에서 나온 질문 중 HacKHU-HP 문서에 반영할 것은 HacKHU-HP 이슈로 등록
