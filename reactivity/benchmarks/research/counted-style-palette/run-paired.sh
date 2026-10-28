#!/usr/bin/env bash
set -euo pipefail

BASE=${PALETTE_BASE:?Set PALETTE_BASE to the directory containing parent/ and candidate/ worktrees}
PARENT="$BASE/parent"
CANDIDATE="$BASE/candidate"
PIN=f01947e679d9dd2ca7ef149b70dccff92dad67dc
QUIET=${PALETTE_QUIET_WINDOW:-}
MODE=${PALETTE_MODE:-guard}
BUILD_JOBS=${PALETTE_BUILD_JOBS:-2}

if ! command -v cargo >/dev/null 2>&1; then
  # This host's pinned Rust toolchain and X11 link environment.
  source /tmp/gpui-native-env.sh
fi

if [[ "$MODE" == capture && "$QUIET" != approved ]]; then
  echo "Refusing timed capture without PALETTE_QUIET_WINDOW=approved" >&2
  exit 2
fi
if [[ "$MODE" != guard && "$MODE" != build && "$MODE" != capture ]]; then
  echo "PALETTE_MODE must be guard, build, or capture" >&2
  exit 2
fi

verify_tree() {
  local tree="$1" expected_paths="$2"
  local head
  head=$(git -C "$tree" rev-parse HEAD)
  [[ "$head" == "$PIN" ]] || { echo "wrong HEAD in $tree: $head" >&2; exit 3; }
  local actual_paths
  actual_paths=$(git -C "$tree" status --porcelain --untracked-files=all | sed 's/^...//' | sort)
  [[ "$actual_paths" == "$expected_paths" ]] || {
    echo "unexpected worktree paths in $tree: $actual_paths" >&2; exit 4;
  }
  (
    cd "$tree/reactivity"
    cargo metadata --manifest-path Cargo.toml --no-deps --format-version 1 \
      | /nix/store/9r02ykx9y35lf4gk6gc30gnag1y8ncp7-python3-3.13.15/bin/python3 -c '
import json, os, sys
m = json.load(sys.stdin)
root = os.path.realpath(os.getcwd())
assert os.path.realpath(m["workspace_root"]) == root, (m["workspace_root"], root)
p = [p for p in m["packages"] if p["name"] == "gpui"]
assert len(p) == 1 and os.path.realpath(p[0]["manifest_path"]) == os.path.join(root, "crates/gpui/Cargo.toml")
'
  )
}

verify_tree "$PARENT" "reactivity/crates/gpui/src/runtime/style_ledger.rs"
verify_tree "$CANDIDATE" $'reactivity/crates/gpui/src/runtime/style_ledger.rs\nreactivity/crates/gpui/src/runtime/styles.rs'

for tree in "$PARENT" "$CANDIDATE"; do
  actual=$(sha256sum "$tree/reactivity/crates/gpui/src/runtime/style_ledger.rs" | cut -d' ' -f1)
  [[ "$actual" == 6a09247eb8944d088912b9f1d13a5e22da70ee5f9c08dd0938bc4d828c12e935 ]] || {
    echo "probe source hash mismatch in $tree" >&2; exit 5;
  }
done
[[ $(sha256sum "$PARENT/reactivity/crates/gpui/src/runtime/styles.rs" | cut -d' ' -f1) == 1a61ee1ff6cba470d45aef14db07b5e2045134026d4ba38fb56a3edc4124aa19 ]] || {
  echo "parent styles.rs hash mismatch" >&2; exit 6;
}
[[ $(sha256sum "$CANDIDATE/reactivity/crates/gpui/src/runtime/styles.rs" | cut -d' ' -f1) == 2e535b39a2a0ec699fcdee3465b84c1e61d378585606f83296592e5362e3b479 ]] || {
  echo "candidate styles.rs hash mismatch" >&2; exit 7;
}

if [[ "$MODE" == guard || ${PALETTE_GUARD_ONLY:-0} == 1 ]]; then
  echo "source/workspace guards passed; no build or capture launched"
  exit 0
fi

mkdir -p "$BASE/raw"
build_one() {
  local variant="$1"
  local tree="$BASE/$variant"
  local target="$BASE/target-$variant"
  local log="$BASE/raw/build-${variant}.log"
  (
    cd "$tree/reactivity"
    CARGO_BUILD_JOBS="$BUILD_JOBS" CARGO_TARGET_DIR="$target" cargo test --manifest-path Cargo.toml --locked --offline \
      --release -p gpui --lib --features x11-minimal \
      --no-run --message-format=json
  ) > "$log" 2>&1
  local binary
  binary=$(/nix/store/9r02ykx9y35lf4gk6gc30gnag1y8ncp7-python3-3.13.15/bin/python3 - "$log" <<'PY'
import json, sys
paths = []
for line in open(sys.argv[1], encoding="utf-8"):
    try:
        row = json.loads(line)
    except json.JSONDecodeError:
        continue
    target = row.get("target", {})
    if row.get("reason") == "compiler-artifact" and target.get("name") == "gpui" and "lib" in target.get("kind", []):
        if row.get("executable"):
            paths.append(row["executable"])
assert len(paths) == 1, paths
print(paths[0])
PY
  )
  local hash
  hash=$(sha256sum "$binary" | cut -d' ' -f1)
  printf '%s\n%s\n' "$binary" "$hash" > "$BASE/raw/${variant}.binary.txt"
  echo "built $variant binary sha256=$hash path=$binary"
}

if [[ "$MODE" == build ]]; then
  build_one parent
  build_one candidate
  exit 0
fi

run_one() {
  local variant="$1" repetition="$2"
  local binary_file="$BASE/raw/${variant}.binary.txt"
  [[ -s "$binary_file" ]] || { echo "missing $binary_file; run PALETTE_MODE=build first" >&2; exit 8; }
  local binary expected actual
  binary=$(sed -n '1p' "$binary_file")
  expected=$(sed -n '2p' "$binary_file")
  actual=$(sha256sum "$binary" | cut -d' ' -f1)
  [[ "$actual" == "$expected" ]] || { echo "binary changed: $binary" >&2; exit 9; }
  local output="$BASE/raw/${variant}-${repetition}.log"
  "$binary" runtime::style_ledger::counted_palette_phase_profile --ignored --nocapture --test-threads=1 > "$output" 2>&1
}

# Alternating direction limits a simple warm/cold order bias.
for round in 1 2 3; do
  if (( round % 2 == 1 )); then
    run_one parent "$round"
    run_one candidate "$round"
  else
    run_one candidate "$round"
    run_one parent "$round"
  fi
done

echo "captured six raw runs under $BASE/raw"
