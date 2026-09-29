# 실습 1 — 충돌 해결 (개인·로컬, 수업 10분 + 복습)

원격 없이 내 PC에서 한다. 스크립트가 이 저장소 **밖**(`~/hackhu-conflict-lab`)에 연습용 저장소를 만든다.

```bash
# 이 저장소 루트에서
bash sessions/02-git-collaboration/lab/scripts/conflict-lab.sh
cd ~/hackhu-conflict-lab
git log --oneline --graph --all
```

그래프를 보고 답한다: `feat/1-meeting-time`과 `develop`은 어느 커밋에서 갈라졌는가?

## 시나리오 1 — merge 충돌

나는 `feat/1-meeting-time`에서 모임 요일을 목요일로 바꿨다. 그 사이 develop에서 누군가 같은 줄의 시간을 18:30으로 바꾸고, 문의처 줄도 고쳤다.

```bash
git switch feat/1-meeting-time
git merge develop
```

```text
CONFLICT (content): Merge conflict in notice.md
Automatic merge failed; fix conflicts and then commit the result.
```

### 1. 상태 확인

```bash
git status          # "both modified: notice.md"
cat notice.md
```

```text
<<<<<<< HEAD
- 정기 모임: 매주 목요일 19:00
=======
- 정기 모임: 매주 화요일 18:30
>>>>>>> develop
- 장소: 전자정보대학관 245호
- 문의: 운영진 단톡방, 디스코드 #문의
```

| 표시 | 뜻 |
|---|---|
| `<<<<<<< HEAD` ~ `=======` | 내 쪽 (지금 있는 브랜치) |
| `=======` ~ `>>>>>>> develop` | 합치려는 쪽 |

문의 줄은 충돌이 아니다. 한쪽만 바꿨으므로 Git이 알아서 합쳤다. 단, 두 변경이 **바로 붙은 줄**이면 Git은 한 덩어리로 보고 충돌로 처리한다.

### 2. 해결

**어느 쪽이 맞는지는 Git이 아니라 사람이 정한다.** 실제 프로젝트라면 develop 쪽 변경을 한 사람에게 물어본다. 여기서는 "목요일 18:30"이 정답이라고 하자.

에디터로 `notice.md`를 열어 표시(`<<<<<<<`, `=======`, `>>>>>>>`)를 **모두 지우고** 원하는 결과만 남긴다.

```text
- 정기 모임: 매주 목요일 18:30
```

VS Code는 충돌 부분 위에 `Accept Current | Accept Incoming | Accept Both` 버튼을 보여 준다. 둘 다 아닌 새 결과가 필요할 때는 직접 고친다.

### 3. 마무리

```bash
grep -n '<<<<<<<\|>>>>>>>' notice.md   # 아무것도 안 나와야 한다
git add notice.md
git commit                               # 기본 메시지 "Merge branch 'develop' ..." 그대로 저장
git log --oneline --graph --all
```

> 되돌리고 싶으면 `git merge --abort` — merge 시작 전으로 돌아간다.

## 시나리오 2 — rebase 충돌 (복습)

HacKHU-HP에서 작업 브랜치를 최신 develop에 맞출 때는 merge 대신 **rebase**를 쓴다. rebase는 내 커밋을 develop 끝에 **하나씩 다시 적용**하므로 충돌도 커밋 단위로 난다.

```bash
git switch feat/2-upload-limit
git log --oneline --graph --all
git rebase develop
```

```text
CONFLICT (content): Merge conflict in config.py
error: could not apply xxxxxxx... feat: 업로드 크기 제한 상향
```

내 커밋 2개 중 첫 번째에서 멈췄다. develop은 보안 이유로 제한을 5MB로 **낮췄고**, 나는 20MB로 **올렸다.**

```bash
git status
cat config.py
```

rebase 중에는 `HEAD`가 develop 쪽이고, 적용 중인 내 커밋이 반대쪽이다 (merge와 **반대**다). 헷갈리면 커밋 메시지를 보고 판단한다.

이번에는 `security:` 커밋을 존중해 **5MB**를 남긴다고 하자.

```bash
# config.py를 고친 뒤
git add config.py
git rebase --continue    # 다음 커밋(webp 허용)은 충돌 없이 적용된다
git log --oneline --graph --all
```

- develop 끝으로 옮겨진 내 커밋은 몇 개인가? "업로드 크기 제한 상향"은 어디 갔는가?
  (힌트: 충돌을 develop 쪽으로 풀었으니 그 커밋이 바꾸는 내용이 **하나도 없게** 됐다. Git은 빈 커밋을 버린다.)
- "webp 업로드 허용" 커밋의 해시가 rebase 전과 달라졌는가? (`git reflog`로 비교)

> 되돌리고 싶으면 `git rebase --abort`.

## 확인 질문

1. 충돌 표시를 지우지 않고 `git add`하면 어떻게 되는가? (해 보고 `git show`로 확인)
2. merge와 rebase 중 PR 리뷰 도중 브랜치를 최신화할 때 무엇을 쓰는가? 그 후 push는 어떻게 해야 하는가?
3. 충돌이 자주 나는 것을 줄이려면 어떻게 해야 하는가? ([theory.md 4절](../theory.md#4-브랜치-전략))

다시 하려면:

```bash
bash sessions/02-git-collaboration/lab/scripts/conflict-lab.sh --reset
```
