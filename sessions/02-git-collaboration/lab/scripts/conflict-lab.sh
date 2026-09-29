#!/usr/bin/env bash
# 충돌 실습용 로컬 저장소를 만든다. 원격이 필요 없고, 이 저장소 밖(~/hackhu-conflict-lab)에 만든다.
#
#   bash sessions/02-git-collaboration/lab/scripts/conflict-lab.sh          # 만들기
#   bash sessions/02-git-collaboration/lab/scripts/conflict-lab.sh --reset  # 지우고 다시 만들기

set -euo pipefail

lab_dir="${HACKHU_LAB_DIR:-$HOME/hackhu-conflict-lab}"
marker=".hackhu-conflict-lab"

if [ -e "$lab_dir" ]; then
  if [ "${1:-}" = "--reset" ] && [ -e "$lab_dir/$marker" ]; then
    rm -rf "$lab_dir"
  else
    echo "이미 있습니다: $lab_dir" >&2
    echo "다시 만들려면 --reset 을 붙여 실행하세요." >&2
    exit 1
  fi
fi

mkdir -p "$lab_dir"
cd "$lab_dir"
touch "$marker"

git init -q -b develop
git config user.name "HacKHU Lab"
git config user.email "lab@hackhu.invalid"
git config commit.gpgsign false
git config core.autocrlf false
printf '%s\n' "$marker" > .git/info/exclude

commit() {
  git add -A
  git commit -q -m "$1"
}

# --- 공통 시작점 ------------------------------------------------------------
cat > notice.md <<'EOF'
# 동아리 공지

- 정기 모임: 매주 화요일 19:00
- 장소: 전자정보대학관 245호
- 문의: 운영진 단톡방
EOF

cat > config.py <<'EOF'
PAGE_SIZE = 20
MAX_UPLOAD_MB = 10
ALLOWED_TYPES = ["image/png", "image/jpeg"]
EOF
commit "docs: 동아리 공지 추가"

# --- 시나리오 1: merge 충돌 -------------------------------------------------
# 내 브랜치와 develop이 같은 줄을 다르게 고쳤다.
git switch -q -c feat/1-meeting-time
sed -i.bak 's/매주 화요일 19:00/매주 목요일 19:00/' notice.md && rm -f notice.md.bak
commit "docs: 정기 모임 요일 변경"

git switch -q develop
sed -i.bak 's/매주 화요일 19:00/매주 화요일 18:30/' notice.md && rm -f notice.md.bak
sed -i.bak 's/운영진 단톡방/운영진 단톡방, 디스코드 #문의/' notice.md && rm -f notice.md.bak
commit "docs: 모임 시간 변경, 문의처 추가"

# --- 시나리오 2: rebase 충돌 ------------------------------------------------
# 내 브랜치 커밋 2개 중 하나가 develop의 변경과 부딪힌다.
git switch -q -c feat/2-upload-limit develop~1
sed -i.bak 's/MAX_UPLOAD_MB = 10/MAX_UPLOAD_MB = 20/' config.py && rm -f config.py.bak
commit "feat: 업로드 크기 제한 상향"
echo 'ALLOWED_TYPES.append("image/webp")' >> config.py
commit "feat: webp 업로드 허용"

git switch -q develop
sed -i.bak 's/MAX_UPLOAD_MB = 10/MAX_UPLOAD_MB = 5/' config.py && rm -f config.py.bak
commit "security: 업로드 크기 제한 축소"

git switch -q feat/1-meeting-time

cat <<EOF
충돌 실습 저장소를 만들었습니다: $lab_dir

  cd "$lab_dir"
  git log --oneline --graph --all

이어서 sessions/02-git-collaboration/lab/01-conflict.md 를 따라 합니다.
EOF
