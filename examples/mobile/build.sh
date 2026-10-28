#!/usr/bin/env sh
set -eu

here=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
case "${1:-}" in
  android)
    shift
    exec "$here/android/build.sh" "$@"
    ;;
  ios)
    shift
    exec "$here/ios/build-rust.sh" "$@"
    ;;
  *)
    echo "Usage: $0 {android|ios} [platform build options]" >&2
    exit 2
    ;;
esac

