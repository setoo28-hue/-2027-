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

## DB (Supabase, 실사용 연결됨)
- 프로젝트: `klygym-member` (조직 `setoo28@naver.com's Org`, 리전 Northeast Asia (Seoul))
- 프로젝트 URL: `https://dvjqfwdfpyytphclavkv.supabase.co`
- 사용 키: publishable key (`sb_publishable_...`, `index.html`의 `var SB` 안에 있음 — 공개돼도 되는 키)
- 테이블: `public.klygym_members` (회원 1명 = 1행, `member_code` 기본키, 운동·숙제는 jsonb)
- RLS: 켜짐 + 정책 없음 → anon은 테이블 직접 접근 불가. 아래 RPC(security definer)로만 한 행씩 읽고 씁니다.
  - `klygym_member_get(p_code)` — 회원 코드로 조회
  - `klygym_member_save(p_code, p_state jsonb)` — 트레이너 저장(업서트)
  - `klygym_homework_toggle(p_code, p_index, p_done)` — 회원 숙제 체크
- 스키마 원본: 이 폴더 밖 `work/klygym/supabase-schema.sql`

## 쓰는 법
- **트레이너(권성현 코치) 폰**: 앱을 열어 `수업 기록` → 회원 이름·운동·피드백 입력 → `회원 화면에 반영` → `회원 링크` 카드의 **링크 복사**로 회원에게 카톡.
- **회원 폰**: 받은 링크(`.../?m=회원코드`)를 열면 수업 내용이 보이고, 숙제 체크가 트레이너 화면에 되돌아옵니다. 홈 화면에 추가하면 앱처럼 열립니다.
- 반영은 10초 주기 + 화면 복귀 시 자동 갱신입니다(즉시는 아님). 다른 회원 기록은 `회원 코드로 불러오기`로 엽니다.
- DB 비밀번호는 이 저장소에 없습니다(비공개 파일 보관).
