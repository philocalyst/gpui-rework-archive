#!/usr/bin/env bash
set -euo pipefail

DIR=$(cd "$(dirname "$0")" && pwd)
BASE=$(cd "$DIR/.." && pwd)
COMMON_FIXTURE="$BASE/fixtures/gpui-luna_bench.rs"

# Every value is intentionally mandatory: this runner never falls back to a
# mutable default binary, worktree, observer, display, or prior result path.
: "${LUNA_PAIR_ID:?set a unique capture directory name}"
: "${LUNA_DISPLAY:?set the reviewed persistent private display}"
: "${LUNA_BASELINE_BINARY:?set frozen 724 executable path}"
: "${LUNA_BASELINE_SHA:?set frozen 724 executable SHA-256}"
: "${LUNA_BASELINE_SOURCE_TREE:?set detached 724 reactivity worktree}"
: "${LUNA_BASELINE_MANIFEST:?set frozen 724 build manifest path}"
: "${LUNA_BASELINE_PREFLIGHT_RECORD:?set root-reviewed 724 preflight record}"
: "${LUNA_CURRENT_BINARY:?set frozen current executable path}"
: "${LUNA_CURRENT_SHA:?set frozen current executable SHA-256}"
: "${LUNA_CURRENT_SOURCE_TREE:?set detached current reactivity worktree}"
: "${LUNA_CURRENT_MANIFEST:?set current build manifest path}"
: "${LUNA_CURRENT_PREFLIGHT_RECORD:?set root-reviewed current preflight record}"
: "${LUNA_OBSERVER_BINARY:?set the reviewed observer executable path}"
: "${LUNA_OBSERVER_SHA:?set expected observer executable SHA-256}"

BASELINE_COMMIT=724ece73cb665a1f6d83e97ae7d431eee11a887a
CURRENT_COMMIT=dcdadf4d527cb669c13d9e99271bb1f956f95a1f
FIXTURE_SHA=a2c7b0a4992efa06719127cba59978aff62536d8d61994ca8c4c7dceb4f67c29
BASELINE_EXPECTED_SHA=795b54cc4c8feef2d39fb4f73e4fd6b7cf2799b45fadec192888564fb85b6a91
CURRENT_EXPECTED_SHA=9f26a0f112e1b34c67ad0ad57649037f5c135d776e05d77deaeeacc08b81785f
OBSERVER_EXPECTED_PATH=/tmp/gpui-bench-observer-target/release/luna-x11-observer
OBSERVER_EXPECTED_SHA=b4f84c80caa854d974643a2c20823537601a04745a7bcf320be356732b42f88b
[[ "$LUNA_DISPLAY" == :97 ]] || { echo 'capture requires the reviewed persistent private Xvfb :97' >&2; exit 2; }
[[ -S /tmp/.X11-unix/X97 ]] || { echo 'private Xvfb :97 is not running' >&2; exit 2; }
[[ "$LUNA_OBSERVER_BINARY" == "$OBSERVER_EXPECTED_PATH" ]] || {
  echo "observer path mismatch; run-one.sh uses $OBSERVER_EXPECTED_PATH" >&2; exit 2;
}
[[ "$LUNA_BASELINE_SHA" == "$BASELINE_EXPECTED_SHA" ]]
[[ "$LUNA_CURRENT_SHA" == "$CURRENT_EXPECTED_SHA" ]]
[[ "$LUNA_OBSERVER_SHA" == "$OBSERVER_EXPECTED_SHA" ]]
[[ "$LUNA_PAIR_ID" =~ ^[A-Za-z0-9][A-Za-z0-9._-]*$ ]] || {
  echo 'pair ID must be a simple filename component' >&2; exit 2;
}

has_line() {
  local file=$1 line=$2
  rg -Fxq "$line" "$file" || { echo "identity record missing '$line' in $file" >&2; return 1; }
}

verify_source() {
  local side=$1 tree=$2 commit=$3
  [[ $(git -C "$tree" rev-parse HEAD) == "$commit" ]] || {
    echo "$side source HEAD mismatch at $tree" >&2; return 1;
  }
  git -C "$tree" diff --quiet "$commit" -- Cargo.toml Cargo.lock crates/ vendor/ || {
    echo "$side compiled source tree is modified" >&2; return 1;
  }
  [[ -z $(git -C "$tree" ls-files --others --exclude-standard -- Cargo.toml Cargo.lock crates/ vendor/) ]] || {
    echo "$side compiled source tree has untracked non-ignored files" >&2; return 1;
  }
  [[ $(sha256sum "$tree/crates/gpui/examples/luna_bench.rs" | cut -d' ' -f1) == "$FIXTURE_SHA" ]] || {
    echo "$side injected fixture SHA mismatch" >&2; return 1;
  }
  cmp "$COMMON_FIXTURE" "$tree/crates/gpui/examples/luna_bench.rs"
}

verify_cell_identity() {
  local variant=$1 bin expected tree commit manifest preflight
  if [[ "$variant" == baseline ]]; then
    bin=$LUNA_BASELINE_BINARY expected=$BASELINE_EXPECTED_SHA
    tree=$LUNA_BASELINE_SOURCE_TREE commit=$BASELINE_COMMIT
    manifest=$LUNA_BASELINE_MANIFEST preflight=$LUNA_BASELINE_PREFLIGHT_RECORD
    has_line "$manifest" "gpui_source_commit=$BASELINE_COMMIT"
    has_line "$manifest" "gpui_binary=$LUNA_BASELINE_BINARY"
    has_line "$manifest" "gpui_binary_sha256=$expected"
    has_line "$manifest" "gpui_fixture_sha256=$FIXTURE_SHA"
    has_line "$manifest" "gpui_features=x11"
  else
    bin=$LUNA_CURRENT_BINARY expected=$CURRENT_EXPECTED_SHA
    tree=$LUNA_CURRENT_SOURCE_TREE commit=$CURRENT_COMMIT
    manifest=$LUNA_CURRENT_MANIFEST preflight=$LUNA_CURRENT_PREFLIGHT_RECORD
    has_line "$manifest" "source_commit=$CURRENT_COMMIT"
    has_line "$manifest" "binary=$LUNA_CURRENT_BINARY"
    has_line "$manifest" "binary_sha256=$expected"
    has_line "$manifest" "fixture_sha256=$FIXTURE_SHA"
    has_line "$manifest" 'features=x11 (includes accessibility)'
    has_line "$manifest" 'workspace_root=/root/gpui-current-main-bench/reactivity'
    has_line "$manifest" 'package_id=path+file:///root/gpui-current-main-bench/reactivity/crates/gpui#0.1.0'
  fi
  verify_source "$variant" "$tree" "$commit"
  [[ $(sha256sum "$bin" | cut -d' ' -f1) == "$expected" ]] || {
    echo "$variant executable SHA mismatch: $bin" >&2; return 1;
  }
  [[ -f "$preflight" ]] || { echo "$variant preflight record missing: $preflight" >&2; return 1; }
  has_line "$preflight" 'status=pass'
  has_line "$preflight" "gpui_source=$commit"
  has_line "$preflight" "gpui_binary_sha256=$expected"
  has_line "$preflight" "fixture_sha256=$FIXTURE_SHA"
  [[ $(sha256sum "$LUNA_OBSERVER_BINARY" | cut -d' ' -f1) == "$OBSERVER_EXPECTED_SHA" ]] || {
    echo 'observer executable SHA mismatch' >&2; return 1;
  }
}

[[ $(sha256sum "$COMMON_FIXTURE" | cut -d' ' -f1) == "$FIXTURE_SHA" ]]
[[ $(git -C "$BASE/../../../comparators/mygo" rev-parse HEAD) == ea23ad2975a87db9b20efe6690ffedf88f4fe4f3 ]]
[[ $(git -C "$BASE/../../../comparators/nanoui" rev-parse HEAD) == dfa7f7ab4e890f643703f4ffe4d834ff10defd4f ]]
OUT="$DIR/results/$LUNA_PAIR_ID"
[[ ! -e "$OUT" ]] || { echo "refusing to overwrite $OUT" >&2; exit 2; }
mkdir -p "$OUT"

source /tmp/gpui-native-env.sh
export DISPLAY=$LUNA_DISPLAY
export PROFILE=native-default APP=gpui
export LUNA_STARTS=${LUNA_STARTS:-100}
export LUNA_CLICKS_PER_START=${LUNA_CLICKS_PER_START:-10}
export LUNA_MEMORY_STARTS=${LUNA_MEMORY_STARTS:-5}
export LUNA_IDLE_MS=${LUNA_IDLE_MS:-750}
export LUNA_REQUIRE_BINARY_IDENTITY=1
unset LUNA_STAGES LUNA_PREFLIGHT LUNA_SCREENSHOT_PATH || true

if [[ "$LUNA_STARTS" != 100 || "$LUNA_CLICKS_PER_START" != 10 || "$LUNA_MEMORY_STARTS" != 5 || "$LUNA_IDLE_MS" != 750 ]]; then
  echo 'capture protocol is fixed at 100 starts, 10 clicks/start, 5 idle samples, 750 ms' >&2
  exit 2
fi

{
  echo "pair_id=$LUNA_PAIR_ID"
  echo "display=$LUNA_DISPLAY"
  echo "baseline_source=$BASELINE_COMMIT"
  echo "baseline_binary_sha256=$LUNA_BASELINE_SHA"
  echo "current_source=$CURRENT_COMMIT"
  echo "current_binary_sha256=$LUNA_CURRENT_SHA"
  echo "fixture_sha256=$FIXTURE_SHA"
  echo "observer_sha256=$LUNA_OBSERVER_SHA"
  echo 'profile=native-default; renderer_policy=Auto'
  echo "protocol=starts:$LUNA_STARTS,clicks_per_start:$LUNA_CLICKS_PER_START,idle_samples:$LUNA_MEMORY_STARTS,idle_ms:$LUNA_IDLE_MS"
  echo 'pairing=two 100-start observer batches per workload; alternating source order across workload blocks; not per-event paired samples'
  echo 'endpoint=Xvfb server drawable after damage/readback; no compositor/vblank/scanout claim'
  echo 'preflight_records_reviewed=true'
} > "$OUT/manifest.txt"

workloads=('eager 0' 'eager 1000' 'virtual 250000')
index=0
for workload in "${workloads[@]}"; do
  read -r mode rows <<< "$workload"
  if (( index % 2 == 0 )); then variants=(baseline current); else variants=(current baseline); fi
  for variant in "${variants[@]}"; do
    verify_cell_identity "$variant"
    bin=$LUNA_BASELINE_BINARY expected=$BASELINE_EXPECTED_SHA
    if [[ "$variant" == current ]]; then
      bin=$LUNA_CURRENT_BINARY expected=$CURRENT_EXPECTED_SHA
      export LUNA_GPUI_EXPECTED_SHA=$LUNA_CURRENT_SHA
    else
      export LUNA_GPUI_EXPECTED_SHA=$LUNA_BASELINE_SHA
    fi
    export LUNA_GPUI_BINARY=$bin LUNA_ROWS=$rows LUNA_MODE=$mode
    export APP=gpui MODE=$mode ROWS=$rows
    echo "RUN,$variant,$mode,$rows,$LUNA_STARTS,$LUNA_CLICKS_PER_START" | tee -a "$OUT/order.csv"
    "$BASE/run-one.sh" > "$OUT/$variant-$mode-$rows.raw" 2>&1
    echo "DONE,$variant,$mode,$rows" | tee -a "$OUT/order.csv"
  done
  index=$((index + 1))
done

(cd "$OUT" && sha256sum ./*.raw order.csv manifest.txt > sha256.txt)
echo "capture complete: $OUT"
