#!/usr/bin/env bash
set -euo pipefail
source /tmp/gpui-native-env.sh
export DISPLAY=:165
test ! -e /tmp/.X11-unix/X165
runtime=$(mktemp -d /tmp/gpui-outline-native.XXXXXX)
export XDG_RUNTIME_DIR=$runtime
/nix/store/iw8dx6lhrkdc5wzszjzqzl677y68y88r-xvfb-21.1.24/bin/Xvfb "$DISPLAY" -screen 0 1024x768x24 -nolisten tcp > /tmp/gpui-property-outline-pointer-xvfb.log 2>&1 &
server=$!
trap 'kill "$server" 2>/dev/null || true; wait "$server" 2>/dev/null || true; rm -rf "$runtime"' EXIT
for attempt in {1..100}; do
    test -e /tmp/.X11-unix/X165 && break
    sleep 0.05
done
test -e /tmp/.X11-unix/X165
/tmp/gpui-property-outline-native-frozen native::property_action_tests::native_contained_property_entry_recovers_and_reports_stale_targets --exact --ignored --nocapture --test-threads=1
