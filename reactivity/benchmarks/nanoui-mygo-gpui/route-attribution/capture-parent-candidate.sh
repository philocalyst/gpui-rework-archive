#!/usr/bin/env bash
set -euo pipefail

DIR=$(cd "$(dirname "$0")" && pwd)
BASE=$(cd "$DIR/.." && pwd)
: "${LUNA_PARENT_BINARY:?set the SHA-pinned parent executable path}"
: "${LUNA_PARENT_SHA:?set the expected parent executable SHA-256}"
: "${LUNA_CANDIDATE_BINARY:?set the SHA-pinned candidate executable path}"
: "${LUNA_CANDIDATE_SHA:?set the expected candidate executable SHA-256}"
: "${LUNA_CANDIDATE_COMMIT:?set the frozen integration commit SHA}"
: "${LUNA_FIXTURE_PREFLIGHT_RECORD:?set the reviewed common-fixture preflight record}"
: "${LUNA_PAIR_ID:?set a new unique campaign identifier}"
if [[ ! -f "$LUNA_FIXTURE_PREFLIGHT_RECORD" ]] || ! rg -q '^status=pass$' "$LUNA_FIXTURE_PREFLIGHT_RECORD"; then
  echo "common-fixture preflight record is absent or does not contain status=pass" >&2
  exit 1
fi
fixture_sha=$(sha256sum "$DIR/../fixtures/gpui-luna_bench.rs" | cut -d' ' -f1)
for line in \
  "fixture_sha256=$fixture_sha" \
  "parent_source=b60af3a4f97d67a35b4eab5a4ef672a17d9de6f6" \
  "parent_binary_sha256=$LUNA_PARENT_SHA" \
  "candidate_source=$LUNA_CANDIDATE_COMMIT" \
  "candidate_binary_sha256=$LUNA_CANDIDATE_SHA"; do
  if ! rg -Fxq "$line" "$LUNA_FIXTURE_PREFLIGHT_RECORD"; then
    echo "preflight record is for a different build or fixture: missing $line" >&2
    exit 1
  fi
done

for spec in "parent:$LUNA_PARENT_BINARY:$LUNA_PARENT_SHA" "candidate:$LUNA_CANDIDATE_BINARY:$LUNA_CANDIDATE_SHA"; do
  IFS=: read -r label binary expected <<< "$spec"
  actual=$(sha256sum "$binary" | cut -d' ' -f1)
  if [[ "$actual" != "$expected" ]]; then
    echo "$label binary SHA mismatch: expected $expected, got $actual" >&2
    exit 1
  fi
done

OUT="$DIR/results/$LUNA_PAIR_ID"
if [[ -e "$OUT" ]]; then
  echo "refusing to overwrite existing campaign directory: $OUT" >&2
  exit 1
fi
mkdir -p "$OUT"
printf 'SOURCE,parent,b60af3a4f97d67a35b4eab5a4ef672a17d9de6f6,%s\nSOURCE,candidate,%s,%s\n' \
  "$LUNA_PARENT_SHA" "$LUNA_CANDIDATE_COMMIT" "$LUNA_CANDIDATE_SHA" > "$OUT/order.csv"
source /tmp/gpui-native-env.sh
export DISPLAY=:94
export PROFILE=cpu-matched APP=gpui
export LUNA_STARTS=${LUNA_STARTS:-100}
export LUNA_CLICKS_PER_START=${LUNA_CLICKS_PER_START:-10}
export LUNA_MEMORY_STARTS=${LUNA_MEMORY_STARTS:-5}
export LUNA_IDLE_MS=${LUNA_IDLE_MS:-750}

# Alternate build order per workload to balance drift. Each observer instance
# keeps its X11 connection open across all starts inside that source/workload
# cell. This script is only for an explicitly coordinated quiet capture window.
index=0
workloads=('eager 0' 'eager 1000' 'virtual 250000')
if [[ -n "${LUNA_10K_PREFLIGHT_RECORD:-}" ]]; then
  if [[ ! -f "$LUNA_10K_PREFLIGHT_RECORD" ]] || ! rg -q '^status=pass$' "$LUNA_10K_PREFLIGHT_RECORD"; then
    echo "10k preflight record is absent or does not contain status=pass" >&2
    exit 1
  fi
  for line in \
    "fixture_sha256=$fixture_sha" \
    "parent_source=b60af3a4f97d67a35b4eab5a4ef672a17d9de6f6" \
    "parent_binary_sha256=$LUNA_PARENT_SHA" \
    "candidate_source=$LUNA_CANDIDATE_COMMIT" \
    "candidate_binary_sha256=$LUNA_CANDIDATE_SHA"; do
    if ! rg -Fxq "$line" "$LUNA_10K_PREFLIGHT_RECORD"; then
      echo "10k preflight record is for a different build or fixture: missing $line" >&2
      exit 1
    fi
  done
  workloads=('eager 0' 'eager 1000' 'eager 10000' 'virtual 250000')
fi
for workload in "${workloads[@]}"; do
  read -r mode rows <<< "$workload"
  if (( index % 2 == 0 )); then variants=(parent candidate); else variants=(candidate parent); fi
  for variant in "${variants[@]}"; do
    binary=$LUNA_PARENT_BINARY
    if [[ "$variant" == candidate ]]; then binary=$LUNA_CANDIDATE_BINARY; fi
    echo "RUN,$variant,$mode,$rows" | tee -a "$OUT/order.csv"
    LUNA_GPUI_BINARY="$binary" MODE="$mode" ROWS="$rows" \
      "$BASE/run-one.sh" > "$OUT/$variant-$mode-$rows.raw" 2>&1
    echo "DONE,$variant,$mode,$rows" | tee -a "$OUT/order.csv"
  done
  index=$((index + 1))
done
sha256sum "$OUT"/*.raw "$OUT/order.csv" > "$OUT/sha256.txt"
