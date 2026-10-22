#!/usr/bin/env bash
set -euo pipefail
# Build the pinned upstream protocol implementation, using a screen-iterator shim
# in place of the otherwise unnecessary xcb-util dependency. No protocol code is
# replaced. Supply existing local XCB include/library directories.
fixture_dir=$(cd "$(dirname "$0")" && pwd)
: "${XIM_SOURCE:?path to checkout fcitx/xcb-imdkit 621048bd50e8f3cbf52335f824f7b4d708a21b14}"
: "${XCB_INCLUDE:?XCB include path}"
: "${XCB_LIB:?XCB library path}"
: "${XIM_BUILD:?separate output directory}"
[[ $(git -C "$XIM_SOURCE" rev-parse HEAD) == 621048bd50e8f3cbf52335f824f7b4d708a21b14 ]]
mkdir -p "$XIM_BUILD/shim/xcb"
cat > "$XIM_BUILD/xcbimdkit_export.h" <<'HEADER'
#define XCBIMDKIT_EXPORT
#define XCBIMDKIT_NO_EXPORT
#define XCBIMDKIT_DEPRECATED_EXPORT
HEADER
cat > "$XIM_BUILD/shim/xcb/xcb_aux.h" <<'HEADER'
#include <xcb/xcb.h>
static inline xcb_screen_t *xcb_aux_get_screen(xcb_connection_t *c, int n) {
    xcb_screen_iterator_t i = xcb_setup_roots_iterator(xcb_get_setup(c));
    while (n-- && i.rem) xcb_screen_next(&i);
    return i.rem ? i.data : 0;
}
HEADER
sources=()
for name in parser ximproto imdkit protocolhandler message common imclient clientprotocolhandler encoding xlibi18n/lcCT xlibi18n/lcUTF8 xlibi18n/lcCharSet; do
    sources+=("$XIM_SOURCE/src/$name.c")
done
"${CC:-cc}" -shared -fPIC -O1 -D_GNU_SOURCE -I"$XIM_BUILD" -I"$XIM_BUILD/shim" -I"$XIM_SOURCE/src" -I"$XIM_SOURCE/uthash" -I"$XCB_INCLUDE" "${sources[@]}" -L"$XCB_LIB" -Wl,-rpath,"$XCB_LIB" -lxcb -o "$XIM_BUILD/libxcb-imdkit.so"
"${CC:-cc}" -O1 -I"$XIM_BUILD" -I"$XIM_SOURCE/src" -I"$XCB_INCLUDE" "$fixture_dir/server.c" -L"$XIM_BUILD" -Wl,-rpath,"$XIM_BUILD" -lxcb-imdkit -L"$XCB_LIB" -Wl,-rpath,"$XCB_LIB" -lxcb -o "$XIM_BUILD/server"
sha256sum "$XIM_BUILD/libxcb-imdkit.so" "$XIM_BUILD/server"
