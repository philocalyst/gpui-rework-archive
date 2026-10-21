#!/usr/bin/env bash
set -euo pipefail
DIR=$(cd "$(dirname "$0")" && pwd)
source /tmp/gpui-native-env.sh
export DISPLAY=:94
export CARGO_BUILD_JOBS=1
export CARGO_TARGET_DIR=/tmp/gpui-bench-target
export GOCACHE=/tmp/gpui-bench-gocache
export LD_LIBRARY_PATH=/nix/store/1fl4qsghsryd5f764m5v64vlxdz9d8qx-gtk+3-3.24.52/lib:/nix/store/c4q6wnp14xf0npalyiqsfp1c99y4qhcx-cairo-1.18.4/lib:${LD_LIBRARY_PATH:-}

# Release binaries stay outside the compared source trees except for the
# temporary NanoUI zig-out output; no production source is edited.
cp "$DIR/fixtures/nanoui-main.zig" \
  /root/gpui-bench-luna/comparators/nanoui/examples/luna-bench/main.zig
cp "$DIR/fixtures/mygo-main.go" \
  /root/gpui-bench-luna/comparators/mygo/examples/luna-bench/main.go
cp "$DIR/fixtures/gpui-luna_bench.rs" \
  "$DIR/../../crates/gpui/examples/luna_bench.rs"
# NanoUI's fontdb scans ordinary font directories instead of Fontconfig's Nix
# store index. Stage the same host-resolved DejaVu Sans face there for the
# fixture's explicit family selection.
font_dir=/root/.local/share/fonts/luna-bench
font_target="$font_dir/DejaVuSans.ttf"
mkdir -p "$font_dir"
rm -f "$font_target"
fc-cache -f "$font_dir"
font_path=$(fc-match -f '%{file}' 'DejaVu Sans')
test -f "$font_path"
cp "$font_path" "$font_target"
fc-cache -f "$font_dir"
cd /root/gpui-bench-luna/comparators/nanoui
/tmp/gpui-bench-toolchains/zig/zig build -Doptimize=ReleaseFast
cd /root/gpui-bench-luna/comparators/mygo
/tmp/gpui-bench-toolchains/go/bin/go build -trimpath -o /tmp/luna-bench-mygo ./examples/luna-bench
cd /root/gpui-bench-luna/reactivity
cargo build --offline --release -p gpui --example luna_bench --features x11-minimal
cp /tmp/gpui-bench-target/release/examples/luna_bench /tmp/gpui-bench-gpui-cpu
cargo build --offline --release -p gpui --example luna_bench --features x11
cp /tmp/gpui-bench-target/release/examples/luna_bench /tmp/gpui-bench-gpui-x11
cd benchmarks/nanoui-mygo-gpui
CARGO_TARGET_DIR=/tmp/gpui-bench-observer-target cargo build --offline --release
