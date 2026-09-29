# 실습 2 — 첫 PR: 이슈 → 브랜치 → 커밋 → PR → 리뷰 → 머지 (짝·원격, 25분)

HacKHU-HP에서 매번 할 흐름을 그대로 한 번 돈다. 결과물은 [participants/](../../../participants/)에 내 소개 파일 하나다.

짝을 정한다. 짝이 내 PR의 리뷰어다.

## 1. 이슈 만들기

```bash
gh issue create --repo khu-HacKHU/HacKHU-DevSecOps \
  --title "docs: 참가자 소개 추가 — 내GitHubID" \
  --body "participants/에 내 소개 파일을 추가한다." \
  --assignee @me
```

출력된 이슈 번호를 기억한다. 아래에서는 `23`이라고 하자.

> 웹에서 만들어도 된다. HacKHU-HP에서는 PM·PL이 이슈를 만들어 할당하고, 이슈는 Projects 보드에서 관리한다.

## 2. 브랜치 만들기

**항상 최신 `origin/develop`에서 자른다.**

```bash
git fetch origin
git switch -c docs/23-add-내GitHubID origin/develop
```

브랜치 이름 규칙: `{type}/{이슈번호}-{slug}` — `#` 없이 숫자만, slug는 영어 kebab-case.

## 3. 파일 만들기

```bash
cp participants/TEMPLATE.md participants/내GitHubID.md
```

에디터로 열어 채운다. **개인정보(전화번호, 학번 등)는 쓰지 않는다.** 공개 저장소다.

## 4. 커밋 — 훅에 한 번 걸려 보기

```bash
git status
git add participants/내GitHubID.md
git diff --staged       # 무엇이 커밋될지 확인하는 습관
```

일부러 규칙에 안 맞는 메시지로 커밋해 본다.

```bash
git commit -m "소개 추가"
git commit -m "docs(participants): 소개 추가"
git commit -m "docs: 소개 추가 #23"
```

셋 다 `commit-msg` 훅이 막는다 (`npm install`을 안 했다면 통과된다 — 그래도 CI에서 걸린다). 에러 메시지를 읽고 규칙에 맞게 커밋한다.

```bash
git commit -m "docs: 참가자 소개 추가"
```

## 5. push와 PR

```bash
git push -u origin HEAD
gh pr create --base develop --assignee @me --reviewer 짝GitHubID \
  --title "docs 참가자 소개 추가" \
  --body "Closes #23"
```

제목에 `:`을 **일부러 빠뜨렸다.** PR 페이지의 Checks 탭에서 `Lint PR / pr-title`이 실패하는 것을 확인한다. 로컬 훅을 통과해도 **PR 제목**이 틀리면 CI에서 막힌다 — squash merge에서 히스토리에 남는 것이 PR 제목이기 때문이다.

제목을 고친다.

```bash
gh pr edit --title "docs: 참가자 소개 추가"
```

검사가 다시 돌고 통과하는지 확인한다.

## 6. 리뷰 (짝끼리 서로)

짝의 PR을 연다.

```bash
gh pr list --repo khu-HacKHU/HacKHU-DevSecOps --search "review-requested:@me"
gh pr view 짝PR번호 --web
```

**Files changed** 탭에서 줄 번호 옆 `+`를 눌러 코멘트를 **하나 이상** 남긴다. 강도를 붙인다.

```text
[제안] 관심 분야에 HacKHU-HP에서 맡은 팀도 적어 주면 좋겠어요.
[질문] ...
```

리뷰를 받은 사람은 코멘트를 반영해 **새 커밋**으로 push하고, 코멘트에 답한다.

```bash
git add participants/내GitHubID.md
git commit -m "docs: 리뷰 반영"
git push
```

반영을 확인한 리뷰어는 **Review changes → Approve**.

## 7. 머지

승인과 검사 통과를 확인하고, PR 작성자가 **Squash and merge**로 머지한다.

- 머지 커밋 제목이 PR 제목 + ` (#PR번호)`인지 확인한다.
- 이슈가 자동으로 닫혔는지 확인한다 (`Closes #23` 덕분).

## 8. 로컬 정리

```bash
git switch develop 2>/dev/null || git switch -c develop origin/develop
git pull
git log --oneline -5              # 내 PR이 커밋 하나로 들어와 있다
git branch -d docs/23-add-내GitHubID   # 에러가 난다 — 왜일까? (theory.md 9절)
git branch -D docs/23-add-내GitHubID
git fetch --prune
```

## 확인 질문

1. 리뷰 반영 커밋 "docs: 리뷰 반영"은 develop 히스토리에 남았는가?
2. PR 제목이 틀렸는데 로컬 커밋 메시지는 맞았다. 무엇이 develop에 남는가?
3. 내 브랜치를 로컬 `develop`이 아니라 `origin/develop`에서 자른 이유는?
