#!/bin/sh
set -eu
manifest="$(dirname "$0")/compile_fail/Cargo.toml"
target="${CARGO_TARGET_DIR:-/tmp/gpui-value-shape-frontier-target}"
for case in mutable_alias path_type_mismatch escaped_borrow; do
    if cargo check --quiet --manifest-path "$manifest" --target-dir "$target" --bin "$case" >"/tmp/value-shape-frontier-$case.log" 2>&1; then
        echo "ERROR: $case unexpectedly compiled"
        exit 1
    fi
    case "$case" in
        mutable_alias) diagnostic=E0499 ;;
        path_type_mismatch) diagnostic=E0308 ;;
        escaped_borrow) diagnostic=E0515 ;;
    esac
    if ! rg -q "$diagnostic" "/tmp/value-shape-frontier-$case.log"; then
        echo "ERROR: $case failed without expected $diagnostic diagnostic"
        cat "/tmp/value-shape-frontier-$case.log"
        exit 1
    fi
    echo "PASS: $case rejected with $diagnostic"
done
