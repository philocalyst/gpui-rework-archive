#!/bin/sh
set -eu

site_root=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
manifest="$site_root/wasm/Cargo.toml"
artifact="$site_root/wasm/target/wasm32-unknown-unknown/release/gpui_site_examples.wasm"
destination="$site_root/static/wasm/gpui_examples.wasm"

cargo build --manifest-path "$manifest" --target wasm32-unknown-unknown --release
cp "$artifact" "$destination"
printf '%s\n' "Wrote $destination"

(
  cd "$site_root/wasm/gpui-demo"
  NO_COLOR=true trunk build \
    --release \
    --public-url /components/gpui-demo/ \
    --dist "$site_root/static/components/gpui-demo" \
    index.html
)
printf '%s\n' "Wrote $site_root/static/components/gpui-demo"
python3 "$site_root/scripts/record-wasm.py"
