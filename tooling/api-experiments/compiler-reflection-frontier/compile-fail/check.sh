#!/bin/sh
set -eu
repo_root=$(cd "$(dirname "$0")/../../../.." && pwd)
experiment_dir="$repo_root/tooling/api-experiments/compiler-reflection-frontier"
target_dir=/tmp/gpui-compiler-reflection-target
nightly_rustc=/Users/mileswirht/.rustup/toolchains/nightly-2026-09-30-aarch64-apple-darwin/bin/rustc
nightly_rustdoc=/Users/mileswirht/.rustup/toolchains/nightly-2026-09-30-aarch64-apple-darwin/bin/rustdoc
CARGO_TARGET_DIR="$target_dir" RUSTC="$nightly_rustc" RUSTDOC="$nightly_rustdoc" rustup run nightly-2026-09-30 cargo build --manifest-path "$experiment_dir/Cargo.toml" --lib >/dev/null
runtime_log=/tmp/gpui-compiler-reflection-runtime-index.log
if rustup run nightly-2026-09-30 rustc --edition=2024 --crate-type=lib "$experiment_dir/compile-fail/runtime-index.rs" -o /tmp/gpui-compiler-reflection-runtime-index.rlib >"$runtime_log" 2>&1; then
  echo "expected runtime-index fixture to fail compilation" >&2
  exit 1
fi
if ! rg -q 'comptime fns can only be called at compile time' "$runtime_log"; then
  cat "$runtime_log" >&2
  echo "runtime-index fixture failed for an unexpected reason" >&2
  exit 1
fi

borrow_log=/tmp/gpui-compiler-reflection-borrow-alias.log
if CARGO_TARGET_DIR="$target_dir" RUSTC="$nightly_rustc" RUSTDOC="$nightly_rustdoc" rustup run nightly-2026-09-30 cargo check --manifest-path "$experiment_dir/compile-fail/borrow_alias/Cargo.toml" >"$borrow_log" 2>&1; then
  echo "expected overlapping-borrow fixture to fail compilation" >&2
  exit 1
fi
if ! rg -q 'cannot borrow `value` as mutable more than once at a time' "$borrow_log"; then
  cat "$borrow_log" >&2
  echo "overlapping-borrow fixture failed for an unexpected reason" >&2
  exit 1
fi
printf '%s\n' "runtime field index and overlapping mutable borrow correctly rejected"
