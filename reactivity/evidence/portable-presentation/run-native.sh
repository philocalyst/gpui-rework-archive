#!/usr/bin/env bash
set -euo pipefail
source /tmp/gpui-native-env.sh
export DISPLAY=:128
if test -e /tmp/.X11-unix/X128; then exit 9; fi
/nix/store/iw8dx6lhrkdc5wzszjzqzl677y68y88r-xvfb-21.1.24/bin/Xvfb :128 -screen 0 1280x800x24 -nolisten tcp -ac > /tmp/gpui-portable-presenter-xvfb.log 2>&1 &
presenter_xvfb_pid=$!
trap 'kill "$presenter_xvfb_pid" 2>/dev/null || true; wait "$presenter_xvfb_pid" 2>/dev/null || true' EXIT
for presenter_attempt in {1..50}; do
 if /nix/store/qvckv6m6ycsa8f26w0f20mzk5w4v9ciq-xdotool-4.20260303.1/bin/xdotool getdisplaygeometry >/dev/null 2>&1; then break; fi
 sleep 0.1
done
export CARGO_TARGET_DIR=/tmp/gpui-portable-presenter-sol-target CARGO_BUILD_JOBS=2
for presenter_test in automatic_target_rejects_before_renderer_and_close_unmaps_a_worker_retained_window native_todo_port_presents_edits_pointer_actions_resize_and_inspection; do
 dbus-run-session -- cargo test --offline --locked -p gpui --features x11 --lib "$presenter_test" -- --ignored --nocapture
done
