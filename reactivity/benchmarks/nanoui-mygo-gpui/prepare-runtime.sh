#!/usr/bin/env bash
# Source once before running GTK-backed Go/Zig binaries on this NixOS host.
if [[ -z "${LUNA_INTERPRETER:-}" || -z "${LUNA_LIBRARY_PATH:-}" ]]; then
  GTK_STORE=${LUNA_GTK_STORE:-/nix/store/1fl4qsghsryd5f764m5v64vlxdz9d8qx-gtk+3-3.24.52}
  CAIRO_STORE=${LUNA_CAIRO_STORE:-/nix/store/c4q6wnp14xf0npalyiqsfp1c99y4qhcx-cairo-1.18.4}
  CLOSURE=$(nix-store -qR "$GTK_STORE" "$CAIRO_STORE")
  GLIBC_STORE=$(printf '%s\n' "$CLOSURE" | awk '/-glibc-[^/]+$/ { print; exit }')
  [[ -n "$GLIBC_STORE" ]] || { echo "could not find glibc in the GTK/Cairo Nix closure" >&2; return 2; }
  CLOSURE_LIBS=$(printf '%s\n' "$CLOSURE" | while IFS= read -r path; do
    if [[ -d "$path/lib" ]]; then printf '%s:' "$path/lib"; fi
  done)
  export LUNA_INTERPRETER="$GLIBC_STORE/lib/ld-linux-x86-64.so.2"
  export LUNA_LIBRARY_PATH="${CLOSURE_LIBS}${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
fi
