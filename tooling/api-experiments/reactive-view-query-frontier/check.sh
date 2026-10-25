#!/bin/sh
set -eu

cd "$(dirname "$0")"
scratch="$(mktemp -d)"
trap 'rm -rf "$scratch"' EXIT

rustc --edition=2024 main.rs -o "$scratch/reactive-view-query"
"$scratch/reactive-view-query"

if rustc --edition=2024 compile_fail_escape.rs -o "$scratch/should-not-build" 2>"$scratch/compile-fail.log"; then
    echo "expected the escaping-borrow example to fail compilation" >&2
    exit 1
fi

if ! rg -q "lifetime|borrowed|escapes|reference" "$scratch/compile-fail.log"; then
    cat "$scratch/compile-fail.log" >&2
    echo "compile failure did not look like a borrow-checker rejection" >&2
    exit 1
fi

echo "positive callback and expected borrow escape rejection passed"
