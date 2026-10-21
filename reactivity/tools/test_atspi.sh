#!/usr/bin/env bash
# A real native client on a private bus; never changes desktop AT settings.
set -euo pipefail
task_launcher=${1:?Pass the executable at-spi-bus-launcher path}
test -x "$task_launcher"
if [[ ${2-} != --private-session ]]; then
    exec dbus-run-session -- bash "$0" "$task_launcher" --private-session
fi
cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.."
GSETTINGS_BACKEND=memory "$task_launcher" --launch-immediately --a11y=0 &
task_launcher_pid=$!
trap 'kill "$task_launcher_pid" 2>/dev/null || true' EXIT
cargo test --locked -p gpui --features x11 --lib \
    native::accessibility::linux_tests::native_atspi_todo_activation_edit_invoke_and_reactivation \
    -- --ignored --exact --nocapture
