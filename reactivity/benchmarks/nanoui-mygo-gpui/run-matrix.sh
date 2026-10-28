#!/usr/bin/env bash
set -euo pipefail
DIR=$(cd "$(dirname "$0")" && pwd)
mkdir -p "$DIR/results"
export LUNA_STARTS=${LUNA_STARTS:-100}
export LUNA_CLICKS_PER_START=${LUNA_CLICKS_PER_START:-10}
export LUNA_MEMORY_STARTS=${LUNA_MEMORY_STARTS:-5}
export LUNA_IDLE_MS=${LUNA_IDLE_MS:-750}
source "$DIR/prepare-runtime.sh"
for profile in cpu-matched native-default; do
  for workload in 'eager 0' 'eager 1000' 'eager 10000' 'virtual 250000'; do
    read -r mode rows <<<"$workload"
    # Rotate framework order by workload and profile to limit thermal/order bias.
    case $(((rows + ${#profile}) % 3)) in
      0) order=(gpui mygo nanoui) ;;
      1) order=(mygo nanoui gpui) ;;
      2) order=(nanoui gpui mygo) ;;
    esac
    for app in "${order[@]}"; do
      cell_start=$SECONDS
      echo "RUN,$profile,$app,$mode,$rows" | tee -a "$DIR/results/order.csv"
      PROFILE="$profile" APP="$app" MODE="$mode" ROWS="$rows" "$DIR/run-one.sh" \
        >"$DIR/results/$profile-$app-$mode-$rows.raw" 2>&1
      echo "DONE,$profile,$app,$mode,$rows,$((SECONDS - cell_start))" | tee -a "$DIR/results/order.csv"
    done
  done
done
