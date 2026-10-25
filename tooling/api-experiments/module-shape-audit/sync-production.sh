#!/usr/bin/env bash
set -euo pipefail
repo_root="$(cd "$(dirname "$0")/../../.." && pwd)"
aud="$(cd "$(dirname "$0")" && pwd)"
cp "$repo_root/crates/gpui_macros/src/reflect_module.rs" "$aud/macros/src/reflect_module.rs"
rm -rf "$aud/macros/src/reflect_module"
cp -R "$repo_root/crates/gpui_macros/src/reflect_module" "$aud/macros/src/reflect_module"
