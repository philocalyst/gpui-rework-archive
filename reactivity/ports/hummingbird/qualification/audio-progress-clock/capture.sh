#!/usr/bin/env bash
set -u
source /tmp/gpui-hummingbird-audio-env.sh
cd /root/gpui-hummingbird-audio-sol
capture_dir=/tmp/gpui-hummingbird-audio-evidence/sol-progress-capture
mkdir -p "$capture_dir"
sha256sum -c /tmp/gpui-hummingbird-audio-evidence/sol-progress-freeze/sha256.txt > "$capture_dir/source-check-before.log" || exit 97
date -u '+START %Y-%m-%d %H:%M:%S UTC'
for iteration in {1..13}; do
    status=0
    /tmp/gpui-hummingbird-audio-evidence/sol-progress-freeze/audio-clock-candidate clocked::scheduled_public_output_keeps_up_with_fixed_consumption_deadlines --ignored --exact --nocapture --test-threads=1 > "$capture_dir/run-$iteration.log" 2>&1 || status=$?
    printf 'CAPTURE %s exit=%s\n' "$iteration" "$status"
    cat "$capture_dir/run-$iteration.log"
    if [ "$status" -ne 0 ]; then
        date -u '+DONE WITH FAILURE %Y-%m-%d %H:%M:%S UTC'
        exit "$status"
    fi
done
sha256sum -c /tmp/gpui-hummingbird-audio-evidence/sol-progress-freeze/sha256.txt > "$capture_dir/source-check-after.log" || exit 98
date -u '+DONE %Y-%m-%d %H:%M:%S UTC'
