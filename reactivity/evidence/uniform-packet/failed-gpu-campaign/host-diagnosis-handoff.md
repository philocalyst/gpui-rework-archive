# Read-only host diagnosis after the failed fixed campaign

No new production code, profiling counters, builds, timed repetitions, or SIMD
implementation were added. This is structural attribution to be tested, not a
claim that raw submit clocks isolate any one CPU body. Renderer::render includes
validation, packing, WGPU queue writes/bindings/submission and driver work.

The strongest localized difference is the coverage proof. Shipping full_tile
rejects translucent solids before clip/corner arithmetic. In a81 bin_draw,
translucent solid geometry must establish CONSTANT_TILE, so every still-constant
tile executes the full f64/packed-f32 envelope proof. At 512x256 there are 512
tiles. Each of the eight full layers covers every tile: 4,096 complete proofs
per frame in a81 versus 4,096 cheap alpha rejections in shipping. Each complete
proof checks four corners by two axes, with independent packed and canonical
guards. The measured paired host medians are 2.288–2.420x shipping for these
four SDR/HDR static/motion cells. Layer+text host medians are 2.004–2.328x;
the same full-layer prefix still incurs those proofs before text makes affected
tiles sampled. This connection is substantially stronger than assuming all
1.284 aggregate host cost comes from word comparisons.

Masked text, images and rounded sources do not enter this geometric proof.
Rounded host medians are 0.915–0.995x; ordinary text 1.025–1.034x; image+text
1.057–1.174x. The two 32K cases are covered at the end by one opaque rectangle,
so both versions still perform its 512 tile proofs and all preceding validation.
Grouped 32K host medians are 1.073–1.120x, singleton 32K 1.004–1.019x.
Their different regressions remain unresolved. All per-frame tail failures are
retained; they cannot be explained away by these median patterns.

Pass inventory from exact sources: both versions scan groups to size records,
validate every placement, visit all logical draw/tile pairs forward, normalize
tile ranges, visit draw/tile pairs in reverse for CSR fill, then scan tiles for
diagnostics. Shipping separately walks all placements to patch resources;
a81 folds this patch into reverse CSR fill, so that extra shipping placement
walk was already removed. Both retain vectors, clearing/resizing them between
frames; there is no source evidence of a fresh heap allocation for each tile
or placement on every warm frame. WGPU creates a fresh bind group and submits
every public render in both versions. Atlas growth may rebuild/revisit masks;
image relocation may force full record/image upload. Those cold paths must not
be generalized to warmed unchanged input.

a81 keeps the resident record vector as its mirror. It still compares common
words and each placement's local word, compares the metadata common-address
word, then compares finalized resource metadata in reverse. That can be two
metadata comparisons per placement even when nothing uploads. This is a real
O(draws) path to examine for the 32K regressions; it is not yet measured as the
cause. Borrowed word comparisons already generate SIMD16B in historical linked
code. Do not add handwritten SIMD merely to restate that operation.

The best first formulation to derive is a conservative whole-visited-bounds
solid certificate, with the existing per-tile test as fallback. It can delete
4,096 repeated corner proofs for the measured full-layer scene without changing
CSR layout or introducing shader branches. The certified rectangle must be
the exact union of tiles visited by visit's integer casts/ranges, including
clipped final row/column, rather than the geometry AABB alone. Continuous clip
containment and sample corners at +1/8 and -1/8 must remain conservative.
Packed margins and canonical guards are affine bounds over nonnegative device
coordinates, but evaluating only outer endpoints is not by itself a floating
point proof. Derive outward arithmetic/error bounds, including endpoint and
guard rounding, or conservatively reject; preserve current sign-safe opacity
as the only authority to drop a backdrop. A globally covering translucent draw
must not restore a previously lost constant-coverage tag. Row intervals could
generalize this to rotated geometry with O(rows) certificates; they still do
not delete CSR visits and need exact edge verification/conservatism.

The shared-full-bounds-prefix proposal removes duplicate references and visits,
which is a separate benefit. The measured shared-image fixture uses eight
128x128 placements, not full-canvas images; the original sampled-only initial
prefix does not accelerate that fixture or the opaque-root-first common case.
Including leading solids makes the existing OPAQUE_PREFIX flag ambiguous: a
cutoff inherited from a global opaque root must not be interpreted as a local
first glyph being opaque. Distinguish a local opaque cutoff from a global
root, keep clear-based first-opaque arithmetic, suppress the global prefix only
when a later local opaque certificate retires it, and handle empty local ranges.
Logical reference caps/stats must still charge full G*T fanout even if only G
addresses are stored. Resources/corrections must still be admitted and patched;
failed preparation must revoke residency. No shader-loop expansion is justified
until these semantics and a representative address/visit saving are derived.

The final diagnostic tile walk can fold into existing CSR normalization, since
surviving counts and proof/cursor bits are already known there; reverse fill
only changes the start offset. Preserve direct-uniform range[0] addresses.
Row chunks can remove per-tile division/modulo for clipped areas, but this is
lower priority than deleting complete geometric proofs. Any later SIMD prefix
scan must share the same semantic kernel/fallback, use u64 aggregate evaluation
counts, and preserve proof bits/overflow caps. No size or speed forecast follows.

Skipping ordinary public render on pointer/borrow identity is unsound: prepared
headers are public and mutable, and unchanged packet words do not alone prove
unchanged private ABI plane offsets, bounds, clear/config or resource topology.
Native's explicit admitted packet/token redraw already provides a stronger
authority for that route. A new structural equality proof would need to earn
its validation/ownership cost and cannot silently reuse the public borrow.

Handoff questions: (1) prove a whole-bounds certificate with floating-point
outward bounds, then row intervals only if needed; (2) isolate whether residual
32K host cost comes from word replacement/resource patching or backend submit;
(3) derive solid+sampled shared-prefix cutoff encoding without extra shading;
(4) preserve exact HDR signed-zero arithmetic and all admission/residency fault
controls before measuring any next formulation. No implementation is authorized
by this note, and the fixed failed campaign must never be relabeled a pass.
