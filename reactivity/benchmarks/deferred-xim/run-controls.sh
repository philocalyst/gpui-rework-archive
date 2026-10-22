#!/usr/bin/env bash
set -euo pipefail
fixture_dir=$(cd "$(dirname "$0")" && pwd)
repo_dir=$(cd "$fixture_dir/../../.." && pwd)
: "${DISPLAY:?set an explicitly isolated X11 display}"
: "${XIM_SERVER:?path to build-server.sh output/server}"
# Keyboard layout, focus and XIM root properties are shared by the display.
exec 9>"${TMPDIR:-/tmp}/gpui-deferred-xim-${DISPLAY//[^[:alnum:]]/_}.lock"
flock -n 9 || { printf 'Another XIM qualification owns %s\n' "$DISPLAY" >&2; exit 1; }
: "${XIM_CONTROL_ROOT:?use a new dedicated source and artifact directory}"
mkdir -p "$XIM_CONTROL_ROOT"
export CARGO_BUILD_JOBS=2
unset PROBE_STOCK_PREPARE PROBE_EXPECT_EAGER PROBE_CORE_FIRST_KEY PROBE_FILTER_RELEASE
for lane in eager pre-replay; do
    if [[ $lane == eager ]]; then ref=c9344bdd592c2c7474ba9412bc17e00a4c1c453a; else ref=f51089671a; fi
    lane_dir="$XIM_CONTROL_ROOT/$lane"
    mkdir -p "$lane_dir/source" "$lane_dir/probe/src"
    git -c safe.directory="$repo_dir" -C "$repo_dir" archive "$ref" reactivity/vendor/winit | tar -x -C "$lane_dir/source"
    cp "$fixture_dir/src/main.rs" "$lane_dir/probe/src/main.rs"
    # Stock also loses spots on XIC style recreation. Bypass only that known setup
    # defect while PROBE_STOCK_PREPARE isolates the independent replay assertion.
    if [[ $lane == eager ]]; then
        sed -i '/fn require_spot(.* {/a\        if std::env::var_os("PROBE_STOCK_PREPARE").is_some() { return; }' "$lane_dir/probe/src/main.rs"
    fi
    cat > "$lane_dir/probe/Cargo.toml" <<TOML
[package]
name = "deferred-xim-$lane-control-probe"
version = "0.0.0"
edition = "2021"
[workspace]
[dependencies]
winit = { path = "$lane_dir/source/reactivity/vendor/winit", default-features = false, features = ["x11", "rwh_06"] }
x11rb = { version = "0.13", features = ["xtest"] }
TOML
    cp "$fixture_dir/Cargo.lock" "$lane_dir/probe/Cargo.lock"
    CARGO_TARGET_DIR="$lane_dir/target" cargo build --manifest-path "$lane_dir/probe/Cargo.toml" --offline --message-format=json > "$lane_dir/artifacts.jsonl" 2> "$lane_dir/build.log"
    binary="$lane_dir/target/debug/deferred-xim-$lane-control-probe"
    if [[ $lane == eager ]]; then
        export PROBE_EXPECT_EAGER=1 PROBE_CORE_FIRST_KEY=1 PROBE_BURST_SHORTCUT=1
        set +e
        timeout 20s "$binary" active > "$lane_dir/first-key.log" 2>&1
        status=$?
        set -e
        [[ $status == 101 ]] || { cat "$lane_dir/first-key.log"; exit 1; }
        rg -q -F 'expected exactly one "Ω":' "$lane_dir/first-key.log"
        rg -q -F 'kind: "key", text: "q"' "$lane_dir/first-key.log"
        unset PROBE_CORE_FIRST_KEY
        export PROBE_STOCK_PREPARE=1
    else
        unset PROBE_EXPECT_EAGER PROBE_STOCK_PREPARE
    fi
    export PROBE_BURST_SHORTCUT=1
    set +e
    timeout 20s "$binary" active > "$lane_dir/burst.log" 2>&1
    status=$?
    set -e
    [[ $status == 101 ]] || { cat "$lane_dir/burst.log"; exit 1; }
    rg -q -F 'PHASE shortcut-after-enable' "$lane_dir/burst.log"
    rg -q -F 'assertion failed: p.modifiers.is_empty()' "$lane_dir/burst.log"
    if rg -q -F 'PHASE burst-shift-one-event-time-translation' "$lane_dir/burst.log"; then exit 1; fi
    sha256sum "$binary" "$lane_dir/probe/src/main.rs" "$lane_dir/probe/Cargo.lock" > "$lane_dir/sha256.txt"
done
printf 'PASS: eager first-key and both pre-fix modifier assertions lose as expected\n'
