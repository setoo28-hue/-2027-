# 클라이짐 · 스마트 회원관리

등촌·증미역 1:1 PT 센터 **클라이짐** 회원관리 웹앱 — 단일 `index.html`.

- 라이브: https://setoo28-hue.github.io/-2027-/
- 저장소: https://github.com/setoo28-hue/-2027-

## 지금 되는 것
- **회원 화면(심플)**: 오늘 회차 진행률 · **오늘 운동 사진(최대 3장, 탭하면 크게 보기)** · 운동 목록 · 트레이너 피드백 · 숙제 체크 · 다음 수업 · 하단 **클라이짐 인스타/운동 쇼츠** 바로가기 · 상단 **BGM** 버튼 → 운동 BGM 플레이어
- **수업 기록(트레이너)**: 회원·회차, 사진 올리기, 운동(세트·무게·횟수), 피드백, 숙제(쇼츠 연결), 회원 링크
- 홈 화면 설치(PWA): `manifest.json` + `icon-192/512.png`, `apple-touch-icon-180.png`, `sw.js`(network-first, 오프라인은 캐시)

## 운동 BGM (17곡 · 36분)
- **공개 링크**: https://setoo28-hue.github.io/-2027-/?bgm=1 — 회원 코드 없이 누구나 열 수 있는 플레이어 화면(회원 기록·시안 데이터는 보이지 않음). 블로그·네이버·리틀리에 이 주소를 걸면 됩니다.
- **회원 화면**: 상단 `BGM` 버튼 → 아래에서 올라오는 플레이어(재생/일시정지, 이전·다음 곡, 셔플, 17곡 목록). 재생 중에는 버튼이 초록 이퀄라이저로 바뀝니다. 자동재생은 하지 않고, 누를 때만 시작합니다.
- **음원 위치**: `bgm/01_…mp3` ~ `bgm/17_…mp3` (원본 192kbps 그대로, 44.1/48kHz). 곡 순서·제목·BPM·길이는 `index.html`의 `var TRACKS = [...]` 한 곳에서 바꿉니다. 파일을 바꿀 때는 `f`(파일명), `t`(제목), `bpm`, `s`(장르), `d`(길이 초)를 함께 맞추세요.
  - ElevenMusic으로 만든 그루브/업비트 10곡(`downloads/elevenmusic-20261124/`) + Suno 캐럴 20곡 중 업비트 5곡(`03 크리스마스 이브 드라이브`, `04 징글 하우스`, `10 미드나잇 벨`, `12 미러볼 캐럴`, `18 화이트 아프로`).
  - 16·17번은 '해목' 채널 느낌의 **100 BPM 카페 재즈힙합 연주곡 `Cafe Bounce` 2버전**(각 1:00, 보컬 없음). ElevenMusic 프로젝트 `6IZgmh6hfSkY859Uplce`의 Variation 1·2를 MP3로 받아 넣었습니다.
- 섞어 듣기(셔플) 설정은 그 기기에 저장되고, 마지막 곡이 끝나면 첫 곡으로 이어집니다. 잠금 화면·이어폰 버튼은 Media Session으로 동작합니다.
- 서비스워커는 `/bgm/` 음원을 캐시하지 않습니다(브라우저 기본 캐시 사용).

## 사진 저장 방식
- 휴대폰에서 고른 사진(1~3장)은 **브라우저에서 긴 변 900px JPEG(품질 0.72)로 줄여** data URL로 만듭니다.
- DB에는 새 칼럼을 만들지 않고 **`exercises` jsonb 안에 `{ items: [...], photos: [...] }` 형태**로 함께 저장합니다(기존 `klygym_member_save` RPC 그대로 사용).
  - 사진이 없을 때는 예전처럼 `exercises` 가 배열로 저장됩니다. 읽을 때 두 형태를 모두 처리합니다.
- 그래서 Supabase 스키마 변경 없이 바로 동작합니다. 나중에 사진 전용 칼럼/스토리지로 옮길 때는 위 형태만 바꾸면 됩니다.

## 숙제 쇼츠 목록
`index.html` 안의 `var SHORTS = [...]` 가 `@setoo28` = "클라이짐의 숏츠 근력 처방🔥" 채널의 실제 쇼츠 ID·제목입니다.
새 쇼츠를 올렸을 때는 채널 숏츠 페이지에서 ID(`/shorts/<ID>`)와 제목을 확인해 이 배열에 한 줄 추가하면 숙제 쇼츠 선택에 바로 나옵니다.
`{ id: "영상ID", label: "보일 제목", cat: "하체·힙|가슴|등|어깨·목|유산소·기능성|임산부|동기·기타", name: "종목명(선택, 비어 있는 숙제명 자동 채움)" }`

## 배포 메모
- GitHub Pages 소스: `gh-pages` 브랜치 / (root) — API 토큰에 pages 권한이 없어 `gh-pages` 푸시로 자동 배포됩니다.
- 수정 사항을 반영할 때는 `main`과 `gh-pages` 두 브랜치에 함께 푸시하세요:
  `git push origin main && git push origin main:gh-pages`
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
- 스키마 원본: `work/klygym/supabase-schema.sql`

## 쓰는 법
- **트레이너(권성현 코치) 폰**: 앱을 열어 `수업 기록` → 사진·운동·피드백 입력 → `회원 화면에 반영` → `회원 링크` 카드의 **링크 복사**로 회원에게 카톡.
- **회원 폰**: 받은 링크(`.../?m=회원코드`)를 열면 수업 내용이 보이고, 숙제 체크가 트레이너 화면에 되돌아옵니다. 홈 화면에 추가하면 앱처럼 열립니다.
- 반영은 10초 주기 + 화면 복귀 시 자동 갱신입니다(즉시는 아님). 다른 회원 기록은 `회원 코드로 불러오기`로 엽니다.
- DB 비밀번호는 이 저장소에 없습니다(비공개 파일 보관).
