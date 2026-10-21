#!/usr/bin/env bash
set -euo pipefail

root=/root/gpui-route-profile-artifacts
baseline=/tmp/gpui-route-profile-baseline-target/release/examples/route_storage_measure
candidate=/tmp/gpui-route-profile-candidate-target/release/examples/route_storage_measure
rounds=${1:-11}

for ((round = 0; round < rounds; round++)); do
    if ((round % 2 == 0)); then
        "$candidate" --case=4096,1,true > "$root/round-$round-candidate.txt" 2>&1
        "$baseline" --case=4096,1,true > "$root/round-$round-baseline.txt" 2>&1
    else
        "$baseline" --case=4096,1,true > "$root/round-$round-baseline.txt" 2>&1
        "$candidate" --case=4096,1,true > "$root/round-$round-candidate.txt" 2>&1
    fi
done
