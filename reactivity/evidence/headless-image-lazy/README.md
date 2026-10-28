# Allocate diagnostic pixels when requested

Source `83aab2dc88060c2245f82fc9f28f789201a858b5` removes the eager
headless framebuffer reservation from mount and resize. Automatic headless
acknowledgment already publishes canonical commands without rasterizing them.
The existing fallible `with_pixels` path now allocates the optional image on its
first actual use; native windows already used command recording. No new state,
cache, dependency, API or header is introduced.

The added owner test checks exact red/blue pixels through edits and resize,
automatic source/presentation coherence, deferred resize backing, and that pixel
diagnostics do not grant presentation authority. All **490** GPUI cases/docs
pass with accessible desktop/X11/Wayland/parallel/verified layout (25 ignored),
as does strict GPUI all-target Clippy. These counts overlap prior campaigns.

## Matched retained allocation fixture

The identical existing blank-owner/inspector unit fixture runs in fresh
processes against two frozen actual Cargo test binaries: `8ea8b9d76a` and
`83aab2dc88`. Both use the full desktop/X11/Wayland/parallel/verified-layout
feature profile. `pair.json` records their SHA-256 values, commands and results;
the baseline's complete source/executable provenance is preserved in
`../native-text-integration/native`. The capture script guards current source
and both executables before/after each case.

| 800×560 owner, no pixel diagnostics | Before retained Rust heap | After retained Rust heap | Before allocations | After allocations |
| --- | ---: | ---: | ---: | ---: |
| Plain headless |1,797,652 B |5,652 B |22 |21 |
| Existing 17-node inspector |1,844,408 B |52,408 B |180 |179 |

Both remove exactly **1,792,000 B and one allocation**, the RGBA8 image.
The inspector's extra font/text/layout/paint cost stays 46,756 B. A separately
filtered default-feature test reports 5,636 B/21 allocations for the plain owner
and 52,392 B/179 for the inspector; the full feature profile above adds 16 bytes
to each owner. These are retained current-thread Rust allocator measurements,
not peak memory, RSS, native window memory or latency. The real window already
records without this optional image, so this is not a native blank-window win.

Once explicitly requested, diagnostic backing stays available until resize or
owner retirement. Pixel allocation can fail at that fallible access rather than
mount; canonical commands and acknowledged semantics remain available. No new
eager rasterization, implicit native acknowledgment or interior mutability is
introduced.

The shipping source ledger at this freeze is **27,692** non-test/comment-free
code lines, including 13 build-script lines: four fewer than `8ea8b9d76a`.
Tests, vendors, tools and ports remain separately charged. The subsequent shared
GPU/color/catalog slices have independent source pins and do not inherit this
snapshot's counts or allocation qualification.
