#!/bin/sh
# Build from the repository root or any other working directory.
set -eu
site_root=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
command -v zola >/dev/null || { printf '%s\n' 'Install Zola 0.23.4 first: https://www.getzola.org/documentation/getting-started/installation/' >&2; exit 1; }
zola --root "$site_root" check --skip-external-links
zola --root "$site_root" build "$@"
python3 "$site_root/scripts/check-site.py"
