#!/usr/bin/env bash
source /tmp/gpui-hummingbird-browser-allocation-env.sh
set -u
capture_dir=/tmp/gpui-hummingbird-browser-allocation-evidence/known-qualification
cd /root/gpui-hummingbird-browser-allocation-sol/reactivity
run_gate() {
    local gate_name=$1
    shift
    printf '%q ' "$@" > "$capture_dir/$gate_name.command"
    printf '\n' >> "$capture_dir/$gate_name.command"
    "$@" > "$capture_dir/$gate_name.log" 2>&1
    local gate_exit=$?
    printf '%s\n' "$gate_exit" > "$capture_dir/$gate_name.exit"
    if [ "$gate_exit" -ne 0 ]; then exit "$gate_exit"; fi
}
run_gate core cargo test --offline --locked -p gpui_reactivity_core
run_gate canvas cargo test --offline --locked -p gpui_canvas
run_gate gpui-default cargo test --offline --locked -p gpui
run_gate gpui-verify cargo test --offline --locked -p gpui --features cephal/verify-cache --test text_geometry --test intrinsic_text
run_gate port-default cargo test --offline --locked --manifest-path ports/hummingbird/Cargo.toml
run_gate port-cpal cargo test --offline --locked --manifest-path ports/hummingbird/Cargo.toml --features cpal-output
run_gate port-native cargo test --offline --locked --manifest-path ports/hummingbird/Cargo.toml --features native
run_gate gpui-native cargo test --offline --locked -p gpui --features x11
run_gate clippy-default cargo clippy --offline --locked -p gpui_reactivity_core -p gpui_canvas -p gpui --all-targets -- -D warnings
run_gate clippy-native cargo clippy --offline --locked -p gpui --features x11 --all-targets -- -D warnings
run_gate port-clippy-default cargo clippy --offline --locked --manifest-path ports/hummingbird/Cargo.toml --all-targets -- -D warnings
run_gate port-clippy-native cargo clippy --offline --locked --manifest-path ports/hummingbird/Cargo.toml --features native --all-targets -- -D warnings
run_gate headless cargo run --offline --locked --manifest-path ports/hummingbird/Cargo.toml -- --headless
/nix/store/9r02ykx9y35lf4gk6gc30gnag1y8ncp7-python3-3.13.15/bin/python3 "$capture_dir/guard.py" verify > "$capture_dir/functional-source-after.log" 2>&1
