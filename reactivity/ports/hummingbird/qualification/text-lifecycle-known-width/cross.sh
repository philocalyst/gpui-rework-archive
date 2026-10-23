#!/usr/bin/env bash
source /tmp/gpui-native-env.sh
unset RUSTFLAGS CARGO_ENCODED_RUSTFLAGS
export CARGO_BUILD_JOBS=1 CARGO_TARGET_DIR=/tmp/gpui-hummingbird-browser-allocation-target
capture_dir=/tmp/gpui-hummingbird-browser-allocation-evidence/known-qualification
cd /root/gpui-hummingbird-browser-allocation-sol/reactivity
for cross_target in aarch64-apple-darwin x86_64-pc-windows-msvc; do
    capture_name="cross-$cross_target"
    if [ -e "$capture_dir/$capture_name.command" ]; then exit 90; fi
    printf '%s\n' "RUSTC_BOOTSTRAP=1 cargo check --offline --locked -p gpui --lib --features native --target $cross_target -Zbuild-std=std,panic_abort --message-format=json" > "$capture_dir/$capture_name.command"
    env RUSTC_BOOTSTRAP=1 cargo check --offline --locked -p gpui --lib --features native --target "$cross_target" -Zbuild-std=std,panic_abort --message-format=json > "$capture_dir/$capture_name.jsonl" 2> "$capture_dir/$capture_name.log"
    gate_exit=$?
    printf '%s\n' "$gate_exit" > "$capture_dir/$capture_name.exit"
    if [ "$gate_exit" -ne 0 ]; then exit "$gate_exit"; fi
done
/nix/store/9r02ykx9y35lf4gk6gc30gnag1y8ncp7-python3-3.13.15/bin/python3 "$capture_dir/guard.py" verify > "$capture_dir/cross-source-after.log" 2>&1
