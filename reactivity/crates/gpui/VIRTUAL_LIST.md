# Uniform virtual lists

`uniform_list(ListId, &impl ItemSource, row_height).h(viewport_height)` describes
the rows intersecting a finite logical viewport by default. The source and deferred
row builder are borrowed during description and discarded before retention.
There is no parent-model clone, shared mutable scroll handle or giant spacer.
An optional `.overscan(rows)` retains up to that many extra keyed rows on each
side, clamped to the source bounds. This is synchronous bounded realization,
not an adaptive asynchronous row cache. The existing 4096-row limit includes
the buffer; even `usize::MAX` is clamped before admission. `visible_range` names
logical viewport slots, while `realized_range` includes the buffer. The first
visible key remains the anchor across source edits.

`ItemSource` supplies `len`, `key`, `index_of` and `row`, with a default
`is_empty`. `ItemKey` is an exact u64 data identity. The source owns indexing;
the framework does not scan all rows to find a key. Realized keys and lookup
agreement are checked before reconciliation. Source methods must describe one
coherent snapshot. `ListId` is window-unique in this first version and defines
the key domain: unrelated catalogues or reused IDs require a new list ID.
Repeated contained components configure distinct list IDs.

`Win::scroll`, `scroll_to_index`, `scroll_to_key` and native wheel delivery use
the same exclusive owner path. Scrolling changes the prepared scene/token,
without changing the catalogue's source epoch. A recording window acknowledges
the returned scene token only after its adapter presents. Key lookup and input
target resolution require the current acknowledged cohort. Ordinary borrowed
inspection can retain the older acknowledged sheet while a candidate waits.

`list`, `list_state`, `list_item` and `Query::within` expose the ordinary public
testing surface. A visible keyed row retains identity across reorder/prepend;
with default zero overscan, an offscreen or removed row loses its capability,
and returning rows receive fresh targets. With overscan enabled, a row still
in the realized buffer preserves identity while offscreen queries/actions are
rejected and focus is cleared. Returning to visibility within that buffer can
make the same target usable again. Leaving the buffer retires identity
permanently. There is no historical table of every visited key. List/item
roles are published with clipped geometry. Buffered logical slots have empty
paint/input clips, so outward numerical envelopes at touching boundaries cannot
publish them. Count/range/key metadata are a
foundation for an accessibility adapter; this is not a platform accessibility
tree, focus-navigation or screen-reader implementation.

Extent/offset calculations use f64; only rebased local row coordinates enter
layout and paint. Both each row slot and the list viewport clip descendants.
The initial limits are one billion items, 4096 realized rows per list, extent
at most 2^40 logical units, row height at least 1/64 and viewport/local clip
coordinates below one million. Padding/gap on the viewport and rotated/sheared
viewport transforms are explicitly unsupported. Reflections and fractional
scales are supported. Raster clips lower to quarter-pixel cutoffs using the
ordinary canvas's finite inverse predicate, including ties and collapsed
forward edges. This lowering is specific to the current 4×4 sampling quality;
a future sampling profile must re-lower the original geometry.
Pointer routing uses outward clipped bounds plus the original ancestor inverse
predicates, preserving off-lattice input independently of raster lowering.
Unclipped local rects and absolute transforms remain available internally for a
future accessibility adapter; clipped query bounds are not UIA full bounds.
Auto-height/nested measured
viewports need a future parent-layout pass; retaining the borrowed descriptor
until materialization leaves that path open without an eager iterator API.

## Public example and evidence

`cargo run -p gpui --features x11 --example library -- --cpu` opens a real
250,000-recording catalogue surface. Its app-owned catalogue module stores IDs
and a reverse index (4,000,000 requested bytes at initial 250K size on 64-bit
targets). It sends play requests to app state, reverses order and prepends rows;
it does not decode audio or claim to port the complete player. The same model
runs in `tests/library.rs` through `Application::demo().open`, including
contained-owner projection and zero-allocation borrowed query tests.

The protocol is informed by Hummingbird commit
`e15e8ba0ef6ff5445294030d373e3c8ccc7d780c`, particularly its sorted identifier
set, viewport/prefetch row construction and keyed row actions in
[`table.rs`](https://github.com/hummingbird-player/hummingbird/blob/e15e8ba0ef6ff5445294030d373e3c8ccc7d780c/src/ui/components/table.rs#L730-L790).
The fixture catalogue is independent app code, not an upstream audio/database
dependency.

`retained_list virtual|eager N` benchmarks declaration, layout, shaping and
command recording for 100/1000/10000/250000 IDs. It first compares every CPU
pixel against independently materialized visible eager rows, and asserts the
expected nonempty semantic/draw counts. Preflight warms code and allocator
pages; timed owners have fresh caches. It does not time native submission.
250K eager is explicitly reported as exceeding the documented node limit,
without allocating a deliberately doomed eager tree. Source ID storage,
retained/peak requested allocation deltas, allocation counts, measured work and
warm scroll costs are separate columns. These are not RSS/driver/compositor
measurements. The final capture is [evidence-uniform-list.csv](evidence-uniform-list.csv):
three alternating fresh processes per mode/count on this x86_64 Linux container,
Rust 1.97.1, Cargo's default release profile. All preflight pixel and semantic
assertions passed. Median mount results (microseconds; requested allocation
bytes exclude the separately charged source ID vector):

| IDs | Virtual µs | Eager µs | Virtual retained bytes | Eager retained bytes |
| ---: | ---: | ---: | ---: | ---: |

| 100 | 394.8 | 1,507.0 | 59,979 | 150,223 |
| 1,000 | 445.9 | 14,084.4 | 59,979 | 1,265,727 |
| 10,000 | 375.0 | 139,493.6 | 59,979 | 13,425,383 |
| 250,000 | 495.3 | node limit | 59,979 | — |

Virtual mount peak was 300,085 requested bytes and 945 allocations in each
case. Eager peaks were 396,166 / 1,603,318 / 14,679,462 bytes at 100 / 1K / 10K
IDs. Every valid case painted the same 143 glyph draws; virtual retained 27
semantic nodes (13 row slots and 13 texts plus the viewport) and made 39
measurement calls, while eager retained N+1 nodes and made 3N measurements.

Virtual warm-scroll medians over 32 jumps were 274–278 µs. The 250K source ID
vector consumes another 2,000,000 requested bytes. The framework retained no
visited-key history: cumulative requested allocation deltas over those jumps
were between -64 and -32 bytes, with about 254 KB additional peak scratch.
These fixed-text fixture results establish bounded realized work and storage;
slot wrappers, key validation and clip lowering still add costs for small lists.
