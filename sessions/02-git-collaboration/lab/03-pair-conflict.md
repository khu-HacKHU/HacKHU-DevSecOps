# 실습 3 — 원격 충돌과 rebase (짝·원격, 복습)

실습 2의 짝과 한다. 진행자가 짝마다 번호를 정해 준다. 아래에서는 **짝 7**이라고 하자.

[team-rules.md](team-rules.md)에는 짝마다 칸이 하나씩 있다. 두 사람이 **같은 칸을 동시에** 고쳐서 PR을 올린다. 먼저 머지된 쪽은 그대로 들어가고, 나중 쪽은 충돌이 난다.

## 1. 각자 이슈와 브랜치

두 사람이 **각자** 한다.

```bash
gh issue create --repo khu-HacKHU/HacKHU-DevSecOps \
  --title "docs: 짝 7 협업 규칙 제안 — 내GitHubID" --assignee @me --body "team-rules.md 짝 7 칸"

git fetch origin
git switch -c docs/31-pair7-rule origin/develop
```

## 2. 같은 칸을 고친다

`team-rules.md`의 `## 짝 7` 아래 `(비어 있음)`을 지우고, 각자 **서로 다른** 협업 규칙 하나를 쓴다. 상의하지 않는다.

```text
## 짝 7

PR은 하루 안에 리뷰한다. 못 하면 코멘트로 언제 볼지 알린다. — @내GitHubID
```

```bash
git add sessions/02-git-collaboration/lab/team-rules.md
git commit -m "docs: 짝 7 협업 규칙 제안"
git push -u origin HEAD
gh pr create --base develop --assignee @me --reviewer 짝GitHubID \
  --title "docs: 짝 7 협업 규칙 제안" --body "Closes #31"
```

## 3. 먼저 머지 (A)

서로 리뷰·승인한 뒤, **A만** 먼저 Squash and merge 한다.

B의 PR 페이지에 "This branch has conflicts that must be resolved"가 뜬다.

## 4. 충돌 해결 (B)

웹의 "Resolve conflicts" 버튼 대신 **로컬에서 rebase로** 푼다. HacKHU-HP에서 쓸 방법이다.

```bash
git fetch origin
git rebase origin/develop
```

```text
CONFLICT (content): Merge conflict in sessions/02-git-collaboration/lab/team-rules.md
```

A와 **상의해서** 두 규칙을 합친 결과를 만든다. 둘 다 남겨도 되고, 하나로 다듬어도 된다. 충돌 표시를 모두 지운다.

```bash
git add sessions/02-git-collaboration/lab/team-rules.md
git rebase --continue
```

## 5. push — `--force-with-lease`

rebase는 커밋을 **다시 만들었으므로** 원격 브랜치와 히스토리가 달라졌다. 그냥 `git push`는 거절된다.

```bash
git push                      # rejected (non-fast-forward)
git push --force-with-lease   # 원격이 내가 마지막으로 본 상태일 때만 덮어쓴다
```

| 명령 | 동작 |
|---|---|
| `--force` | 원격에 무엇이 있든 덮어쓴다. 그 사이 다른 사람이 push한 커밋이 **사라진다** |
| `--force-with-lease` | 내가 마지막으로 fetch한 뒤 원격이 바뀌었으면 거절한다 |

**force push는 나 혼자 쓰는 작업 브랜치에서만** 한다. `develop`·`main`은 ruleset이 막는다.

PR 페이지에서 충돌이 사라졌는지 확인하고, A가 다시 승인하면 머지한다.

## 확인 질문

1. 웹의 "Resolve conflicts" 버튼으로 풀면 어떤 커밋이 생기는가? rebase로 풀 때와 무엇이 다른가?
2. 충돌을 푼 사람이 A와 상의하지 않았다면 어떤 문제가 생길 수 있는가?
3. 이 실습에서 충돌을 **피하려면** 어떻게 했어야 하는가?
