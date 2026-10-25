#!/usr/bin/env bash
set -euo pipefail
aud="$(cd "$(dirname "$0")" && pwd)"
"$aud/sync-production.sh"
cargo test --manifest-path "$aud/Cargo.toml" --test smoke
