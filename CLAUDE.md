# HacKHU-DevSecOps

[HacKHU-HP](https://github.com/khu-HacKHU/HacKHU-HP) 프로젝트 전 교육 자료 저장소. 10/6 보안 도구, 10/8 Git 협업 수업의 이론·실습을 담는다. 진입점은 [README.md](README.md).

## 규칙

- 커밋·브랜치·PR 규칙은 HacKHU-HP [CONTRIBUTING.md](https://github.com/khu-HacKHU/HacKHU-HP/blob/develop/CONTRIBUTING.md)와 같다. 제목은 `type: 한글 설명`, scope·이슈 번호 없음.
- 규칙·도구 설명의 원본은 HacKHU-HP 문서다. 교육 자료가 HacKHU-HP와 다른 말을 하면 안 된다. HacKHU-HP 규칙이 바뀌면 이 저장소의 `theory.md`, `commitlint.config.mjs`, `.github/scripts/`를 같이 맞춘다.
- `.github/scripts/`, `commitlint.config.mjs`, `.github/workflows/lint-pr.yml`은 HacKHU-HP에서 그대로 가져온 것이다. 여기서만 고치지 않는다.

## 수업 분량

- 두 수업 모두 1시간이다. 각 세션 `README.md`의 진행표가 기준이고, 내용을 추가하면 진행표 시간도 같이 맞춘다.
- 10/6은 이론 중심 수업이다. 참가자 실습은 없고 진행자 시연(`sessions/01-security-tools/demo.md`) 하나만 둔다.
- 10/8에서 1시간에 들어가지 않는 실습은 "수업 후 복습"으로 둔다.

## 문서 작성

- 한국어, 평서체(`~한다`). 기존 문서의 표·코드 블록 스타일을 따른다.
- 명령어는 Git Bash 기준. Windows PowerShell 차이는 필요한 곳에만 적는다.
- 참가자가 공개 저장소에 쓰는 파일(`participants/`)에 개인정보를 요구하지 않는다.
