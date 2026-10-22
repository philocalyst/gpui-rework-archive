# Retained paint coupling evidence

Source: `05690b91d4`, based on frozen direct styles `fb2f56387a` and the
already-reviewed substrate (local equivalent `76a6627e15`, main `d4d63170ba`).
No source or artifact was exchanged for a timing run. There was no timing run.
All source and emitted consumer hashes are recorded in `manifest.json`.

The implementation is described in `crates/gpui/PAINT_PATCH.md`. It adds no
Runtime, Node, Presented, Prepared or Canvas fields. Metadata grows by 8 bytes.
A paint-only owner newly needing Metadata pays the entire 256-byte box, plus a
112-byte PaintState, 16 bytes per eligible field and 8 bytes per sink. The minimal
one-field/one-sink cold charge is therefore 392 bytes, in four allocations.
Full capture temporarily owns an 8-byte pair per sink. Each of two reusable edit
arrays pays 20 bytes per reserved element. Scratch capacity above 4 times current
field demand is discarded; replacement rebuilds and drops obsolete state.

The same registered-source one-node fixture measured 6,260 retained bytes with a
literal color and 7,124 with a bound color, an 864-byte difference comprising the
392-byte paint state plus 472 bytes of existing source/fanout ownership. Mount
requested 41 versus 51 allocations. The third warmed source edit requested zero
allocations and zero bytes; this scoped fixture does not include Wgpu queue or
OS event/presentation allocation behavior and does not prove all style-diversity
cases allocate zero.

PaintRenderer adds a 24-byte map header on GPU cohorts; NativeHost stays 680
bytes. GpuSurface becomes 1,080 bytes. The existing GPU map costs 12 bytes per
reserved site. The borrowed indexed-or-bound guard grows from 40 to 48 stack
bytes and eliminates a second native Vec/header/color array. Indexed native
validation and commit each binary-search the map, so their work is
O(k log bound sites). The source/Canvas paint staging and commit is O(k) after
one field lookup. Ordinary source admission costs are unchanged. Full map
capture sorts its existing allocation, without a separate requested-index Vec.

Validation:

- 368 default GPUI tests/docs; five new public color/P/KeepP cases.
- 37 actual Vulkan readback tests, 8 GPU units and one compile-fail doc.
- Adjacent identical commands retain separate paint groups; changing either or
  both matches independent full GPU rendering and CPU Canvas replacement.
- Consumer transition test compares to independent full trees: several color
  candidates, pending full C plus color, failed later visual preparation, and
  live focus. Pure color publication has zero changed-node indices.
- Actual native Todo script on private Xvfb :108 passes five policies. Its
  `with_paint_scene -> GpuSurface::render_paint` fixture compares SDR and RGBA16F
  texture bytes to a separate, fresh full GPU renderer. It exercises same-alpha
  patching, coalesced-token-gap full fallback and alpha/topology fallback.
- Strict all-target GPUI/GPU Clippy with X11, Wayland and Vulkan tests passes.
- Five public consumer tests pass when compiled at opt-level 3.

The initial native test demanded exact CPU bytes for every partial-coverage SDR
sample. It failed at a rounded edge by one blue byte (178 versus 179), an existing
CPU/GPU conversion difference. That original log is retained. The corrected
primary oracle demands exact equality against an independent full GPU renderer;
the separately retained CPU check uses the existing one-byte SDR / one positive
half-code HDR scope for the selected nonnegative fixture colors. No production
numeric behavior was changed, and there is no universal cross-device byte claim.
An early public fixture also expected x=7 exactly; outward bounds were
6.9999995. It now compares exact bounds to an independently fully prepared owner.

Actual consumer codegen used the command in `codegen.txt`: opt-level 3 public
test consumer, dev-profile dependencies, no LTO, debug assertions disabled. The
initial range getter still had a per-sink GOT call to its 77-byte outlined body
(with additional bool::then closure calls in the dev dependency). The small
getter gained `#[inline]`. `index-before-inline.s` preserves both prior call
sites, and its full assembly hash is retained. The final emitted consumer has
zero calls to PaintState::index and two PaintState::begin call sites, one per
model monomorph. `consumer-after-inline.s` and `callee-sizes.txt` retain the
setup evidence. This is a code-generation observation, not a latency claim.

CPU raster still rebuilds disposable bins. Grouped text damage uses its retained
clip. Coalesced complete-token gaps may rebuild the full GPU packet; this is not
an accumulated GPU delta. Source-only, ordinary literal owners create no paint
state allocation. No new model sharing, ambient state, per-node pointer, scene
clone or immutable-pixel overlay was introduced.
