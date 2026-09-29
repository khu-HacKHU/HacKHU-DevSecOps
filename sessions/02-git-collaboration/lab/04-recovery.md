# 실습 4 — 사고 복구 (개인·로컬, 복습)

S2부터 실제로 겪을 실수들이다. [실습 1](01-conflict.md)의 연습 저장소에서 한다.

```bash
bash sessions/02-git-collaboration/lab/scripts/conflict-lab.sh --reset
cd ~/hackhu-conflict-lab
git switch develop
```

**원칙: push 전이면 히스토리를 고쳐도 된다. push 후에는 새 커밋으로 되돌린다.**

| 상황 | push 전 | push 후 |
|---|---|---|
| 메시지 오타 | `commit --amend` | 작업 브랜치면 amend 후 `--force-with-lease`, 아니면 그대로 둔다 (squash 때 PR 제목이 남는다) |
| 잘못된 커밋 | `reset` | `revert` |
| 시크릿 커밋 | `reset` 후 다시 커밋 | **키 폐기·재발급이 먼저.** 히스토리 정리는 PL 판단 |

## 1. 커밋 메시지를 잘못 썼다

```bash
echo "- 회비: 학기당 1만 원" >> notice.md
git commit -am "docs: 회비 안내 추갸"
git commit --amend -m "docs: 회비 안내 추가"
git log --oneline -2
```

`--amend`는 마지막 커밋을 **새 커밋으로 교체**한다. 파일을 빠뜨렸을 때도 `git add` 후 `git commit --amend --no-edit`.

## 2. develop에 직접 커밋해 버렸다

브랜치 만드는 것을 잊고 develop에서 작업·커밋했다. HacKHU-HP에서는 push가 막히지만, 로컬 develop이 원격과 어긋나 버린다.

```bash
git switch develop
echo "- 뒤풀이: 모임 후 자율" >> notice.md
git commit -am "docs: 뒤풀이 안내 추가"

# 1) 지금 위치에 작업 브랜치 이름표를 붙인다 — 커밋은 그대로 살아 있다
git branch docs/5-after-party

# 2) develop을 커밋 하나 전으로 되돌린다
#    실제 프로젝트에서는: git reset --hard origin/develop
git reset --hard HEAD~1

# 3) 작업 브랜치로 옮겨 간다
git switch docs/5-after-party
git log --oneline --graph --all
```

## 3. 파일 변경을 취소하고 싶다

```bash
echo "잘못 쓴 내용" >> config.py
git add config.py
git restore --staged config.py   # 스테이징만 취소 (파일 내용은 남는다)
git restore config.py            # 파일 내용까지 마지막 커밋으로 (복구 불가, 주의)
git status
```

## 4. 이미 공유한 커밋을 되돌리고 싶다 — revert

develop에 들어간 커밋이 문제를 일으켰다. 공유된 히스토리는 지우지 않고 **반대 변경을 새 커밋으로** 만든다.

```bash
git switch develop
git log --oneline -3
git revert HEAD                  # 마지막 커밋의 반대 커밋. 메시지 편집기가 열리면 저장
git log --oneline -3
```

HacKHU-HP에서는 revert도 PR로 올린다. GitHub PR 페이지의 "Revert" 버튼이 revert 브랜치와 PR을 만들어 준다.

## 5. reset --hard로 커밋을 날렸다 — reflog

```bash
git switch docs/5-after-party
git reset --hard HEAD~1          # 방금 커밋이 사라졌다
git log --oneline -3

git reflog                       # HEAD가 거쳐 간 모든 위치
git reset --hard HEAD@{1}        # 날리기 직전으로
git log --oneline -3
```

reflog는 **로컬에만** 있고 기본 90일 보관된다. 커밋한 적이 있다면 거의 항상 되살릴 수 있다. 커밋하지 않은 변경은 되살릴 수 없다 — **자주 커밋한다.**

## 6. 작업 중에 급히 다른 브랜치로 가야 한다 — stash

```bash
echo "작업 중" >> notice.md
git switch develop               # 충돌 가능성이 있으면 거절된다
git stash push -m "공지 작업 중"
git switch develop
# ... 급한 일 ...
git switch docs/5-after-party
git stash pop
```

stash는 쌓아 두면 잊어버린다. 오래 둘 것이면 차라리 `wip` 브랜치에 커밋한다 (squash되므로 메시지는 신경 쓰지 않아도 된다 — 단 커밋 훅은 `--no-verify`로 넘긴다).

## 7. 시크릿을 커밋했다

**push 전**

```bash
echo "DB_PASSWORD = \"$(openssl rand -hex 12)\"" >> config.py
git commit -am "chore: DB 설정"
git reset --soft HEAD~1          # 커밋만 취소, 변경은 스테이징에 남는다
git restore --staged config.py
git restore config.py            # 시크릿 줄 제거
git log --oneline -2
```

시크릿은 `.env`(커밋 안 됨)에 두고 코드는 환경변수로 읽는다.

**push 후**

1. **즉시 키를 폐기·재발급한다.** 커밋 삭제·force push로는 해결되지 않는다 (포크, 캐시, clone에 남는다).
2. PL에게 알린다.
3. 새 키는 GitHub Secrets에 넣는다.
4. 히스토리에서 제거할지는 PL이 판단한다.

다음 커밋에서 지워도 gitleaks는 히스토리에서 찾아낸다 ([10/6 이론 4.3](../../01-security-tools/theory.md#43-시크릿-스캔)).

## 정리

```bash
cd ~
rm -rf ~/hackhu-conflict-lab
```
