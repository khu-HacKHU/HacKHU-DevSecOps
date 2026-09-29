# 시연 — gitleaks가 PR을 막는다 (10분)

진행자가 화면을 공유하고 진행한다. 참가자는 보기만 한다. [theory.md 4.3절](theory.md#43-시크릿-스캔) 직후에 한다.

**보여 줄 것**
1. 시크릿이 들어간 PR은 CI가 막는다.
2. 다음 커밋에서 지워도 **여전히 막힌다.**
3. PR을 닫고 브랜치를 지워도 **커밋은 GitHub에 남는다.** 그래서 대응은 "키 폐기"다.

> 키는 `openssl rand`로 만든 무작위 값이라 어디에도 쓰이지 않는다. 그래도 진짜 키처럼 다룬다.

## 사전 준비 (진행자, 수업 전날)

- [ ] 이 저장소에 `develop` 브랜치가 있고, `develop` ruleset에 `gitleaks`가 필수 검사로 걸려 있다 ([instructor-guide.md](../../docs/instructor-guide.md) 1 ~ 3절)
- [ ] 아래 1 ~ 3단계를 한 번 리허설하고, **그 PR을 열어 둔 채로 둔다** — 수업 중 와이파이·Actions가 느리면 이 PR로 대신 설명한다
- [ ] 리허설 PR의 Checks 화면, 로그의 `leaks found`, 비활성화된 Merge 버튼을 캡처해 둔다 (최후의 백업)
- [ ] 로컬 clone이 최신이고 `gh auth status`가 로그인 상태다

## 1단계 — 시크릿을 커밋하고 PR (3분)

```bash
git fetch origin
git switch -c chore/0-demo-config origin/develop

mkdir -p demo
echo "API_TOKEN = \"$(openssl rand -hex 20)\"" > demo/config.py
cat demo/config.py

git add demo/config.py
git commit -m "chore: 데모 설정 추가"
git push -u origin HEAD
gh pr create --base develop --title "chore: 데모 설정 추가" --body "10/6 gitleaks 시연용. 머지하지 않는다."
gh pr view --web
```

**화면에서 짚을 것**
- Checks 탭: `Security / gitleaks` ❌ (30초 ~ 1분 걸린다. 기다리는 동안 "봇이 공개 저장소의 키를 몇 분 안에 가져간다"는 이야기를 한다)
- 실패한 잡의 로그: `RuleID: generic-api-key`, `File: demo/config.py`, `Secret: REDACTED`
  - `--redact` 덕분에 **CI 로그에는 키가 안 찍힌다.** 로그도 공개되기 때문이다.
- PR 하단: 필수 검사 실패로 **Merge 버튼이 비활성화**돼 있다.

질문: "그럼 이 줄을 지우고 다시 올리면 되지 않나요?"

## 2단계 — 지우고 다시 push (3분)

```bash
git rm demo/config.py
git commit -m "chore: 데모 설정 제거"
git push
```

**화면에서 짚을 것**
- **Files changed 탭이 비어 있다.** PR 전체로 보면 바뀐 게 없다.
- 그런데 gitleaks는 **또 ❌**다. PR에 들어간 **커밋을 하나씩** 보기 때문이다 (`BASE..HEAD` 범위, [security.yml](../../.github/workflows/security.yml)).
- Commits 탭에서 첫 커밋을 누르면 키가 그대로 보인다.

```text
최종 파일      : 키 없음
커밋 히스토리  : 1번 커밋에 키 있음  ← gitleaks가 보는 곳, 공격자가 보는 곳
```

## 3단계 — PR을 닫고 브랜치를 지우면? (2분)

1단계 커밋 해시를 먼저 복사해 둔다 (Commits 탭).

```bash
gh pr close --delete-branch
```

브라우저에서 복사해 둔 커밋 주소를 연다.

```text
https://github.com/khu-HacKHU/HacKHU-DevSecOps/commit/<1단계 커밋 해시>
```

**여전히 열린다.** 닫힌 PR의 커밋은 GitHub에 계속 남고, 그 사이 누군가 clone·fork했다면 그쪽에도 남는다.

## 정리 (2분)

| 한 일 | 키가 안전해졌나? |
|---|---|
| 다음 커밋에서 삭제 | ✗ — 히스토리에 있다 |
| PR 닫기, 브랜치 삭제 | ✗ — 커밋 주소로 열린다 |
| force push로 히스토리 덮어쓰기 | ✗ — 이미 가져간 사람에게 남는다 |
| **키 폐기·재발급** | ✅ — 유출된 키가 쓸모없어진다 |

HacKHU-HP에서 시크릿이 유출됐을 때:

1. **즉시 키를 폐기·재발급한다.**
2. PL에게 알린다.
3. 새 키는 GitHub Secrets에 넣는다.
4. 커밋 제거 여부는 PL이 판단한다.

그리고 이것이 **gitleaks만 PR을 막는 이유**다 ([theory.md 5절](theory.md#5-차단할-것인가-보고만-할-것인가)). 다른 취약점은 머지 후에 고쳐도 되지만, push된 시크릿은 되돌릴 수 없다.

## 시연 후 (진행자)

- [ ] 로컬 브랜치 삭제: `git switch develop && git branch -D chore/0-demo-config`
- [ ] 리허설용으로 열어 둔 PR도 닫고 브랜치 삭제
