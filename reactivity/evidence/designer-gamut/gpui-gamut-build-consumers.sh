#!/usr/bin/env bash
set -euo pipefail
source /tmp/gpui-native-env.sh
python_bin=/nix/store/9r02ykx9y35lf4gk6gc30gnag1y8ncp7-python3-3.13.15/bin/python3
"$python_bin" /tmp/gpui-gamut-reference/source_guard.py /tmp/gpui-gamut-source-pins.json check
for variant in consumer consumer-fallback floor original bare expansion; do
  case "$variant" in
    consumer) project=/tmp/gpui-gamut-consumer; target=/tmp/gpui-gamut-consumer-target; flags=(--features primitive) ;;
    consumer-fallback) project=/tmp/gpui-gamut-consumer; target=/tmp/gpui-gamut-consumer-fallback-target; flags=(--no-default-features --features primitive) ;;
    floor) project=/tmp/gpui-gamut-floor-consumer; target=/tmp/gpui-gamut-floor-target; flags=() ;;
    original) project=/tmp/gpui-gamut-original-consumer; target=/tmp/gpui-gamut-original-target; flags=() ;;
    bare) project=/tmp/gpui-gamut-bare-consumer; target=/tmp/gpui-gamut-bare-target; flags=(--features primitive) ;;
    expansion) project=/tmp/gpui-gamut-expansion-consumer; target=/tmp/gpui-gamut-expansion-target; flags=(--features primitive) ;;
  esac
  CARGO_BUILD_JOBS=2 CARGO_TARGET_DIR="$target" cargo build --release --offline --locked --manifest-path "$project/Cargo.toml" "${flags[@]}" > "/tmp/gpui-gamut-$variant-final-build.log" 2>&1
  cp "$target/release/gamut_consumer" "/tmp/gpui-gamut-$variant-frozen"
  sha256sum "/tmp/gpui-gamut-$variant-frozen" > "/tmp/gpui-gamut-$variant-frozen.sha256"
  "/tmp/gpui-gamut-$variant-frozen" 1000 > "/tmp/gpui-gamut-$variant-allocation.csv"
done
"$python_bin" /tmp/gpui-gamut-reference/source_guard.py /tmp/gpui-gamut-source-pins.json check
