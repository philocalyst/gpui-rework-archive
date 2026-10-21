#!/usr/bin/env bash
set -euo pipefail

DIR=$(cd "$(dirname "$0")" && pwd)
BASE=$(cd "$DIR/.." && pwd)
REPO=$(cd "$BASE/../../.." && pwd)
: "${LUNA_GPUI_BINARY:?set the frozen integrated GPUI executable path}"
: "${LUNA_GPUI_SHA:?set the expected GPUI executable SHA-256}"
: "${LUNA_GPUI_COMMIT:?set the frozen integrated GPUI commit SHA}"
: "${LUNA_FIXTURE_PREFLIGHT_RECORD:?set the reviewed common-fixture preflight record}"
: "${LUNA_PEER_ID:?set a new unique campaign identifier}"
MYGO_BINARY=/tmp/luna-bench-mygo
MYGO_SHA=e68767b866432dad27fc44e646217b60b1e5e60cb6e43fb2e80c8e41be4785df
NANOUI_BINARY="$REPO/comparators/nanoui/zig-out/bin/luna-bench"
NANOUI_SHA=b2d9c6f4ce2745a1e8d9b68c07f831ab2f7756eb349ed14a2c50891403f513a8
if [[ ! -f "$LUNA_FIXTURE_PREFLIGHT_RECORD" ]] || ! rg -q '^status=pass$' "$LUNA_FIXTURE_PREFLIGHT_RECORD"; then
  echo "common-fixture preflight record is absent or does not contain status=pass" >&2
  exit 1
fi
fixture_sha=$(sha256sum "$DIR/../fixtures/gpui-luna_bench.rs" | cut -d' ' -f1)
for line in \
  "fixture_sha256=$fixture_sha" \
  "candidate_source=$LUNA_GPUI_COMMIT" \
  "candidate_binary_sha256=$LUNA_GPUI_SHA" \
  "mygo_source=ea23ad2975a87db9b20efe6690ffedf88f4fe4f3" \
  "mygo_binary_sha256=$MYGO_SHA" \
  "nanoui_source=dfa7f7ab4e890f643703f4ffe4d834ff10defd4f" \
  "nanoui_binary_sha256=$NANOUI_SHA"; do
  if ! rg -Fxq "$line" "$LUNA_FIXTURE_PREFLIGHT_RECORD"; then
    echo "preflight record is for a different build or fixture: missing $line" >&2
    exit 1
  fi
done
actual=$(sha256sum "$LUNA_GPUI_BINARY" | cut -d' ' -f1)
if [[ "$actual" != "$LUNA_GPUI_SHA" ]]; then
  echo "GPUI binary SHA mismatch: expected $LUNA_GPUI_SHA, got $actual" >&2
  exit 1
fi
if [[ $(git -C "$REPO/comparators/mygo" rev-parse HEAD) != ea23ad2975a87db9b20efe6690ffedf88f4fe4f3 || \
      $(git -C "$REPO/comparators/nanoui" rev-parse HEAD) != dfa7f7ab4e890f643703f4ffe4d834ff10defd4f ]]; then
  echo "peer source checkout does not match the documented pins" >&2
  exit 1
fi
if [[ $(sha256sum "$MYGO_BINARY" | cut -d' ' -f1) != "$MYGO_SHA" || \
      $(sha256sum "$NANOUI_BINARY" | cut -d' ' -f1) != "$NANOUI_SHA" ]]; then
  echo "peer executable SHA does not match the reviewed baseline manifest" >&2
  exit 1
fi

OUT="$DIR/results/$LUNA_PEER_ID"
if [[ -e "$OUT" ]]; then
  echo "refusing to overwrite existing campaign directory: $OUT" >&2
  exit 1
fi
mkdir -p "$OUT"
{
  echo "SOURCE,gpui,$LUNA_GPUI_COMMIT,$LUNA_GPUI_SHA"
  echo "SOURCE,mygo,ea23ad2975a87db9b20efe6690ffedf88f4fe4f3,$MYGO_SHA"
  echo "SOURCE,nanoui,dfa7f7ab4e890f643703f4ffe4d834ff10defd4f,$NANOUI_SHA"
} > "$OUT/order.csv"
source /tmp/gpui-native-env.sh
export DISPLAY=:94
export PROFILE=cpu-matched
export LUNA_STARTS=${LUNA_STARTS:-100}
export LUNA_CLICKS_PER_START=${LUNA_CLICKS_PER_START:-10}
export LUNA_MEMORY_STARTS=${LUNA_MEMORY_STARTS:-5}
export LUNA_IDLE_MS=${LUNA_IDLE_MS:-750}

# This is the separate integrated-GPUI-versus-pinned-peers lane. The peers'
# binaries and sources remain those recorded by the existing SHA manifests.
index=0
workloads=('eager 0' 'eager 1000' 'virtual 250000')
if [[ -n "${LUNA_10K_PREFLIGHT_RECORD:-}" ]]; then
  if [[ ! -f "$LUNA_10K_PREFLIGHT_RECORD" ]] || ! rg -q '^status=pass$' "$LUNA_10K_PREFLIGHT_RECORD"; then
    echo "10k preflight record is absent or does not contain status=pass" >&2
    exit 1
  fi
  for line in \
    "fixture_sha256=$fixture_sha" \
    "candidate_source=$LUNA_GPUI_COMMIT" \
    "candidate_binary_sha256=$LUNA_GPUI_SHA" \
    "mygo_source=ea23ad2975a87db9b20efe6690ffedf88f4fe4f3" \
    "mygo_binary_sha256=$MYGO_SHA" \
    "nanoui_source=dfa7f7ab4e890f643703f4ffe4d834ff10defd4f" \
    "nanoui_binary_sha256=$NANOUI_SHA"; do
    if ! rg -Fxq "$line" "$LUNA_10K_PREFLIGHT_RECORD"; then
      echo "10k preflight record is for a different build or fixture: missing $line" >&2
      exit 1
    fi
  done
  workloads=('eager 0' 'eager 1000' 'eager 10000' 'virtual 250000')
fi
for workload in "${workloads[@]}"; do
  read -r mode rows <<< "$workload"
  case $((index % 3)) in
    0) apps=(gpui mygo nanoui) ;;
    1) apps=(mygo nanoui gpui) ;;
    2) apps=(nanoui gpui mygo) ;;
  esac
  for app in "${apps[@]}"; do
    echo "RUN,$app,$mode,$rows" | tee -a "$OUT/order.csv"
    if [[ "$app" == gpui ]]; then export LUNA_GPUI_BINARY; fi
    APP="$app" MODE="$mode" ROWS="$rows" \
      "$BASE/run-one.sh" > "$OUT/$app-$mode-$rows.raw" 2>&1
    echo "DONE,$app,$mode,$rows" | tee -a "$OUT/order.csv"
  done
  index=$((index + 1))
done
sha256sum "$OUT"/*.raw "$OUT/order.csv" > "$OUT/sha256.txt"
