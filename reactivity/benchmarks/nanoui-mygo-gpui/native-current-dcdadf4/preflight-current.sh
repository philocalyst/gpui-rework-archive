#!/usr/bin/env bash
set -euo pipefail

DIR=$(cd "$(dirname "$0")" && pwd)
BASE=$(cd "$DIR/.." && pwd)
REPO=$(cd "$BASE/../../.." && pwd)
: "${LUNA_DISPLAY:?set a private, reviewed Xvfb display; do not use :94}"
: "${LUNA_PREFLIGHT_ID:?set a unique preflight directory name}"
: "${LUNA_GPUI_SOURCE_TREE:?set detached current GPUI source worktree}"
: "${LUNA_GPUI_BINARY:?set frozen current GPUI binary path}"
: "${LUNA_GPUI_SHA:?set expected current GPUI binary SHA-256}"

GPUI_COMMIT=dcdadf4d527cb669c13d9e99271bb1f956f95a1f
GPUI_FIXTURE_SHA=a2c7b0a4992efa06719127cba59978aff62536d8d61994ca8c4c7dceb4f67c29
MYGO_BINARY=/tmp/gpui-luna-mygo-native
MYGO_SHA=e68767b866432dad27fc44e646217b60b1e5e60cb6e43fb2e80c8e41be4785df
NANOUI_BINARY=/tmp/gpui-luna-nanoui-output/bin/luna-bench
NANOUI_SHA=4cb7822c45a757f4d93ada2c0ab45fb2521cbdcb8397e8824e4cc0ef4d9d60a0
OUT="$DIR/preflights/$LUNA_PREFLIGHT_ID"
[[ ! -e "$OUT" ]] || { echo "refusing to overwrite $OUT" >&2; exit 2; }

[[ $(git -C "$LUNA_GPUI_SOURCE_TREE" rev-parse HEAD) == "$GPUI_COMMIT" ]]
git -C "$LUNA_GPUI_SOURCE_TREE" diff --quiet "$GPUI_COMMIT" -- crates/ vendor/ Cargo.toml Cargo.lock
[[ $(sha256sum "$LUNA_GPUI_SOURCE_TREE/crates/gpui/examples/luna_bench.rs" | cut -d' ' -f1) == "$GPUI_FIXTURE_SHA" ]]
cmp "$BASE/fixtures/gpui-luna_bench.rs" "$LUNA_GPUI_SOURCE_TREE/crates/gpui/examples/luna_bench.rs"
[[ $(git -C "$REPO/comparators/mygo" rev-parse HEAD) == ea23ad2975a87db9b20efe6690ffedf88f4fe4f3 ]]
[[ $(git -C "$REPO/comparators/nanoui" rev-parse HEAD) == dfa7f7ab4e890f643703f4ffe4d834ff10defd4f ]]
cmp "$BASE/fixtures/mygo-main.go" "$REPO/comparators/mygo/examples/luna-bench/main.go"
cmp "$BASE/fixtures/nanoui-main.zig" "$REPO/comparators/nanoui/examples/luna-bench/main.zig"

for spec in "gpui:$LUNA_GPUI_BINARY:$LUNA_GPUI_SHA" \
            "mygo:$MYGO_BINARY:$MYGO_SHA" \
            "nanoui:$NANOUI_BINARY:$NANOUI_SHA"; do
  IFS=: read -r label binary expected <<< "$spec"
  actual=$(sha256sum "$binary" | cut -d' ' -f1)
  [[ "$actual" == "$expected" ]] || {
    echo "$label binary SHA mismatch: expected $expected, got $actual at $binary" >&2
    exit 1
  }
done

mkdir -p "$OUT"
source /tmp/gpui-native-env.sh
export DISPLAY=$LUNA_DISPLAY
export LUNA_STARTS=1 LUNA_CLICKS_PER_START=1 LUNA_MEMORY_STARTS=0 LUNA_PREFLIGHT=1
export PROFILE=native-default
export LUNA_GPUI_BINARY LUNA_MYGO_BINARY=$MYGO_BINARY LUNA_NANOUI_BINARY=$NANOUI_BINARY
export LD_LIBRARY_PATH=/nix/store/1fl4qsghsryd5f764m5v64vlxdz9d8qx-gtk+3-3.24.52/lib:/nix/store/c4q6wnp14xf0npalyiqsfp1c99y4qhcx-cairo-1.18.4/lib:${LD_LIBRARY_PATH:-}

for workload in 'eager 0' 'eager 1000' 'virtual 250000'; do
  read -r mode rows <<< "$workload"
  export LUNA_ROWS=$rows LUNA_MODE=$mode
  for app in gpui mygo nanoui; do
    case "$app" in
      gpui)
        binary=$LUNA_GPUI_BINARY
        export LUNA_APP=gpui LUNA_RENDERER=auto
        export LUNA_REQUIRE_BINARY_IDENTITY=1 LUNA_GPUI_EXPECTED_SHA=$LUNA_GPUI_SHA
        unset LUNA_INTERPRETER LUNA_LIBRARY_PATH || true
        ;;
      mygo)
        binary=$MYGO_BINARY
        export LUNA_APP=mygo LUNA_REQUIRE_BINARY_IDENTITY=1 LUNA_MYGO_EXPECTED_SHA=$MYGO_SHA
        unset MYGO_GPU || true
        source "$BASE/prepare-runtime.sh"
        ;;
      nanoui)
        binary=$NANOUI_BINARY
        export LUNA_APP=nanoui LUNA_REQUIRE_BINARY_IDENTITY=1 LUNA_NANOUI_EXPECTED_SHA=$NANOUI_SHA
        source "$BASE/prepare-runtime.sh"
        ;;
    esac
    export APP=$app MODE=$mode ROWS=$rows
    export LUNA_SCREENSHOT_PATH="$OUT/$app-$mode-$rows.ppm"
    "$BASE/run-one.sh" >"$OUT/$app-$mode-$rows.log" 2>&1
  done
done

# A separate one-start probe records the backend actually chosen by Auto.
# Its startup marker is diagnostic only and never enters a timing capture.
export APP=gpui MODE=eager ROWS=0 LUNA_APP=gpui LUNA_RENDERER=auto
export LUNA_STARTS=1 LUNA_CLICKS_PER_START=0 LUNA_STAGES=1
export LUNA_SCREENSHOT_PATH="$OUT/gpui-backend-probe.ppm"
export LUNA_REQUIRE_BINARY_IDENTITY=1 LUNA_GPUI_EXPECTED_SHA=$LUNA_GPUI_SHA
"$BASE/run-one.sh" >"$OUT/backend-probe.log" 2>&1
busctl --user get-property org.a11y.Bus /org/a11y/bus org.a11y.Status IsEnabled \
  >"$OUT/at-session-probe.txt" 2>&1 || true

{
  echo 'status=awaiting-manual-review'
  echo "display=$LUNA_DISPLAY (private Xvfb; no shared :94 input)"
  echo 'workloads=eager-0,eager-1000,virtual-250000'
  echo 'profile=native-default; renderer policy Auto; selected backend recorded by backend-probe.log'
  echo "gpui_source=$GPUI_COMMIT"
  echo "gpui_source_tree=$LUNA_GPUI_SOURCE_TREE"
  echo "gpui_binary_sha256=$LUNA_GPUI_SHA"
  echo 'gpui_feature=x11 (AccessKit compiled; session-bus AT probe recorded separately)'
  echo 'mygo_source=ea23ad2975a87db9b20efe6690ffedf88f4fe4f3'
  echo "mygo_binary_sha256=$MYGO_SHA"
  echo 'nanoui_source=dfa7f7ab4e890f643703f4ffe4d834ff10defd4f'
  echo "nanoui_binary_sha256=$NANOUI_SHA"
  echo "fixture_sha256=$GPUI_FIXTURE_SHA"
  echo 'checks=observer-preflight,800x600-client,exact-marker,button-and-row-ink,one-click-exact-marker-transition'
  echo 'row_id_check=source-derived viewport expectation; no OCR or app-internal row instrumentation'
  echo 'preflight_click=one diagnostic click per app/workload; latency excluded from timed results'
  echo 'inequalities=GPUI Auto vs GTK/Cairo; GPUI Noto vs peer DejaVu; AccessKit compiled vs MyGo ATK vs NanoUI absent'
  echo "screenshots_and_logs=$OUT"
} > "$OUT/record.txt"
(cd "$OUT" && sha256sum ./* > sha256.txt)
echo "preflight evidence at $OUT; inspect all logs and images before status=pass"
