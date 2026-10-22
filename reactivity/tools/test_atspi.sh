#!/usr/bin/env bash
# A real native client on a private bus; never changes desktop AT settings.
set -euo pipefail
task_launcher=${1:?Pass at-spi-bus-launcher and optionally a prebuilt GPUI test executable}
shift
test -x "$task_launcher"
if [[ ${1-} != --private-session ]]; then
    exec dbus-run-session -- bash "$0" "$task_launcher" --private-session "$@"
fi
shift
cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.."
GSETTINGS_BACKEND=memory "$task_launcher" --launch-immediately --a11y=0 &
task_launcher_pid=$!
trap 'kill "$task_launcher_pid" 2>/dev/null || true' EXIT
# A cached test binary can start before the launcher owns its bus name. Probe
# readiness instead of relying on compile time or a fixed startup delay.
for task_attempt in {1..50}; do
    if dbus-send --session --print-reply --reply-timeout=1000 \
        --dest=org.a11y.Bus /org/a11y/bus org.freedesktop.DBus.Peer.Ping \
        >/dev/null 2>&1; then
        break
    fi
    if ! kill -0 "$task_launcher_pid" 2>/dev/null; then
        wait "$task_launcher_pid" || true
        echo 'AT-SPI launcher exited before becoming ready.' >&2
        exit 1
    fi
    if (( task_attempt == 50 )); then
        echo 'AT-SPI launcher did not become ready.' >&2
        exit 1
    fi
    sleep 0.1
done
task_case=native::accessibility::linux_tests::native_atspi_todo_activation_edit_invoke_and_reactivation
if (( $# )); then
    test "$#" -eq 1
    test -x "$1"
    "$1" "$task_case" --ignored --exact --nocapture --test-threads=1
else
    cargo test --locked -p gpui --features x11 --lib "$task_case" \
        -- --ignored --exact --nocapture
fi
