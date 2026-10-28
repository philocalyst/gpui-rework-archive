#!/usr/bin/env bash
set -euo pipefail

root=/root/gpui-route-profile-artifacts
for side in baseline candidate; do
    for phase in describe present; do
        for field in $(if [[ $phase == describe ]]; then printf 'flatten preflight reconcile index'; else printf 'layout_setup layout_compute paint_commit'; fi); do
            values=$(for round in {0..10}; do
                file="$root/round-$round-$side.txt"
                if [[ $phase == describe ]]; then
                    awk -F'[,=]' -v field="$field" '
                        /route_profile,phase=describe,mount=true/ {
                            seen++
                            if (seen == 2) {
                                if (field == "flatten") print $7
                                else if (field == "preflight") print $9
                                else if (field == "reconcile") print $11
                                else if (field == "index") print $13
                                exit
                            }
                        }
                    ' "$file"
                else
                    awk -F'[,=]' -v field="$field" '
                        /route_profile,phase=present,sequence=1/ {
                            seen++
                            if (seen == 2) {
                                if (field == "layout_setup") print $7
                                else if (field == "layout_compute") print $9
                                else if (field == "paint_commit") print $11
                                exit
                            }
                        }
                    ' "$file"
                fi
            done | sort -n)
            median=$(printf '%s\n' "$values" | awk 'NR==6 {print; exit}')
            minimum=$(printf '%s\n' "$values" | head -1)
            maximum=$(printf '%s\n' "$values" | tail -1)
            printf '%s,%s,%s,median_ns=%s,min_ns=%s,max_ns=%s\n' "$side" "$phase" "$field" "$median" "$minimum" "$maximum"
        done
    done
done
