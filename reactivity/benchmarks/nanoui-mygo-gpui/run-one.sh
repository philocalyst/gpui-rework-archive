#!/usr/bin/env bash
set -euo pipefail
DIR=$(cd "$(dirname "$0")" && pwd)
: "${APP:?set APP=gpui|mygo|nanoui}"
: "${ROWS:?set ROWS to 0, 1000, 10000, or 250000}"
: "${MODE:=eager}"
: "${PROFILE:=cpu-matched}"
source /tmp/gpui-native-env.sh
export DISPLAY=${LUNA_DISPLAY:-:94} LUNA_ROWS="$ROWS" LUNA_MODE="$MODE"
export LUNA_APP="$APP"
: "${LUNA_STARTS:=20}"; : "${LUNA_CLICKS_PER_START:=10}"; : "${LUNA_MEMORY_STARTS:=5}"; : "${LUNA_IDLE_MS:=750}"
export LUNA_STARTS LUNA_CLICKS_PER_START LUNA_MEMORY_STARTS LUNA_IDLE_MS
export LD_LIBRARY_PATH=/nix/store/1fl4qsghsryd5f764m5v64vlxdz9d8qx-gtk+3-3.24.52/lib:/nix/store/c4q6wnp14xf0npalyiqsfp1c99y4qhcx-cairo-1.18.4/lib:${LD_LIBRARY_PATH:-}
case "$APP" in
  gpui)
    unset LUNA_INTERPRETER LUNA_LIBRARY_PATH || true
    if [[ -n "${LUNA_GPUI_BINARY:-}" ]]; then
      BIN=$LUNA_GPUI_BINARY
      if [[ "$PROFILE" == "cpu-matched" ]]; then export LUNA_RENDERER=cpu; else export LUNA_RENDERER=auto; fi
    elif [[ "$PROFILE" == "cpu-matched" ]]; then export LUNA_RENDERER=cpu; BIN=/tmp/gpui-bench-gpui-cpu;
    else export LUNA_RENDERER=auto; BIN=/tmp/gpui-bench-gpui-x11; fi
    ;;
  mygo)
    BIN=${LUNA_MYGO_BINARY:-/tmp/luna-bench-mygo}
    if [[ "$PROFILE" == "cpu-matched" ]]; then export MYGO_GPU=0; else unset MYGO_GPU || true; fi
    if [[ -n "${LUNA_STAGES:-}" ]]; then export MYGO_FRAME_STATS=all; else unset MYGO_FRAME_STATS || true; fi
    ;;
  nanoui)
    BIN=${LUNA_NANOUI_BINARY:-/root/gpui-bench-luna/comparators/nanoui/zig-out/bin/luna-bench}
    ;;
  *) echo "unknown APP=$APP" >&2; exit 2 ;;
esac
if [[ "${LUNA_REQUIRE_BINARY_IDENTITY:-0}" == 1 ]]; then
  case "$APP" in
    gpui) expected=${LUNA_GPUI_EXPECTED_SHA:-} ;;
    mygo) expected=${LUNA_MYGO_EXPECTED_SHA:-} ;;
    nanoui) expected=${LUNA_NANOUI_EXPECTED_SHA:-} ;;
  esac
  [[ -n "$expected" ]] || { echo "missing expected binary SHA for $APP" >&2; exit 2; }
  actual=$(sha256sum "$BIN" | cut -d' ' -f1)
  [[ "$actual" == "$expected" ]] || {
    echo "$APP binary identity mismatch: expected $expected, got $actual at $BIN" >&2
    exit 1
  }
  echo "BINARY_IDENTITY,$APP,$BIN,$actual"
fi
if [[ "${LUNA_DRY_RUN:-0}" == 1 ]]; then
  exit 0
fi
if [[ "$APP" != gpui ]]; then
  source "$DIR/prepare-runtime.sh"
fi
export CARGO_TARGET_DIR=/tmp/gpui-bench-observer-target
exec /tmp/gpui-bench-observer-target/release/luna-x11-observer "Luna Benchmark" "$BIN"
