#!/usr/bin/env bash
# Run from reactivity/. Own and retire this display and runtime directory.
set -euo pipefail
source /tmp/gpui-native-env.sh
export DISPLAY=:131
if test -e /tmp/.X11-unix/X131; then exit 9; fi
export XDG_RUNTIME_DIR
XDG_RUNTIME_DIR=$(mktemp -d /tmp/gpui-shared-gpu-runtime.XXXXXX)
/nix/store/iw8dx6lhrkdc5wzszjzqzl677y68y88r-xvfb-21.1.24/bin/Xvfb :131 -screen 0 1280x800x24 -nolisten tcp -ac > /tmp/gpui-shared-gpu-xvfb.log 2>&1 &
shared_gpu_xvfb_pid=$!
cleanup() {
    kill "$shared_gpu_xvfb_pid" 2>/dev/null || true
    wait "$shared_gpu_xvfb_pid" 2>/dev/null || true
    rm -rf "$XDG_RUNTIME_DIR"
}
trap cleanup EXIT
for shared_gpu_attempt in {1..50}; do
    if /nix/store/qvckv6m6ycsa8f26w0f20mzk5w4v9ciq-xdotool-4.20260303.1/bin/xdotool getdisplaygeometry >/dev/null 2>&1; then break; fi
    sleep 0.1
done
export CARGO_TARGET_DIR=/tmp/gpui-shared-gpu-sol-target CARGO_BUILD_JOBS=2
for shared_gpu_test in automatic_target_rejects_before_renderer_and_close_unmaps_a_worker_retained_window native_todo_port_presents_edits_pointer_actions_resize_and_inspection; do
    dbus-run-session -- cargo test --offline --locked -p gpui --features x11 --lib "$shared_gpu_test" -- --ignored --nocapture
done
