#!/usr/bin/env bash
set -euo pipefail

DIR=$(cd "$(dirname "$0")" && pwd)
BASE=$(cd "$DIR/.." && pwd)
REPO=$(cd "$BASE/../../.." && pwd)
: "${LUNA_PARENT_BINARY:?set the SHA-pinned parent executable path}"
: "${LUNA_PARENT_SHA:?set the expected parent executable SHA-256}"
: "${LUNA_CANDIDATE_BINARY:?set the SHA-pinned candidate executable path}"
: "${LUNA_CANDIDATE_SHA:?set the expected candidate executable SHA-256}"
: "${LUNA_CANDIDATE_COMMIT:?set the frozen integration commit SHA}"
: "${LUNA_FIXTURE_PREFLIGHT_RECORD:?set the reviewed common-fixture preflight record}"
: "${LUNA_PREFLIGHT_ID:?set a new unique preflight identifier}"
: "${LUNA_DISPLAY:?set a reviewed Xvfb display; this does not start a timing matrix}"
if [[ ! -f "$LUNA_FIXTURE_PREFLIGHT_RECORD" ]] || ! rg -q '^status=pass$' "$LUNA_FIXTURE_PREFLIGHT_RECORD"; then
  echo "common-fixture preflight record is absent or does not contain status=pass" >&2
  exit 1
fi

OUT="$DIR/preflights/$LUNA_PREFLIGHT_ID"
if [[ -e "$OUT" ]]; then
  echo "refusing to overwrite existing preflight: $OUT" >&2
  exit 1
fi
mkdir -p "$OUT"

MYGO_BINARY=/tmp/luna-bench-mygo
MYGO_SHA=e68767b866432dad27fc44e646217b60b1e5e60cb6e43fb2e80c8e41be4785df
NANOUI_BINARY="$REPO/comparators/nanoui/zig-out/bin/luna-bench"
NANOUI_SHA=b2d9c6f4ce2745a1e8d9b68c07f831ab2f7756eb349ed14a2c50891403f513a8
for spec in \
  "parent:$LUNA_PARENT_BINARY:$LUNA_PARENT_SHA" \
  "candidate:$LUNA_CANDIDATE_BINARY:$LUNA_CANDIDATE_SHA" \
  "mygo:$MYGO_BINARY:$MYGO_SHA" \
  "nanoui:$NANOUI_BINARY:$NANOUI_SHA"; do
  IFS=: read -r label binary expected <<< "$spec"
  actual=$(sha256sum "$binary" | cut -d' ' -f1)
  if [[ "$actual" != "$expected" ]]; then
    echo "$label binary SHA mismatch: expected $expected, got $actual" >&2
    exit 1
  fi
done
if [[ $(git -C "$REPO/comparators/mygo" rev-parse HEAD) != ea23ad2975a87db9b20efe6690ffedf88f4fe4f3 || \
      $(git -C "$REPO/comparators/nanoui" rev-parse HEAD) != dfa7f7ab4e890f643703f4ffe4d834ff10defd4f ]]; then
  echo "peer source checkout does not match the documented pins" >&2
  exit 1
fi
fixture_sha=$(sha256sum "$BASE/fixtures/gpui-luna_bench.rs" | cut -d' ' -f1)
check_manifest() {
  local manifest=$1 line
  shift
  if [[ ! -f "$manifest" ]]; then echo "missing build manifest: $manifest" >&2; exit 1; fi
  for line in "$@"; do
    if ! rg -Fxq "$line" "$manifest"; then
      echo "build manifest mismatch ($manifest): missing $line" >&2
      exit 1
    fi
  done
}
check_manifest "$BASE/results/route-parent-b60-$LUNA_PARENT_SHA.manifest" \
  "source_commit=b60af3a4f97d67a35b4eab5a4ef672a17d9de6f6" \
  "fixture_sha256=$fixture_sha" "binary_sha256=$LUNA_PARENT_SHA" \
  "features=x11-minimal" "renderer=ReferenceCpu"
candidate_manifest="$BASE/results/route-candidate-${LUNA_CANDIDATE_COMMIT:0:12}-$LUNA_CANDIDATE_SHA.manifest"
check_manifest "$candidate_manifest" \
  "source_commit=$LUNA_CANDIDATE_COMMIT" "fixture_sha256=$fixture_sha" \
  "binary_sha256=$LUNA_CANDIDATE_SHA" "features=x11-minimal" "renderer=ReferenceCpu"

source /tmp/gpui-native-env.sh
export DISPLAY=$LUNA_DISPLAY
export PROFILE=cpu-matched MODE=eager ROWS=10000
export LUNA_STARTS=1 LUNA_CLICKS_PER_START=0 LUNA_MEMORY_STARTS=0
export LUNA_PREFLIGHT=1
export LD_LIBRARY_PATH=/nix/store/1fl4qsghsryd5f764m5v64vlxdz9d8qx-gtk+3-3.24.52/lib:/nix/store/c4q6wnp14xf0npalyiqsfp1c99y4qhcx-cairo-1.18.4/lib:${LD_LIBRARY_PATH:-}

for variant in parent candidate; do
  binary=$LUNA_PARENT_BINARY
  if [[ "$variant" == candidate ]]; then binary=$LUNA_CANDIDATE_BINARY; fi
  APP=gpui LUNA_GPUI_BINARY="$binary" LUNA_SCREENSHOT_PATH="$OUT/gpui-$variant.ppm" \
    "$BASE/run-one.sh" > "$OUT/gpui-$variant.log" 2>&1
done
for app in mygo nanoui; do
  APP="$app" LUNA_SCREENSHOT_PATH="$OUT/$app.ppm" \
    "$BASE/run-one.sh" > "$OUT/$app.log" 2>&1
done

{
  echo "status=awaiting-review"
  echo "display=$LUNA_DISPLAY"
  echo "workload=eager-10000"
  echo "profile=cpu-matched"
  echo "fixture_sha256=$fixture_sha"
  echo "parent_binary_sha256=$LUNA_PARENT_SHA"
  echo "parent_source=b60af3a4f97d67a35b4eab5a4ef672a17d9de6f6"
  echo "candidate_binary_sha256=$LUNA_CANDIDATE_SHA"
  echo "candidate_source=$LUNA_CANDIDATE_COMMIT"
  echo "mygo_source=ea23ad2975a87db9b20efe6690ffedf88f4fe4f3"
  echo "mygo_binary_sha256=$MYGO_SHA"
  echo "nanoui_source=dfa7f7ab4e890f643703f4ffe4d834ff10defd4f"
  echo "nanoui_binary_sha256=$NANOUI_SHA"
  echo "checks=observer-geometry-and-button/first-row-glyph-gate"
  echo "logs=$OUT"
} > "$OUT/record.txt"
sha256sum "$OUT"/* > "$OUT/sha256.txt"
echo "preflight evidence written to $OUT; review logs/screenshots before changing status to pass"
