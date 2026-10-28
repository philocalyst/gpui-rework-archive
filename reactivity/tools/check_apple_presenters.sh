#!/usr/bin/env bash
set -euo pipefail
if [[ "$(uname -s)" != Darwin ]]; then
    echo 'Apple presenter lifecycle checks require macOS; no platform assertions ran.' >&2
    exit 2
fi
presentation_workspace=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)
cd -- "$presentation_workspace"
cargo check --locked -p gpui --features desktop
# These binaries deliberately use harness=false: AppKit belongs on process main.
cargo test --locked -p gpui_presenter_tests --test apple_metal_layers --test apple_software_layers
