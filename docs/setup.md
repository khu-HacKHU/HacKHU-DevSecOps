# 수업 전 준비

10/6은 이론 수업이라 준비물이 없다. **10/8 수업 전까지** 아래를 끝내고 온다. 설치가 안 되면 단톡방에 OS와 에러 메시지를 올린다.

## 1. 설치

| 도구 | 확인 명령 |
|---|---|
| Git | `git --version` (2.30 이상) |
| Node.js 22 LTS | `node -v` |
| GitHub CLI (`gh`) | `gh --version` |
| VS Code (권장) | |

**Windows**: Git for Windows를 설치하면 **Git Bash**가 같이 깔린다. 실습 명령은 Git Bash 기준이다.

## 2. Git 설정

```bash
git config --global user.name "홍길동"
git config --global user.email "GitHub에 등록한 이메일"
git config --global init.defaultBranch main
git config --global pull.rebase true      # pull 할 때 불필요한 merge 커밋을 만들지 않는다

# Windows만 — 줄바꿈 문자 자동 변환 끄기 (저장소의 .gitattributes가 LF로 맞춘다)
git config --global core.autocrlf false
```

이메일이 GitHub 계정에 등록된 것과 다르면 커밋이 내 계정에 연결되지 않는다. 이메일을 공개하기 싫다면 GitHub Settings → Emails의 `...@users.noreply.github.com` 주소를 쓴다.

## 3. GitHub 로그인

```bash
gh auth login     # GitHub.com → HTTPS → 브라우저로 로그인
gh auth status    # 로그인 확인
```

`khu-HacKHU` organization 초대를 수락했는지 확인한다. 수락하지 않으면 실습에서 브랜치를 push할 수 없다.

## 4. 저장소 받기

```bash
git clone https://github.com/khu-HacKHU/HacKHU-DevSecOps.git
cd HacKHU-DevSecOps
npm install
```

`npm install`은 커밋 메시지 검사 훅(husky + commitlint)을 설치한다. 아래 명령이 에러를 내면 설치된 것이다.

```bash
echo "잘못된 메시지" | npx --no -- commitlint
```

## 확인 체크리스트

- [ ] `git config user.email`이 GitHub 계정 이메일이다
- [ ] `gh auth status`가 로그인 상태다
- [ ] khu-HacKHU organization 초대를 수락했다
- [ ] 저장소를 clone하고 `npm install`을 했다
