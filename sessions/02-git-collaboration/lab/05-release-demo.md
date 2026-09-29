# 실습 5 — release 흐름 (복습 — PL이 할 일)

S5 운영 배포 때 PL이 할 일이다. 팀원은 흐름만 이해하면 된다. `main` 대상 PR 머지는 권한이 있는 사람만 할 수 있으므로 읽으면서 흐름을 따라간다.

```text
develop ──> release/v0.1.0 ──PR (merge commit)──> main
                 ↑
   fix/42-blocker ──PR (squash)
                 │
                 └──PR (squash)──> develop   (release에만 들어간 수정 되돌리기)
```

## 1. develop → main 직접 PR은 막힌다

```bash
gh pr create --base main --head develop --title "release: v0.1.0 출시" --body "시연"
```

`Lint PR / pr-title`의 **PR 출발 브랜치 검사**가 실패한다.

```text
main 대상 PR은 release/vX.Y.Z 브랜치에서만 시작할 수 있습니다: develop
```

규칙은 [.github/scripts/validate-pr-source.sh](../../../.github/scripts/validate-pr-source.sh)에 있다. PR을 닫는다.

## 2. release 브랜치 만들기

```bash
git fetch origin
git switch -c release/v0.1.0 origin/develop
git push -u origin HEAD
```

이 시점부터 release 브랜치에는 **새 기능을 넣지 않는다.** develop은 다음 버전 개발을 계속한다.

## 3. 출시를 막는 버그 수정

```bash
git switch -c fix/42-release-blocker origin/release/v0.1.0
# 수정 ...
git commit -am "fix: 출시 전 오류 수정"
git push -u origin HEAD
gh pr create --base release/v0.1.0 --title "fix: 출시 전 오류 수정" --body "Closes #42"
```

Squash merge.

## 4. main으로 출시

```bash
gh pr create --base main --head release/v0.1.0 --title "release: v0.1.0 출시" --body "출시 내용 요약"
```

이번에는 검사를 통과한다. **Create a merge commit**으로 머지한다 — main 히스토리에 "어느 버전이 언제 들어갔는지"가 남는다.

```bash
git fetch origin
git tag v0.1.0 origin/main
git push origin v0.1.0
gh release create v0.1.0 --generate-notes
```

## 5. release 수정을 develop에 되돌리기

3에서 release에만 들어간 수정을 develop에도 반영한다.

```bash
gh pr create --base develop --head release/v0.1.0 --title "chore: v0.1.0 출시 수정 반영" --body ""
```

Squash merge. 끝나면 release 브랜치를 지운다.

## 왜 이렇게 하나

- `main` = 운영에 있는 코드. 언제든 main을 보면 운영 상태를 안다.
- 출시 준비(QA, 버그 수정) 중에도 develop에서 다음 기능 개발을 멈추지 않아도 된다.
- 운영 배포 워크플로는 main push에만 걸면 된다.
