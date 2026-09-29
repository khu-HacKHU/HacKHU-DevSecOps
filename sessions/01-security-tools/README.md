# 10/6 — DevSecOps의 Sec: 보안 도구와 HacKHU-HP에서의 역할

이론 수업에 진행자 시연 하나를 더했다. 참가자 준비물은 없다.

## 목표

수업이 끝나면 다음을 설명할 수 있다.

1. HacKHU-HP 개발 흐름에서 **어느 시점에 어떤 보안 도구가 도는지**
2. 각 도구가 **무엇을 잘 잡고 무엇을 못 잡는지**
3. 왜 gitleaks만 PR을 막고 나머지는 보고만 하는지
4. 도구 경고를 **진짜 취약점 / 오탐 / 위험 수용**으로 판별하는 방법
5. **도구가 못 잡는 취약점**이 무엇이고 HacKHU-HP에서 누가 찾는지

## 진행 (1시간)

| 시간 | 내용 | 자료 |
|---|---|---|
| 0:00 – 0:08 | DevSecOps란, HacKHU-HP 흐름 속 도구 위치, 용어 | [theory.md](theory.md) 1 ~ 3절 |
| 0:08 – 0:25 | 도구별 설명 — SAST, SCA, 시크릿, IaC, 컨테이너, DAST, 회귀 테스트 | 4절 |
| 0:25 – 0:35 | **시연: gitleaks가 PR을 막는다** | [demo.md](demo.md) |
| 0:35 – 0:43 | 차단 vs 보고, 결과 판별과 억제 | 5 ~ 6절 |
| 0:43 – 0:53 | 도구가 못 잡는 것, 보안 라운드 일정과 담당 | 7 ~ 8절 |
| 0:53 – 1:00 | 질문과 토론 | 9절 |

4절은 17분으로 빠듯하다. 2R·3R 도구(컨테이너, DAST, 회귀 테스트)는 한 줄씩만 소개하고, 1R 도구(SAST, SCA, 시크릿, IaC)에 시간을 쓴다.

## 복습

- HacKHU-HP [docs/security/tools.md](https://github.com/khu-HacKHU/HacKHU-HP/blob/develop/docs/security/tools.md) — 도구 설정과 판별 규칙의 원본
- HacKHU-HP [docs/security/secure-coding.md](https://github.com/khu-HacKHU/HacKHU-HP/blob/develop/docs/security/secure-coding.md) — S2 개발 전 필독
- HacKHU-HP [practice/juice-shop](https://github.com/khu-HacKHU/HacKHU-HP/tree/develop/practice/juice-shop) — 도구를 직접 돌려 보고 싶다면
