#!/usr/bin/env bash
set -euo pipefail

DIR=$(cd "$(dirname "$0")" && pwd)
ROOT=/tmp/gpui-route-parent-b60
TARGET=/tmp/gpui-route-parent-b60-target
OUTPUT_DIR=/tmp/gpui-route-builds
MANIFEST_DIR="$DIR/../results"
PIN=b60af3a4f97d67a35b4eab5a4ef672a17d9de6f6
FIXTURE="$DIR/../fixtures/gpui-luna_bench.rs"

source /tmp/gpui-native-env.sh
export CARGO_BUILD_JOBS=${CARGO_BUILD_JOBS:-4}
export CARGO_TARGET_DIR="$TARGET"

actual=$(git -C "$ROOT" rev-parse HEAD)
if [[ "$actual" != "$PIN" ]]; then
  echo "wrong source checkout: expected $PIN, got $actual" >&2
  exit 1
fi
if [[ ! -f "$ROOT/.git" ]] || git -C "$ROOT" symbolic-ref -q HEAD >/dev/null; then
  echo "parent source must be a detached worktree at the pinned commit" >&2
  exit 1
fi
if [[ -n $(git -C "$ROOT" status --porcelain --untracked-files=no) ]]; then
  echo "source checkout has tracked modifications" >&2
  exit 1
fi
mkdir -p "$OUTPUT_DIR" "$MANIFEST_DIR"
cp "$FIXTURE" "$ROOT/reactivity/crates/gpui/examples/luna_bench.rs"
fixture_sha=$(sha256sum "$ROOT/reactivity/crates/gpui/examples/luna_bench.rs" | cut -d' ' -f1)
expected_fixture_sha=$(sha256sum "$FIXTURE" | cut -d' ' -f1)
if [[ "$fixture_sha" != "$expected_fixture_sha" ]]; then
  echo "fixture copy hash mismatch" >&2
  exit 1
fi

cargo build --offline --locked --release --manifest-path "$ROOT/reactivity/Cargo.toml" \
  -p gpui --example luna_bench --features x11-minimal

binary="$TARGET/release/examples/luna_bench"
binary_sha=$(sha256sum "$binary" | cut -d' ' -f1)
artifact="$OUTPUT_DIR/gpui-parent-b60-$binary_sha"
if [[ -e "$artifact" ]]; then
  existing_sha=$(sha256sum "$artifact" | cut -d' ' -f1)
  if [[ "$existing_sha" != "$binary_sha" ]]; then echo "refusing to replace immutable artifact" >&2; exit 1; fi
else
  cp "$binary" "$artifact"
fi
{
  echo "source_commit=$actual"
  echo "source_root=$ROOT"
  echo "target_dir=$TARGET"
  echo "fixture_sha256=$fixture_sha"
  echo "reactivity_cargo_lock_sha256=$(sha256sum "$ROOT/reactivity/Cargo.lock" | cut -d' ' -f1)"
  echo "gpui_cargo_manifest_sha256=$(sha256sum "$ROOT/reactivity/crates/gpui/Cargo.toml" | cut -d' ' -f1)"
  echo "binary_sha256=$binary_sha"
  echo "target_triple=$(rustc -vV | sed -n 's/^host: //p')"
  echo "rustc=$(rustc -V)"
  echo "rustc_verbose_begin"
  rustc -vV
  echo "rustc_verbose_end"
  echo "cargo=$(cargo -V)"
  echo "features=x11-minimal"
  echo "profile=release"
  echo "renderer=ReferenceCpu"
  echo "artifact=$artifact"
} > "$MANIFEST_DIR/route-parent-b60-$binary_sha.manifest"
echo "built $artifact"
echo "manifest=$MANIFEST_DIR/route-parent-b60-$binary_sha.manifest"
