#!/usr/bin/env bash
set -euo pipefail
root="$(cd "$(dirname "$0")" && pwd)"
cargo test --manifest-path "$root/Cargo.toml"
output="$(mktemp)"
trap 'rm -f "$output"' EXIT
if cargo check --manifest-path "$root/compile-fail/Cargo.toml" >"$output" 2>&1; then
    echo "expected Type::of for an undescribed type to fail" >&2
    exit 1
fi
if ! rg -q 'trait bound `NotDescribed: Describe` is not satisfied' "$output"; then
    cat "$output" >&2
    echo "compile-fail did not report the expected Describe bound" >&2
    exit 1
fi
