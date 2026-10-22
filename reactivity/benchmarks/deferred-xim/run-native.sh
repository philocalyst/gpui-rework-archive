#!/usr/bin/env bash
set -euo pipefail
fixture_dir=$(cd "$(dirname "$0")" && pwd)
: "${DISPLAY:?set an explicitly isolated X11 display}"
: "${XIM_SERVER:?path to build-server.sh output/server}"
# Keyboard layout, focus and XIM root properties are shared by the display.
exec 9>"${TMPDIR:-/tmp}/gpui-deferred-xim-${DISPLAY//[^[:alnum:]]/_}.lock"
flock -n 9 || { printf 'Another XIM qualification owns %s\n' "$DISPLAY" >&2; exit 1; }
: "${CARGO_TARGET_DIR:?use a dedicated target directory}"
output_dir=${XIM_OUTPUT:-"$fixture_dir/local-runs"}
mkdir -p "$output_dir"
export CARGO_BUILD_JOBS=2 PROBE_BURST_SHORTCUT=1
cargo clippy --manifest-path "$fixture_dir/Cargo.toml" -p winit --lib --offline -- -D warnings > "$output_dir/winit-clippy.log" 2>&1
cargo clippy --manifest-path "$fixture_dir/Cargo.toml" --all-targets --offline -- -D warnings > "$output_dir/probe-clippy.log" 2>&1
cargo build --manifest-path "$fixture_dir/Cargo.toml" --offline --message-format=json > "$output_dir/artifacts.jsonl" 2> "$output_dir/build.log"
for filter in press both; do
    for mode in active late; do
        if [[ $filter == both ]]; then export PROBE_FILTER_RELEASE=1; else unset PROBE_FILTER_RELEASE; fi
        timeout 20s "$CARGO_TARGET_DIR/debug/deferred-xim-probe" "$mode" > "$output_dir/$filter-$mode.log" 2>&1
    done
done
timeout 20s "$CARGO_TARGET_DIR/debug/deferred-xim-probe" focus > "$output_dir/both-focus.log" 2>&1
PROBE_CORE_FIRST_KEY=1 timeout 20s "$CARGO_TARGET_DIR/debug/deferred-xim-probe" active > "$output_dir/both-core.log" 2>&1
sha256sum "$CARGO_TARGET_DIR/debug/deferred-xim-probe" "$XIM_SERVER" "$fixture_dir/src/main.rs" "$fixture_dir/server.c" "$fixture_dir/Cargo.lock" > "$output_dir/sha256.txt"
printf 'PASS: active and late servers, press-only and press/release filters, focus-callback admission, core-first ordering\n'
