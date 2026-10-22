#!/usr/bin/env bash
# Run from reactivity/. Own this display and retire it on every exit.
set -euo pipefail
source /tmp/gpui-native-env.sh
export DISPLAY=:147
if test -e /tmp/.X11-unix/X147; then exit 9; fi
export XDG_RUNTIME_DIR
XDG_RUNTIME_DIR=$(mktemp -d /tmp/gpui-offline-shader-runtime.XXXXXX)
/nix/store/iw8dx6lhrkdc5wzszjzqzl677y68y88r-xvfb-21.1.24/bin/Xvfb :147 -screen 0 1280x800x24 -nolisten tcp -ac > evidence/offline-shader/final/xvfb.txt 2>&1 &
offline_xvfb_pid=$!
cleanup() {
    kill "$offline_xvfb_pid" 2>/dev/null || true
    wait "$offline_xvfb_pid" 2>/dev/null || true
    rm -rf "$XDG_RUNTIME_DIR"
}
trap cleanup EXIT
for offline_attempt in {1..50}; do
    if /nix/store/qvckv6m6ycsa8f26w0f20mzk5w4v9ciq-xdotool-4.20260303.1/bin/xdotool getdisplaygeometry >/dev/null 2>&1; then break; fi
    sleep 0.1
done
export CARGO_TARGET_DIR=/tmp/gpui-shared-gpu-sol-target CARGO_BUILD_JOBS=2
export GPUI_SPIRV_VAL=/nix/store/z5hs3p3inrq3w8cv71jycz7l4y3ny5xk-spirv-tools-1.4.363.0/bin/spirv-val
for offline_test in automatic_target_rejects_before_renderer_and_close_unmaps_a_worker_retained_window native_todo_port_presents_edits_pointer_actions_resize_and_inspection; do
    dbus-run-session -- cargo test --offline --locked -p gpui --features x11,gpui_gpu/offline-shader --lib "$offline_test" -- --ignored --nocapture
done
