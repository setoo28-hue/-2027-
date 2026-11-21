#!/usr/bin/env bash
# 클라이짐 회원관리 웹앱 → GitHub Pages 배포 (저장소가 이미 존재할 때 실행)
# 사용: bash deploy-klygym-member/deploy.sh [owner] [repo]
set -euo pipefail

OWNER="${1:-setoo28-hue}"
REPO="${2:-klygym-member}"
DIR="$(cd "$(dirname "$0")" && pwd)"

echo "1) 저장소 확인: $OWNER/$REPO"
gh api "repos/$OWNER/$REPO" --jq '.full_name + " · " + .visibility' || {
  echo "!! 저장소가 없습니다. https://github.com/new 에서 $REPO (Public, README 미체크) 생성 후 다시 실행하세요."
  exit 1
}

cd "$DIR"
if ! git remote get-url origin >/dev/null 2>&1; then
  git remote add origin "https://github.com/$OWNER/$REPO.git"
fi
git branch -M main

echo "2) push"
git push -u origin main

echo "3) Pages 활성화 (이미 켜져 있으면 무시)"
gh api -X POST "repos/$OWNER/$REPO/pages" \
  -f "source[branch]=main" -f "source[path]=/" >/dev/null 2>&1 || \
gh api -X PUT "repos/$OWNER/$REPO/pages" \
  -f "source[branch]=main" -f "source[path]=/" >/dev/null 2>&1 || true
gh api "repos/$OWNER/$REPO/pages" --jq '.html_url + " (" + .status + ")"' || true

URL="https://$OWNER.github.io/$REPO/"
echo "4) 라이브 대기: $URL"
for i in $(seq 1 30); do
  code=$(curl -s -o /dev/null -w '%{http_code}' "$URL")
  echo "   [$i] HTTP $code"
  [ "$code" = "200" ] && { echo "LIVE: $URL"; exit 0; }
  sleep 10
done
echo "아직 200이 아닙니다. Pages 빌드 상태를 확인하세요."
exit 1
