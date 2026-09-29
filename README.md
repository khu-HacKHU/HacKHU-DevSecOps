# HacKHU-DevSecOps

[HacKHU-HP](https://github.com/khu-HacKHU/HacKHU-HP) 프로젝트를 시작하기 전에 필요한 **보안 도구**와 **Git 협업**을 미리 익히는 교육·실습 저장소다.

HacKHU-HP는 동아리 홈페이지를 만들면서 보안 도구를 라운드별로 도입하고, 완성된 기능을 직접 공격·수정해 보는 프로젝트다. 여기서 배우는 도구와 규칙은 **HacKHU-HP에 실제로 걸려 있는 것과 같다.**

## 일정

| 날짜 | 주제 | 형식 | 자료 |
|---|---|---|---|
| 10/6 (화) | DevSecOps의 Sec — 보안 도구와 HacKHU-HP에서의 역할 | 이론 (1시간) | [sessions/01-security-tools](sessions/01-security-tools/) |
| 10/8 (목) | Git 사용법과 협업 방식 | 이론 + 실습 (1시간) | [sessions/02-git-collaboration](sessions/02-git-collaboration/) |

두 수업 모두 HacKHU-HP 스프린트 S1(9/28 ~ 10/11, 세팅과 설계) 안에 있다. S2부터 1R 보안 도구(SAST, SCA·시크릿, IaC)가 열리고 실제 개발이 시작된다.

## 구조

```text
sessions/
  01-security-tools/       10/6 보안 도구 이론
    theory.md              도구별 설명, HacKHU-HP에서의 역할
    demo.md                진행자 시연 — gitleaks가 PR을 막는다
  02-git-collaboration/    10/8 Git 협업 실습
    theory.md              Git 기본 모델, HacKHU-HP 협업 규칙
    lab/                   충돌 실습, PR 실습 + 복습용 사고 복구·release 흐름
    cheatsheet.md          자주 쓰는 명령 모음
participants/              10/8 첫 PR 실습에서 각자 파일을 추가하는 곳
docs/
  setup.md                 수업 전 설치할 것 (필독)
  instructor-guide.md      진행자용 — 저장소 설정, 시간표, 체크리스트
```

## 시작하기

10/8 수업 전에 [docs/setup.md](docs/setup.md)의 설치와 설정을 끝내고 온다. 10/6은 이론 수업이라 준비물이 없다.

```bash
git clone https://github.com/khu-HacKHU/HacKHU-DevSecOps.git
cd HacKHU-DevSecOps
npm install   # 커밋 메시지 검사 훅 설치 (10/8 실습에서 사용)
```

## HacKHU-HP 문서와의 관계

이 저장소는 교육용 요약과 실습을 담는다. **규칙의 원본은 HacKHU-HP에 있다.** 둘이 다르면 HacKHU-HP가 맞다.

| 주제 | 원본 |
|---|---|
| 커밋·브랜치·PR 규칙 | [HacKHU-HP/CONTRIBUTING.md](https://github.com/khu-HacKHU/HacKHU-HP/blob/develop/CONTRIBUTING.md) |
| 보안 도구 구성과 결과 판별 | [HacKHU-HP/docs/security/tools.md](https://github.com/khu-HacKHU/HacKHU-HP/blob/develop/docs/security/tools.md) |
| 시큐어 코딩 규칙 | [HacKHU-HP/docs/security/secure-coding.md](https://github.com/khu-HacKHU/HacKHU-HP/blob/develop/docs/security/secure-coding.md) |
| Juice Shop 실습 | [HacKHU-HP/practice/juice-shop](https://github.com/khu-HacKHU/HacKHU-HP/tree/develop/practice/juice-shop) |

이 저장소의 `commitlint.config.mjs`, `.github/scripts/`, `.github/workflows/lint-pr.yml`은 HacKHU-HP에서 그대로 가져왔다. HacKHU-HP 쪽이 바뀌면 같이 맞춘다.

## 주의

- 공개 저장소다. `participants/`에 전화번호, 학번 같은 개인정보를 쓰지 않는다.
- 실습 중에도 진짜 키·비밀번호는 쓰지 않는다.

PM: 강경현 (@kangkyunghyun) · PL: 손수민 (@sumin0218)
