#!/usr/bin/env bash
set -euo pipefail

DIR=$(cd "$(dirname "$0")" && pwd)
BASE=$(cd "$DIR/.." && pwd)
ROOT=$(git -C "$BASE" rev-parse --show-toplevel)
COMMON_FIXTURE="$BASE/fixtures/gpui-luna_bench.rs"
MYGO_FIXTURE="$BASE/fixtures/mygo-main.go"
NANO_FIXTURE="$BASE/fixtures/nanoui-main.zig"
PEER_RECORD="$DIR/preflight-private109/record.txt"

# Current GPUI values are intentionally supplied only after its integrated
# source/build/preflight is frozen. Peers are rebuilt from the recorded pins.
: "${LUNA_PAIR_ID:?set a unique capture directory name}"
: "${LUNA_DISPLAY:?set the reviewed persistent private Xvfb display}"
: "${LUNA_GPUI_SOURCE_TREE:?set detached current nested reactivity worktree}"
: "${LUNA_GPUI_SOURCE_COMMIT:?set frozen current cleanroom source commit}"
: "${LUNA_GPUI_BINARY:?set frozen current GPUI executable path}"
: "${LUNA_GPUI_SHA:?set frozen current GPUI binary SHA-256}"
: "${LUNA_GPUI_MANIFEST:?set current build manifest}"
: "${LUNA_GPUI_PREFLIGHT:?set root-reviewed current screenshot/geometry preflight record}"
: "${LUNA_MYGO_SOURCE_TREE:?set detached pinned MyGo worktree with fixture injected}"
: "${LUNA_MYGO_BINARY:?set pinned MyGo executable path}"
: "${LUNA_MYGO_SHA:?set pinned MyGo binary SHA-256}"
: "${LUNA_NANOUI_SOURCE_TREE:?set detached pinned NanoUI worktree with fixture injected}"
: "${LUNA_NANOUI_BINARY:?set pinned NanoUI executable path}"
: "${LUNA_NANOUI_SHA:?set pinned NanoUI binary SHA-256}"
: "${LUNA_OBSERVER_BINARY:?set reviewed X11 observer executable path}"
: "${LUNA_OBSERVER_SHA:?set reviewed X11 observer SHA-256}"
: "${LUNA_OUTPUT_ID:?set output child directory name}"

GPUI_FIXTURE_SHA=a2c7b0a4992efa06719127cba59978aff62536d8d61994ca8c4c7dceb4f67c29
MYGO_COMMIT=ea23ad2975a87db9b20efe6690ffedf88f4fe4f3
MYGO_FIXTURE_SHA=d05239655152b3354bacededa984d4f2ad8c4e1519ef30940e7f19cc55d7150b
NANOUI_COMMIT=dfa7f7ab4e890f643703f4ffe4d834ff10defd4f
NANOUI_FIXTURE_SHA=46061d578913885f42ca2e38bce6ad6714f47de70a36608bbeb673d9e822df1c
NANOUI_PATCH_SHA=c698367086a8d17feeceae6f99d0abda2fce273f35c3e4f8f0e0a32fab586224
FONT_SHA=58568c88a01b80dfc056daca3eeafd434a0380df1a48dda53f0de0d716109bbd
OBSERVER_EXPECTED_SHA=b4f84c80caa854d974643a2c20823537601a04745a7bcf320be356732b42f88b
[[ "$LUNA_OBSERVER_SHA" == "$OBSERVER_EXPECTED_SHA" ]]
[[ "$LUNA_PAIR_ID" =~ ^[A-Za-z0-9][A-Za-z0-9._-]*$ ]]
[[ "$LUNA_OUTPUT_ID" =~ ^[A-Za-z0-9][A-Za-z0-9._-]*$ ]]
[[ -S "/tmp/.X11-unix/X${LUNA_DISPLAY#:}" ]] || {
  echo "private X server $LUNA_DISPLAY is not running" >&2; exit 2;
}

hash_is() {
  local file=$1 expected=$2 actual
  actual=$(sha256sum "$file" | cut -d' ' -f1)
  [[ "$actual" == "$expected" ]] || {
    echo "SHA mismatch for $file: expected $expected, got $actual" >&2; return 1;
  }
}
has_line() {
  rg -Fxq "$2" "$1" || { echo "missing '$2' in $1" >&2; return 1; }
}
only_untracked_fixture() {
  local tree=$1 allowed=$2 item
  while IFS= read -r item; do
    [[ -z "$item" ]] && continue
    [[ "$item" == "$allowed" ]] || {
      echo "unexpected untracked source input in $tree: $item" >&2; return 1;
    }
  done < <(git -C "$tree" ls-files --others --exclude-standard)
}

verify_gpui() {
  local tree=$LUNA_GPUI_SOURCE_TREE top
  top=$(git -C "$tree" rev-parse --show-toplevel)
  [[ "$tree" == "$top/reactivity" ]] || { echo "GPUI source must be nested reactivity workspace: $tree" >&2; return 1; }
  [[ $(git -C "$tree" rev-parse HEAD) == "$LUNA_GPUI_SOURCE_COMMIT" ]] || { echo 'GPUI source pin mismatch' >&2; return 1; }
  git -C "$top" diff --quiet "$LUNA_GPUI_SOURCE_COMMIT" -- .cargo/ reactivity/.cargo/ rust-toolchain rust-toolchain.toml rust-toolchain.yaml reactivity/rust-toolchain reactivity/rust-toolchain.toml reactivity/rust-toolchain.yaml reactivity/Cargo.toml reactivity/Cargo.lock reactivity/crates/ reactivity/vendor/ || {
    echo 'GPUI compiled source/config tree differs from its commit' >&2; return 1;
  }
  only_untracked_fixture "$top" reactivity/crates/gpui/examples/luna_bench.rs
  hash_is "$tree/crates/gpui/examples/luna_bench.rs" "$GPUI_FIXTURE_SHA"
  cmp "$COMMON_FIXTURE" "$tree/crates/gpui/examples/luna_bench.rs"
  hash_is "$LUNA_GPUI_BINARY" "$LUNA_GPUI_SHA"
  has_line "$LUNA_GPUI_MANIFEST" "source_commit=$LUNA_GPUI_SOURCE_COMMIT"
  has_line "$LUNA_GPUI_MANIFEST" "binary=$LUNA_GPUI_BINARY"
  has_line "$LUNA_GPUI_MANIFEST" "binary_sha256=$LUNA_GPUI_SHA"
  has_line "$LUNA_GPUI_MANIFEST" "fixture_sha256=$GPUI_FIXTURE_SHA"
  has_line "$LUNA_GPUI_PREFLIGHT" 'status=pass'
  has_line "$LUNA_GPUI_PREFLIGHT" "source=$LUNA_GPUI_SOURCE_COMMIT"
  has_line "$LUNA_GPUI_PREFLIGHT" "binary_sha256=$LUNA_GPUI_SHA"
  has_line "$LUNA_GPUI_PREFLIGHT" "fixture_sha256=$GPUI_FIXTURE_SHA"
}

verify_mygo() {
  local tree=$LUNA_MYGO_SOURCE_TREE
  [[ $(git -C "$tree" rev-parse HEAD) == "$MYGO_COMMIT" ]] || { echo 'MyGo source pin mismatch' >&2; return 1; }
  git -C "$tree" diff --quiet "$MYGO_COMMIT" -- . || { echo 'MyGo tracked source differs from pin' >&2; return 1; }
  only_untracked_fixture "$tree" examples/luna-bench/main.go
  hash_is "$tree/examples/luna-bench/main.go" "$MYGO_FIXTURE_SHA"
  cmp "$MYGO_FIXTURE" "$tree/examples/luna-bench/main.go"
  hash_is "$LUNA_MYGO_BINARY" "$LUNA_MYGO_SHA"
  hash_is "$LUNA_MYGO_BINARY" e68767b866432dad27fc44e646217b60b1e5e60cb6e43fb2e80c8e41be4785df
  has_line "$PEER_RECORD" 'status=pass'
  has_line "$DIR/build-manifest.txt" "mygo_binary_sha256=$LUNA_MYGO_SHA"
}

verify_nanoui() {
  local tree=$LUNA_NANOUI_SOURCE_TREE diff_hash
  [[ $(git -C "$tree" rev-parse HEAD) == "$NANOUI_COMMIT" ]] || { echo 'NanoUI source pin mismatch' >&2; return 1; }
  [[ $(git -C "$tree" diff --name-only "$NANOUI_COMMIT") == build.zig ]] || {
    echo 'NanoUI tracked changes must be exactly the reviewed build.zig example filter' >&2; return 1;
  }
  diff_hash=$(git -C "$tree" diff --binary "$NANOUI_COMMIT" -- build.zig | sha256sum | cut -d' ' -f1)
  [[ "$diff_hash" == "$NANOUI_PATCH_SHA" ]] || { echo 'NanoUI build.zig patch SHA mismatch' >&2; return 1; }
  only_untracked_fixture "$tree" examples/luna-bench/main.zig
  hash_is "$tree/examples/luna-bench/main.zig" "$NANOUI_FIXTURE_SHA"
  cmp "$NANOUI_FIXTURE" "$tree/examples/luna-bench/main.zig"
  hash_is "$LUNA_NANOUI_BINARY" "$LUNA_NANOUI_SHA"
  has_line "$PEER_RECORD" 'status=pass'
  has_line "$DIR/build-manifest.txt" "nanoui_binary_sha256=$LUNA_NANOUI_SHA"
  hash_is /root/.local/share/fonts/luna-bench/DejaVuSans.ttf "$FONT_SHA"
}

verify_observer() {
  hash_is "$LUNA_OBSERVER_BINARY" "$OBSERVER_EXPECTED_SHA"
  hash_is "$DIR/../src/main.rs" 9b967168df1e38b6a83b828b1dff2099f47373bf89cbe299bfa58bf240dd64bd
}

verify_all() {
  verify_gpui
  verify_mygo
  verify_nanoui
  verify_observer
}

workloads=('eager 0' 'eager 1000' 'virtual 250000')
for workload in "${workloads[@]}"; do
  read -r mode rows <<< "$workload"
  verify_all
  echo "GUARD_PASS,all,$mode,$rows"
done

if [[ "${LUNA_GUARD_ONLY:-0}" == 1 ]]; then
  echo 'GUARD_ONLY_PASS,all nine cells validated; no output directory or observer launched'
  exit 0
fi
[[ "${LUNA_START_CAPTURE:-0}" == 1 ]] || {
  echo 'timed capture requires explicit LUNA_START_CAPTURE=1 after coordinated quiet release' >&2
  exit 2
}
[[ ! -e "$DIR/results/$LUNA_OUTPUT_ID" ]] || { echo 'refusing to overwrite existing campaign output' >&2; exit 2; }

source /tmp/gpui-native-env.sh
export DISPLAY=$LUNA_DISPLAY
export PROFILE=native-default
export LUNA_STARTS=${LUNA_STARTS:-100}
export LUNA_CLICKS_PER_START=${LUNA_CLICKS_PER_START:-10}
export LUNA_MEMORY_STARTS=${LUNA_MEMORY_STARTS:-5}
export LUNA_IDLE_MS=${LUNA_IDLE_MS:-750}
[[ "$LUNA_STARTS" == 100 && "$LUNA_CLICKS_PER_START" == 10 && "$LUNA_MEMORY_STARTS" == 5 && "$LUNA_IDLE_MS" == 750 ]] || {
  echo 'capture protocol is fixed at 100 starts, 10 clicks/start, five idle samples at 750ms' >&2; exit 2;
}
export LUNA_REQUIRE_BINARY_IDENTITY=1
unset LUNA_PREFLIGHT LUNA_SCREENSHOT_PATH LUNA_STAGES || true
OUT="$DIR/results/$LUNA_OUTPUT_ID"
mkdir -p "$OUT"
{
  echo "campaign=$LUNA_PAIR_ID"
  echo "display=$LUNA_DISPLAY"
  echo "gpui_source=$LUNA_GPUI_SOURCE_COMMIT"
  echo "gpui_binary=$LUNA_GPUI_SHA"
  echo "mygo_source=$MYGO_COMMIT"
  echo "mygo_binary=$LUNA_MYGO_SHA"
  echo "nanoui_source=$NANOUI_COMMIT"
  echo "nanoui_binary=$LUNA_NANOUI_SHA"
  echo "fixture_gpui=$GPUI_FIXTURE_SHA"
  echo "fixture_mygo=$MYGO_FIXTURE_SHA"
  echo "fixture_nanoui=$NANOUI_FIXTURE_SHA"
  echo "nanoui_build_filter_patch=$NANOUI_PATCH_SHA"
  echo "observer=$OBSERVER_EXPECTED_SHA"
  echo 'endpoint=Xvfb server drawable after Damage notification and exact pixel readback; no compositor/vblank/scanout claim'
  echo "protocol=starts:$LUNA_STARTS,clicks_per_start:$LUNA_CLICKS_PER_START,idle_samples:$LUNA_MEMORY_STARTS,idle_ms:$LUNA_IDLE_MS"
  echo 'pairing=workload-blocked; app order rotates by workload; no per-start paired statistical claim'
  echo 'profile=native-default; app-specific renderers/fonts/AT capability are in README'
} > "$OUT/manifest.txt"

for workload_index in 0 1 2; do
  read -r mode rows <<< "${workloads[$workload_index]}"
  case $workload_index in
    0) apps=(gpui mygo nanoui) ;;
    1) apps=(mygo nanoui gpui) ;;
    2) apps=(nanoui gpui mygo) ;;
  esac
  for app in "${apps[@]}"; do
    verify_all
    case "$app" in
      gpui)
        export LUNA_GPUI_BINARY LUNA_GPUI_EXPECTED_SHA=$LUNA_GPUI_SHA
        ;;
      mygo)
        export LUNA_MYGO_BINARY LUNA_MYGO_EXPECTED_SHA=$LUNA_MYGO_SHA
        ;;
      nanoui)
        export LUNA_NANOUI_BINARY LUNA_NANOUI_EXPECTED_SHA=$LUNA_NANOUI_SHA
        ;;
    esac
    export APP="$app" ROWS="$rows" MODE="$mode" LUNA_APP="$app" LUNA_ROWS="$rows" LUNA_MODE="$mode"
    echo "RUN,$app,$mode,$rows" | tee -a "$OUT/order.csv"
    "$BASE/run-one.sh" > "$OUT/$app-$mode-$rows.raw" 2>&1
    echo "DONE,$app,$mode,$rows" | tee -a "$OUT/order.csv"
  done
done
(cd "$OUT" && sha256sum ./*.raw order.csv manifest.txt > sha256.txt)
echo "capture complete: $OUT"
