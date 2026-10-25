#!/bin/sh
set -eu
manifest="$(dirname "$0")/compile_fail/Cargo.toml"
target="${TMPDIR:-/tmp}/schema-slot-audit-compile-fail-target"
for fixture in wrong_field_root wrong_role_root borrow_alias; do
  if cargo check --manifest-path "$manifest" --target-dir "$target" --bin "$fixture" >"$target-$fixture.log" 2>&1; then
    echo "expected $fixture to fail compilation" >&2
    exit 1
  fi
  echo "$fixture rejected as expected"
done
