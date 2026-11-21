# 클라이짐 · 스마트 회원관리

등촌·증미역 1:1 PT 센터 **클라이짐** 회원관리 웹앱 — 단일 `index.html`(상태 저장은 localStorage, 서버·DB 없음).

- 라이브: https://setoo28-hue.github.io/-2027-/
- 저장소: https://github.com/setoo28-hue/-2027-

## 지금 되는 것
- 회원 화면: 회차 진행률·오늘 운동(쇼츠 썸네일/링크)·트레이너 피드백·숙제 체크
- 수업 기록(트레이너): 회원·회차 입력, 운동/숙제 편집, **쇼츠 제목으로 고르기** 드롭다운(직접 ID 입력도 가능)
- 홈 화면 설치(PWA): `manifest.json` + `icon-192/512.png`, `apple-touch-icon-180.png`, `sw.js`(network-first, 오프라인은 캐시)

## 쇼츠 목록 (52개)
`index.html` 안의 `var SHORTS = [...]` 가 `@setoo28` = "클라이짐의 숏츠 근력 처방🔥" 채널의 실제 쇼츠 ID·제목입니다.
(`https://www.youtube.com/@setoo28/shorts` 목록 + 오래된 영상 4개)
새 쇼츠를 올렸을 때는 채널 숏츠 페이지에서 ID(`/shorts/<ID>`)와 제목을 확인해 이 배열에 한 줄 추가하면 드롭다운에 바로 나옵니다.
`{ id: "영상ID", label: "드롭다운에 보일 제목", cat: "하체·힙|가슴|등|어깨·목|유산소·기능성|임산부|동기·기타", name: "종목명(선택, 비어 있는 운동명 자동 채움)" }`

## 배포 메모
- GitHub Pages 소스: `gh-pages` 브랜치 / (root) — API 토큰에 pages 권한이 없어 `gh-pages` 푸시로 자동 활성화된 상태입니다.
- 수정 사항을 반영할 때는 `main`과 `gh-pages` 두 브랜치에 함께 푸시하세요:
  `git push origin main && git push origin main:gh-pages`
  (저장소 Settings → Pages → Branch를 `main / (root)`로 한 번 바꾸면 `main`만 푸시해도 됩니다.)
- PWA·JS를 고친 뒤에는 휴대폰에서 한 번 새로고침하면 반영됩니다(SW는 network-first라 온라인이면 항상 최신).

## 다음 단계 (DB)
트레이너 폰에서 입력한 기록이 회원 폰에 실시간으로 뜨려면 무료 DB(Supabase, `setoo28@naver.com`) 연결이 필요합니다.
프로젝트 생성 후 URL·anon key를 넣고, `state`를 localStorage 대신 테이블(`members`, `sessions` 등)에 저장하도록 바꾸면 됩니다.
