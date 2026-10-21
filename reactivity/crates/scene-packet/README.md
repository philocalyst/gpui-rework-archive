# Prepared grouped paint packet

`gpui_scene_packet` is a reviewed replacement candidate for the canvas's
expanded glyph-command representation. It owns prepared typed lanes and an exact
painter-order directory. It is **not integrated** and should not be copied beside
the production command list on every frame. Its only runtime dependency is the
existing core geometry crate. There is no unsafe code, value bag, string-based
property model, per-glyph allocation, or per-glyph lease clone.

`Builder<R>` accepts prepared-paint inputs, rectangle operations, resource leases,
and glyph runs. Each glyph keeps a distinct local rectangle. A run shares one
inverse mapping, clip and linear premultiplied color; sampling subtracts that
glyph rectangle's origin after mapping the device sample to the common local
space. Moving the local glyph origin does not require another inverse. The
constructor retains the scalar canvas's f64 inverse arithmetic, admission domain
and one-device-pixel outward bin guard. Bounds are clipped to the checked
16,384-pixel viewport and use four u16 coordinates.

Resources use opaque u128 keys, large enough to losslessly represent the existing
112-bit face/glyph/size identity. A hash is not an identity. Duplicate registration
always rejects and returns the supplied owned lease; it never substitutes the
first resource. The caller provides namespace/revision-correct keys and immutable
resource contents. Public glyph inputs name keys; only the builder creates local
u32 resource indexes. One lease is stored per registered key. Finalization prunes
unused registrations and remaps indexes using a temporary u32 lane, which is
charged in preparation peak/allocations and then released. No historical unused
resource leases survive. Masks are borrowed through `&R`; using `Arc<Raster>`
requires no clone during traversal. Mask-body byte admission remains the renderer's
responsibility because a generic lease cannot reveal its owned/referenced heap.

The builder validates geometry, counts, resource existence and ordered ranges.
A placement rollback guard handles rejected runs and iterator panic without
publishing partial ranges/order or allocating in Drop. Finalization consumes the
builder, releases its temporary key map, and returns immutable boxed lanes.
`Packet::operations()` yields rectangles or runs in exact painter order; each run
offers an exact-length borrowed glyph iterator. Immutable factory-produced ranges
are ordinary checked slice indexes, never byte offsets or unsafe casts.

## Measured representation

On x86_64 Rust 1.97.1:

| Record | Bytes |
|---|---:|
| f1dd1a1aad canvas Command | 136 |
| Same fields with u16 bounds only | 112 |
| Common inverse + clip + color | 80 |
| Run: common + start/count | 88 |
| Placement: local rectangle + resource index + u16 bounds | 28 |
| Rectangle: local rectangle + common + u16 bounds | 104 |
| Order directory entry | 8 |
| Resource key + Arc lease, including u128 alignment | 32 |
| Packet object, including boxed-slice metadata + viewport | 88 |

`storage()` includes every retained lane and the object header. Finished boxed
slices have no extra Vec capacity. Generic resource bodies and allocator
bookkeeping are separately accounted; the benchmark measures the actual requested
Arc-mask body allocations with the test allocator, including control blocks,
instead of assuming a private Arc layout. Preparation also charges key-map nodes,
input-to-output resource remapping and any final shrink allocations.

## Evidence and losing regimes

Six tests cover mixed rectangle/text order, different local glyph origins under
scale/shear, inverse/sample parity, stable keys despite resource reordering,
unused-lease release, duplicate ownership return, admission limits, rejected and
panicking runs, zero-allocation traversal, Arc reference counts, and a retained
allocation ledger equal to the actual allocator count. Debug/release tests and
strict Clippy pass. `allocation-counter` is a dev-only dependency.

The release microbenchmark uses one background rectangle, cached immutable
8×8 masks, 64 shared masks unless noted, and the same scalar bounds computation
in both paths. Every operand, bounds, inverse and resource lease is compared with
the expanded command oracle before timing. The old path owns one Arc per glyph;
the packet registers one Arc per resource. Shaping, font-cache lookup, rasterization,
binning, pixel rendering and GPU upload are excluded from both paths. Preparation
timings include creation and destruction; scan timings visit prepared operands and
one mask sample without cloning. These are shared-cloud CPU microbenchmarks, not
application latency results. Compiler: Rust 1.97.1, release defaults, AMD Ryzen
7 3700X. Full allocations, peak bytes and timings are in `evidence/packet-bench.csv`.

| Case | Old resident bytes | Bounds-only baseline | Packet bytes | Old/packet prepare ms | Old/packet scan µs |
|---|---:|---:|---:|---:|---:|
| 48 labels × 10 glyphs | 65,440 | 53,896 | 20,296 | 0.0288 / 0.0336 | 0.617 / 0.809 |
| 1,000 glyphs, 100 runs | 136,160 | 112,136 | 39,848 | 0.0591 / 0.0627 | 1.279 / 1.762 |
| 32,000 glyphs, 1,000 runs | 4,352,160 | 3,584,136 | 994,248 | 2.046 / 1.793 | 59.666 / 52.268 |
| 32,000 unique transforms | 4,352,160 | 3,584,136 | 3,970,248 | 1.968 / 3.235 | 59.142 / 107.999 |
| Unique transforms and masks | 4,352,160 | 3,584,136 | 4,992,200 | 1.928 / 8.870 | 83.127 / 114.677 |

Mask bodies add 5,120 bytes to each shared-mask candidate, and 2,560,000 bytes to
each unique-mask candidate. They are not free because the fixture also holds
them. The packet is slower for small labels despite saving retained bytes, and
loses both memory and CPU in the unique-everything case. Its key index costs
5,339 preparation allocations there versus one expanded-command allocation. No
universal compression or speed advantage is claimed.

Reproduce once the crate is in a complete workspace:

```sh
cargo test -p gpui_scene_packet
cargo clippy -p gpui_scene_packet --all-targets -- -D warnings
cargo run -p gpui_scene_packet --release --example packet_bench
```

## Integration gate

The one-shot Box packet demonstrates storage/borrowing invariants. Appending to a
retained Canvas after `pixels()` must not consume/shrink and reconstruct a packet
per render. Production integration should keep the same typed lanes in an owning
Vec draw list, expose an immutable borrowed packet view during rendering/export,
and preserve staged candidate admission without an output-buffer copy. It must
replace the expanded command authority while retaining `PreparedScene::draws()`
as a borrowed adapter for the GPU host.

CSR tile bins also need O(1) random draw addressing. Add a four-byte common-run
index to each placement (32 bytes total) and mint checked u32 rectangle/glyph draw
references. This prototype's current 28-byte placement is iteration-only; the
32,000-glyph candidate would pay another 128,000 bytes for that index. Re-measure
the integrated representation rather than quoting the smaller prototype size.
Check the glyph key before `TextSystem::raster` so existing packet resources skip
that service's Arc clone, not merely the final command clone. Preserve renderer
mask-byte caps and failure policy. Keep the unique-transform losing cases visible
instead of introducing an unmeasured adaptive representation.
