#!/usr/bin/env bash
# Run from reactivity/ after the source commits, with a clean source tree.
set -euo pipefail
source /tmp/gpui-native-env.sh
export CARGO_BUILD_JOBS=2
git diff --exit-code -- crates/gpu benchmarks/gpu-owner
shared_gpu_source=$(git rev-parse HEAD)
shared_gpu_binary_dir="/tmp/gpui-shared-gpu-controls/$shared_gpu_source"
mkdir -p "$shared_gpu_binary_dir" evidence/gpu-shared-owner/final
printf '%s\n' "$shared_gpu_source" > evidence/gpu-shared-owner/final/source.txt
CARGO_TARGET_DIR=/tmp/gpui-shared-gpu-sol-target cargo build --release --offline --locked --manifest-path benchmarks/gpu-owner/Cargo.toml --bins > evidence/gpu-shared-owner/final/fixture-build.txt 2>&1
for shared_gpu_binary in owned shared lost-state; do
    cp "/tmp/gpui-shared-gpu-sol-target/release/$shared_gpu_binary" "$shared_gpu_binary_dir/$shared_gpu_binary"
done
for shared_gpu_mode in same-device per-device; do
    for shared_gpu_n in 1 2 8; do
        "$shared_gpu_binary_dir/owned" "$shared_gpu_mode" "$shared_gpu_n" > "evidence/gpu-shared-owner/final/owned-$shared_gpu_mode-$shared_gpu_n.txt" 2>&1
    done
done
for shared_gpu_n in 1 2 8; do
    "$shared_gpu_binary_dir/shared" "$shared_gpu_n" > "evidence/gpu-shared-owner/final/shared-$shared_gpu_n.txt" 2>&1
done
"$shared_gpu_binary_dir/lost-state" > evidence/gpu-shared-owner/final/lost-state.txt 2>&1
CARGO_TARGET_DIR=/tmp/gpui-shared-gpu-sol-counts-target cargo build --release --offline --locked --manifest-path benchmarks/gpu-owner/Cargo.toml --bins --features counts > evidence/gpu-shared-owner/final/fixture-counts-build.txt 2>&1
for shared_gpu_binary in owned shared; do
    cp "/tmp/gpui-shared-gpu-sol-counts-target/release/$shared_gpu_binary" "$shared_gpu_binary_dir/$shared_gpu_binary-counts"
done
for shared_gpu_mode in same-device per-device; do
    for shared_gpu_n in 1 2 8; do
        "$shared_gpu_binary_dir/owned-counts" "$shared_gpu_mode" "$shared_gpu_n" > "evidence/gpu-shared-owner/final/owned-$shared_gpu_mode-$shared_gpu_n-counts.txt" 2>&1
    done
done
for shared_gpu_n in 1 2 8; do
    "$shared_gpu_binary_dir/shared-counts" "$shared_gpu_n" > "evidence/gpu-shared-owner/final/shared-$shared_gpu_n-counts.txt" 2>&1
done
sha256sum "$shared_gpu_binary_dir/"* > evidence/gpu-shared-owner/final/binaries.sha256
