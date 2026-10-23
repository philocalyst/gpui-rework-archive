#!/usr/bin/env bash
source /tmp/gpui-hummingbird-browser-allocation-env.sh
set -u
capture_dir=/tmp/gpui-hummingbird-browser-allocation-evidence/known-qualification
probe_dir=/tmp/gpui-hummingbird-browser-allocation-evidence
python=/nix/store/9r02ykx9y35lf4gk6gc30gnag1y8ncp7-python3-3.13.15/bin/python3
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
run_gate core-layout cargo test --offline --locked -p gpui_reactivity_core --features layout
run_gate canvas-ledger cargo test --offline --locked -p gpui_canvas --lib scoped_geometry_allocation_and_payload_ledger -- --nocapture
run_gate text-headers cargo test --offline --locked -p gpui_canvas --lib measurement_keeps_exact_metrics_and_no_owned_geometry -- --nocapture
run_gate gpui-ledger cargo test --offline --locked -p gpui --lib acknowledged_geometry_owner_epoch_and_allocation_ledger -- --nocapture
run_gate constructor-release-build cargo build --release --offline --locked --manifest-path "$probe_dir/normal/Cargo.toml" --message-format=json
mv "$capture_dir/constructor-release-build.log" "$capture_dir/constructor-release-build.jsonl"
"$python" "$capture_dir/freeze_artifacts.py" "$capture_dir/constructor-release-build.jsonl" "$capture_dir/constructor-artifacts" > "$capture_dir/constructor-freeze.log" 2>&1 || exit $?
run_gate constructor-release-runtime timeout --signal=TERM --kill-after=5s 60s "$capture_dir/constructor-artifacts/authority-constructor-bill"
run_gate native-release-build cargo build --release --offline --locked --manifest-path ports/hummingbird/Cargo.toml --features native --example native_service --message-format=json
mv "$capture_dir/native-release-build.log" "$capture_dir/native-release-build.jsonl"
"$python" "$capture_dir/freeze_artifacts.py" "$capture_dir/native-release-build.jsonl" "$capture_dir/native-artifacts" > "$capture_dir/native-freeze.log" 2>&1 || exit $?
"$python" "$capture_dir/guard.py" verify > "$capture_dir/remaining-source-after.log" 2>&1
