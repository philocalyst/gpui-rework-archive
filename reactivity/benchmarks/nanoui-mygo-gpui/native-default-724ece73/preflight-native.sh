#!/usr/bin/env bash
set -euo pipefail

DIR=$(cd "$(dirname "$0")" && pwd)
BASE=$(cd "$DIR/.." && pwd)
REPO=$(cd "$BASE/../../.." && pwd)
: "${LUNA_DISPLAY:?set a private, reviewed Xvfb display; do not use :94}"
: "${LUNA_GPUI_BINARY:?set frozen current GPUI binary path}"
: "${LUNA_GPUI_SHA:?set expected current GPUI binary SHA-256}"
: "${LUNA_GPUI_SOURCE_TREE:?set detached GPUI source worktree}"
: "${LUNA_PREFLIGHT_ID:?set a unique preflight directory name}"

MYGO_BINARY=/tmp/gpui-luna-mygo-native
MYGO_SHA=e68767b866432dad27fc44e646217b60b1e5e60cb6e43fb2e80c8e41be4785df
NANOUI_BINARY=/tmp/gpui-luna-nanoui-output/bin/luna-bench
NANOUI_SHA=4cb7822c45a757f4d93ada2c0ab45fb2521cbdcb8397e8824e4cc0ef4d9d60a0
OUT="$DIR/preflights/$LUNA_PREFLIGHT_ID"
[[ ! -e "$OUT" ]] || { echo "refusing to overwrite $OUT" >&2; exit 2; }
mkdir -p "$OUT"

for spec in "gpui:$LUNA_GPUI_BINARY:$LUNA_GPUI_SHA" \
            "mygo:$MYGO_BINARY:$MYGO_SHA" \
            "nanoui:$NANOUI_BINARY:$NANOUI_SHA"; do
  IFS=: read -r label binary expected <<< "$spec"
  actual=$(sha256sum "$binary" | cut -d' ' -f1)
  [[ "$actual" == "$expected" ]] || {
    echo "$label binary SHA mismatch: expected $expected, got $actual" >&2
    exit 1
  }
done

[[ $(git -C "$REPO/comparators/mygo" rev-parse HEAD) == ea23ad2975a87db9b20efe6690ffedf88f4fe4f3 ]]
[[ $(git -C "$REPO/comparators/nanoui" rev-parse HEAD) == dfa7f7ab4e890f643703f4ffe4d834ff10defd4f ]]
[[ $(git -C "$LUNA_GPUI_SOURCE_TREE" rev-parse HEAD) == 724ece73cb665a1f6d83e97ae7d431eee11a887a ]]
cmp "$BASE/fixtures/gpui-luna_bench.rs" "$LUNA_GPUI_SOURCE_TREE/reactivity/crates/gpui/examples/luna_bench.rs"
cmp "$BASE/fixtures/mygo-main.go" "$REPO/comparators/mygo/examples/luna-bench/main.go"
cmp "$BASE/fixtures/nanoui-main.zig" "$REPO/comparators/nanoui/examples/luna-bench/main.zig"

source /tmp/gpui-native-env.sh
export DISPLAY=$LUNA_DISPLAY
export LUNA_STARTS=1 LUNA_CLICKS_PER_START=1 LUNA_MEMORY_STARTS=0 LUNA_PREFLIGHT=1
export PROFILE=native-default
export LD_LIBRARY_PATH=/nix/store/1fl4qsghsryd5f764m5v64vlxdz9d8qx-gtk+3-3.24.52/lib:/nix/store/c4q6wnp14xf0npalyiqsfp1c99y4qhcx-cairo-1.18.4/lib:${LD_LIBRARY_PATH:-}

for workload in 'eager 0' 'eager 1000' 'virtual 250000'; do
  read -r mode rows <<< "$workload"
  for app in gpui mygo nanoui; do
    case "$app" in
      gpui)
        binary=$LUNA_GPUI_BINARY
        export LUNA_RENDERER=auto
        unset LUNA_INTERPRETER LUNA_LIBRARY_PATH || true
        ;;
      mygo)
        binary=$MYGO_BINARY
        unset MYGO_GPU || true
        source "$BASE/prepare-runtime.sh"
        ;;
      nanoui)
        binary=$NANOUI_BINARY
        source "$BASE/prepare-runtime.sh"
        ;;
    esac
    export LUNA_ROWS=$rows LUNA_MODE=$mode LUNA_APP=$app
    export LUNA_SCREENSHOT_PATH="$OUT/$app-$mode-$rows.ppm"
    /tmp/gpui-bench-observer-target/release/luna-x11-observer \
      'Luna Benchmark' "$binary" >"$OUT/$app-$mode-$rows.log" 2>&1
  done
done

{
  echo "status=awaiting-manual-review"
  echo "display=$LUNA_DISPLAY (private Xvfb; no shared :94 input)"
  echo "workloads=eager-0,eager-1000,virtual-250000"
  echo "profile=native-default settings; observed runtime backend is in backend-probe.txt"
  echo "gpui_source=724ece73cb665a1f6d83e97ae7d431eee11a887a"
  echo "gpui_source_tree=$LUNA_GPUI_SOURCE_TREE"
  echo "gpui_binary_sha256=$LUNA_GPUI_SHA"
  echo "gpui_feature=x11 (AccessKit compiled; runtime AT-SPI status is in backend-probe.txt)"
  echo "mygo_source=ea23ad2975a87db9b20efe6690ffedf88f4fe4f3"
  echo "mygo_binary_sha256=$MYGO_SHA"
  echo "nanoui_source=dfa7f7ab4e890f643703f4ffe4d834ff10defd4f"
  echo "nanoui_binary_sha256=$NANOUI_SHA"
  echo "fixture_sha256=$(sha256sum "$BASE/fixtures/gpui-luna_bench.rs" | cut -d' ' -f1)"
  echo "checks=observer-preflight,800x600-client,exact-marker,button-and-row-ink,one-click-exact-marker-transition"
  echo "row_id_check=source-derived viewport expectation only; no OCR or app-internal row instrumentation"
  echo "preflight_click=one diagnostic click per app/workload; latency output is excluded from timed results"
  echo "renderer-font-AT-inequalities=GPUI Auto vs GTK vs Cairo; GPUI bundled Noto vs peers DejaVu; GPUI AccessKit compiled vs MyGo ATK vs NanoUI absent"
  echo "screenshots_and_logs=$OUT"
} > "$OUT/record.txt"
sha256sum "$OUT"/* > "$OUT/sha256.txt"
echo "preflight evidence at $OUT; inspect screenshots and logs before status=pass"
