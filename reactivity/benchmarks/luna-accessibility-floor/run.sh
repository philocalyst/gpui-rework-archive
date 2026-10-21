#!/usr/bin/env bash
set -euo pipefail
probe_dir="$1"
target_dir="$2"
server_log="/tmp/a11y-floor-probe-server-$$.log"
"$target_dir/debug/status-server" >"$server_log" 2>&1 &
server_pid=$!
cleanup() { kill "$server_pid" 2>/dev/null || true; wait "$server_pid" 2>/dev/null || true; rm -f "$server_log"; }
trap cleanup EXIT
for _ in $(seq 1 100); do
  if grep -q '^ready$' "$server_log"; then break; fi
  sleep 0.02
done
if ! grep -q '^ready$' "$server_log"; then cat "$server_log"; exit 1; fi
"$target_dir/debug/$(basename "$probe_dir")"
