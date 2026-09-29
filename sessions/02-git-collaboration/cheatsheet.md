# Git 치트시트 — HacKHU-HP 흐름 기준

## 매일 쓰는 것

```bash
# 새 작업 시작 (이슈 #12)
git fetch origin
git switch -c feat/12-notice-list origin/develop

# 작업 → 확인 → 커밋
git status
git diff                         # 아직 add 안 한 변경
git add 파일경로                   # git add . 보다 파일을 지정하는 습관
git diff --staged                # 커밋될 변경
git commit -m "feat: 공지 목록 조회 API 구현"

# 올리기
git push -u origin HEAD          # 첫 push
git push                         # 이후

# PR
gh pr create --base develop --assignee @me --title "feat: 공지 목록 조회 API 구현" --body "Closes #12"
gh pr status
gh pr checks
```

## 최신 develop 따라가기

```bash
git fetch origin
git rebase origin/develop        # 충돌 시: 고치고 → git add → git rebase --continue
git push --force-with-lease      # rebase 후에는 이것만. --force 금지
```

## 머지된 뒤 정리

```bash
git switch develop && git pull
git branch -D feat/12-notice-list    # squash merge라 -d는 거절된다
git fetch --prune
```

## 보기

```bash
git log --oneline --graph --all -20
git log -p 파일경로                   # 파일 변경 이력
git blame 파일경로                    # 줄마다 누가 언제
git show 커밋해시
git diff origin/develop...HEAD       # 내 브랜치가 develop 대비 바꾼 것 (PR과 같은 diff)
```

## 되돌리기

| 하고 싶은 것 | 명령 | push 후에도? |
|---|---|---|
| 작업 중 파일 변경 버리기 | `git restore 파일` | — |
| add 취소 | `git restore --staged 파일` | — |
| 마지막 커밋 메시지 수정 | `git commit --amend -m "..."` | 내 작업 브랜치만, `--force-with-lease` |
| 마지막 커밋에 파일 추가 | `git add 파일 && git commit --amend --no-edit` | 내 작업 브랜치만 |
| 마지막 커밋 취소 (변경은 남김) | `git reset --soft HEAD~1` | ✗ |
| 커밋 되돌리는 새 커밋 | `git revert 해시` | ✅ 공유 브랜치는 이것 |
| 날린 커밋 찾기 | `git reflog` → `git reset --hard HEAD@{n}` | 로컬만 |
| 잠깐 치워 두기 | `git stash push -m "메모"` / `git stash pop` | — |
| merge·rebase 중단 | `git merge --abort` / `git rebase --abort` | — |

## 커밋 메시지

```text
type: 한글 설명          (72자 이내, scope 없음, 이슈 번호 없음)

왜 바꿨는지 (선택)
```

`feat` `fix` `security` `docs` `design` `cicd` `refactor` `test` `chore` `release`

## 브랜치 이름

```text
{type}/{이슈번호}-{영어-kebab-case}
feat/12-notice-list   fix/31-login-loop   security/57-post-owner-check
release/v0.1.0        ← PL만
```

## 하지 말 것

- `develop`·`main`에서 직접 커밋·push
- 다른 사람 브랜치에 rebase·force push
- `git push --force` (→ `--force-with-lease`)
- `.env`, 키, 비밀번호 커밋 — 했다면 **키부터 폐기**하고 PL에게
- 확인 없이 `git add .`
