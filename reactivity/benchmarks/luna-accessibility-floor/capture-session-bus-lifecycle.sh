#!/usr/bin/env bash
set -euo pipefail

repo=/root/gpui-current-native-bench/reactivity
bin=/tmp/gpui-luna-memoryfloor-724-artifacts/empty-x11
expected_bin=b27b609d79e5f0dc9d5fc5fac5c69f25fcd6a510f4ba026eee9046adba4764cb
expected_source=724ece73cb665a1f6d83e97ae7d431eee11a887a
expected_fixture=419d6b422a034f213419cda3f09f794b5ac0d76320cdaa42d5e1f26b42044da8

actual_bin=$(sha256sum "$bin" | cut -d' ' -f1)
actual_fixture=$(sha256sum "$repo/crates/gpui/examples/empty.rs" | cut -d' ' -f1)
actual_source=$(git -C "$repo" rev-parse HEAD)
[[ "$actual_bin" == "$expected_bin" ]]
[[ "$actual_fixture" == "$expected_fixture" ]]
[[ "$actual_source" == "$expected_source" ]]

source /tmp/gpui-native-env.sh
export DISPLAY=:97
printf 'source=%s\nbinary=%s\nfixture=%s\n' "$actual_source" "$actual_bin" "$actual_fixture"
printf 'display=%s\n' "$DISPLAY"
printf 'normal_session_address=%s\n' "${DBUS_SESSION_BUS_ADDRESS:-<unset>}"
printf '%s\n' '--- session-bus names matching a11y ---'
busctl --user list | rg 'org\.a11y|org\.freedesktop\.atspi' || printf '%s\n' 'no org.a11y or AT-SPI names registered'
printf '%s\n' '--- AT client processes ---'
ps -eo pid,args | rg '[o]rca|[s]peech-dispatcher|[a]t-spi-bus-launcher|[a]t-spi2-registryd' || printf '%s\n' 'no matching AT processes observed'

snapshot() {
    label=$1
    address=$2
    out="$(dirname "$0")/runs/session-bus-lifecycle-724-20261021/$label.txt"
    mkdir -p "$(dirname "$out")"
    DISPLAY=:97 DBUS_SESSION_BUS_ADDRESS="$address" "$bin" >"$out.app.log" 2>&1 &
    pid=$!
    sleep 1
    {
        printf 'case=%s\npid=%s\naddress=%s\n' "$label" "$pid" "$address"
        if kill -0 "$pid" 2>/dev/null; then printf 'alive_after_1s=yes\n'; else printf 'alive_after_1s=no\n'; fi
        if [[ -r "/proc/$pid/status" ]]; then
            printf '%s\n' '--- status ---'
            rg '^(Name|VmRSS|RssAnon|RssFile|Threads):' "/proc/$pid/status"
            printf '%s\n' '--- smaps_rollup ---'
            rg '^(Rss|Pss|Pss_Anon|Pss_File|Shared_Clean|Private_Clean|Private_Dirty):' "/proc/$pid/smaps_rollup"
            printf '%s\n' '--- task names ---'
            for task in /proc/"$pid"/task/*; do printf '%s ' "${task##*/}"; cat "$task/comm"; done
            printf '%s\n' '--- executable VMAs ---'
            awk -v path="$bin" '$0 ~ path {header=$0; rss=0; pss=0; next} /^Rss:/ {rss=$2} /^Pss:/ {pss=$2; if (header ~ path) print "Rss=" rss "kB Pss=" pss "kB " header; header=""}' "/proc/$pid/smaps"
        fi
        printf '%s\n' '--- X root children ---'
        DISPLAY=:97 /nix/store/9r02ykx9y35lf4gk6gc30gnag1y8ncp7-python3-3.13.15/bin/python3 - <<'PY'
import ctypes
x = ctypes.CDLL('/nix/store/4wkicwb2jx5h63d79g5qyp9kn4vx27yb-libx11-1.8.13/lib/libX11.so.6.4.0')
x.XOpenDisplay.restype = ctypes.c_void_p
x.XDefaultRootWindow.argtypes = [ctypes.c_void_p]
x.XDefaultRootWindow.restype = ctypes.c_ulong
x.XQueryTree.argtypes = [ctypes.c_void_p, ctypes.c_ulong, ctypes.POINTER(ctypes.c_ulong), ctypes.POINTER(ctypes.c_ulong), ctypes.POINTER(ctypes.POINTER(ctypes.c_ulong)), ctypes.POINTER(ctypes.c_uint)]
x.XFetchName.argtypes = [ctypes.c_void_p, ctypes.c_ulong, ctypes.POINTER(ctypes.c_char_p)]
x.XFree.argtypes = [ctypes.c_void_p]
x.XCloseDisplay.argtypes = [ctypes.c_void_p]
d = x.XOpenDisplay(None)
if not d:
    raise SystemExit('XOpenDisplay failed')
root = x.XDefaultRootWindow(d)
root_return = ctypes.c_ulong()
parent_return = ctypes.c_ulong()
children = ctypes.POINTER(ctypes.c_ulong)()
count = ctypes.c_uint()
x.XQueryTree(d, root, ctypes.byref(root_return), ctypes.byref(parent_return), ctypes.byref(children), ctypes.byref(count))
print('root_children', count.value)
for i in range(count.value):
    title = ctypes.c_char_p()
    x.XFetchName(d, children[i], ctypes.byref(title))
    print(hex(children[i]), title.value.decode(errors='replace') if title.value else None)
    if title.value:
        x.XFree(title)
if children:
    x.XFree(children)
x.XCloseDisplay(d)
PY
        printf '%s\n' '--- app stderr/stdout ---'
        cat "$out.app.log"
    } >"$out"
    kill -TERM "$pid" 2>/dev/null || true
    sleep 0.2
    kill -KILL "$pid" 2>/dev/null || true
    wait "$pid" 2>/dev/null || true
    rm -f "$out.app.log"
}

snapshot session-address unix:path=/run/user/0/bus
snapshot unavailable-address unix:path=/tmp/no-such-a11y-bus
