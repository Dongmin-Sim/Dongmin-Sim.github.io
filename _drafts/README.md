작업 중인 글(초안) 보관 폴더.

- 여기 글은 `stage: seed`(제목·개요·메모만) 또는 `stage: draft`(살은 있으나 미완).
- Jekyll 기본 빌드에서 제외 → 실수로 배포되지 않음. 날짜 없는 파일명 가능.
- 새 글은 보통 여기서 시작(예: 주제 하나 잡아 seed로). 다듬어 `ready`가 되면
  `_posts/YYYY-MM-DD-제목.md` 로 옮기고, 발간 시 `published: true`.

로컬 확인: `./preview.sh all` (초안·미발간 전부, 실시간 반영)

자세한 모델은 저장소 루트 `CLAUDE.md`의 "Post Maturity Model" 참조.
