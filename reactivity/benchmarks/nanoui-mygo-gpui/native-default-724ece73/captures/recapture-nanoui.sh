#!/usr/bin/env bash
set -euo pipefail
HERE=$(cd "$(dirname "$0")" && pwd)
BASE=$(cd "$HERE/../.." && pwd)
RUN_ONE="$BASE/run-one.sh"
MANIFEST="$BASE/native-default-724ece73/build-manifest.txt"
OUT_ID=${1:?usage: recapture-nanoui.sh UNIQUE_CAPTURE_ID}
OUT="$HERE/$OUT_ID"
[[ ! -e "$OUT" ]] || { echo "refusing to overwrite $OUT" >&2; exit 2; }
mkdir -p "$OUT"
get() { awk -F= -v k="$1" '$1 == k { sub(/^[^=]*=/, ""); print; exit }' "$MANIFEST"; }
export LUNA_DISPLAY=${LUNA_DISPLAY:-:97}
export LUNA_STARTS=${LUNA_STARTS:-100} LUNA_CLICKS_PER_START=${LUNA_CLICKS_PER_START:-10}
export LUNA_MEMORY_STARTS=${LUNA_MEMORY_STARTS:-5} LUNA_IDLE_MS=${LUNA_IDLE_MS:-750}
export LUNA_GPUI_BINARY=$(get gpui_binary) LUNA_GPUI_EXPECTED_SHA=$(get gpui_binary_sha256)
export LUNA_MYGO_BINARY=$(get mygo_binary) LUNA_MYGO_EXPECTED_SHA=$(get mygo_binary_sha256)
export LUNA_NANOUI_BINARY=$(get nanoui_binary) LUNA_NANOUI_EXPECTED_SHA=$(get nanoui_binary_sha256)
export LUNA_REQUIRE_BINARY_IDENTITY=1 PROFILE=native-default
source /tmp/gpui-native-env.sh

# Fail closed against the same binary manifest used by preflight before the
# timed loop, and retain the resolved path/hash in each raw log.
for app in gpui mygo nanoui; do
  APP=$app ROWS=0 MODE=eager LUNA_DRY_RUN=1 "$RUN_ONE" >"$OUT/$app-dry-run.txt" 2>&1
  grep -F "BINARY_IDENTITY,$app," "$OUT/$app-dry-run.txt"
done
if [[ "${LUNA_CAPTURE_DRY_RUN:-0}" == 1 ]]; then
  echo "dry-run only: manifest paths and hashes were checked; no app was launched"
  exit 0
fi

printf 'cell,elapsed_seconds\n' > "$OUT/order.csv"
for workload in 'eager 0' 'eager 1000' 'virtual 250000'; do
  read -r mode rows <<< "$workload"
  start=$SECONDS
  printf 'RUN,nanoui,%s,%s\n' "$mode" "$rows" | tee -a "$OUT/order.csv"
  APP=nanoui MODE=$mode ROWS=$rows "$RUN_ONE" >"$OUT/nanoui-$mode-$rows.raw" 2>&1
  elapsed=$((SECONDS-start))
  printf 'DONE,nanoui,%s,%s,%s\n' "$mode" "$rows" "$elapsed" | tee -a "$OUT/order.csv"
done
sha256sum "$OUT"/nanoui-*.raw > "$OUT/raw-sha256.txt"
