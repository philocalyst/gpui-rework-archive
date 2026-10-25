#!/bin/sh
set -eu

manifest_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
target_dir=${CARGO_TARGET_DIR:-/tmp/native-select-inference-target}

for probe in alias escape untyped wrong-field; do
    manifest="$manifest_dir/compile_fail/$probe/Cargo.toml"
    log="$target_dir/$probe.log"
    if CARGO_TARGET_DIR="$target_dir" cargo check --quiet --manifest-path "$manifest" >"$log" 2>&1; then
        echo "unexpectedly compiled: $probe"
        exit 1
    fi
    echo "rejected as intended: $probe"
    sed -n '1,10p' "$log"
done
