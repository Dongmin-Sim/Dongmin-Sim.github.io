#!/usr/bin/env bash
#
# 블로그 로컬 미리보기 — 보기 방식을 한 단어로 선택.
#
#   ./preview.sh            # 기본: all (전체 + 실시간 반영)
#   ./preview.sh pub        # 발간된 글만 (실제 사이트와 동일)
#   ./preview.sh all        # 미발간·초안까지 전부
#   ./preview.sh ready      # stage: ready 인 글만 (홈 목록 기준)
#   ./preview.sh all 4001   # 포트 바꾸기 (기본 4000)
#
# 세 모드 모두 실시간 반영(--livereload) 켜짐 — 글을 저장하면 브라우저가 자동 새로고침.
# 멈추려면 이 창에서 Ctrl-C.
#
set -e

# rbenv 활성화 (비대화형 셸에서도 루비 3.2.6 을 쓰도록)
export PATH="$HOME/.rbenv/shims:$PATH"

# 스크립트 위치(블로그 저장소 루트)로 이동
cd "$(dirname "$0")"

MODE="${1:-all}"
PORT="${2:-4000}"
BASE=(bundle exec jekyll serve --livereload --host 127.0.0.1 --port "$PORT")

case "$MODE" in
  pub)
    echo "▶ 발간 미리보기 — published: true 만 (실제 사이트와 동일)"
    exec "${BASE[@]}"
    ;;
  all)
    echo "▶ 전체 미리보기 — 미발간·초안까지 전부"
    exec "${BASE[@]}" --unpublished --drafts
    ;;
  ready)
    echo "▶ ready 미리보기 — stage: ready 인 글만 (홈 목록 기준)"
    exec "${BASE[@]}" --unpublished --config _config.yml,_config_ready.yml
    ;;
  *)
    echo "알 수 없는 모드: '$MODE'"
    echo "사용법: ./preview.sh [pub|all|ready] [포트]"
    exit 1
    ;;
esac
