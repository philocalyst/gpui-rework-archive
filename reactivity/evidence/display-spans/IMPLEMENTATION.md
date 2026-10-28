# First executable model boundary

The Python producer maintains per-node geometry for a selected dependency
closure, with a separate recursive full-tree oracle. It still gathers preorder
and rebuilds rank/next/span metadata by scanning the tree each update. These
visits are explicitly charged. This is a first representation comparison, not
an implemented incremental tree-to-GPU engine. Structural changes conservatively
damage all paint support; this overdraw is also charged. Public Win snapshots
are full copies and have no prepared-subtree export, so the public adapter
cannot demonstrate direct production identity-to-GPU addressing yet.

Packed layout preserves physical subtree spans in its logical record stream;
compression means actual payload bytes require page-directory resolution.
Paged layout uses a stable slot per identity and generation, with paint-order
next links. Subtree start is directly addressable; its extent is traversal,
not one physical pointer range. Both retain expanded CPU canonical mirrors in
this first comparison. The cost ledger includes that mirror; compressed GPU
live bytes alone are not a total-memory saving.

Codec: 32 rows x 12 u32 columns. Per column base, bit width, word offset;
fixed-width bitpacked deltas, no floating conversion. Header 148 bytes, raw
escape 1540 bytes; at most two data-word reads per field. Integer axis-aligned
opaque rectangles only; zero-alpha containers. This does not compress general
GPUI text/resources/floats and must reject unsupported public trace geometry.

Publication: append-only immutable encoded pages, COW 32-way leaf directories
and 32-way root. Bounded to32768 logical slots. Each descriptor is64 bytes,
but uploads also include changed blocks and copied directory pages. No arena
reclamation yet: retained-version growth is a deliberate counterexample to
claiming bounded memory. GPU bridge allocates the trace's full high-water
arena, uses queue.write_buffer staging, and waits for each readback completion.
It tests real Vulkan decoding/repair, not persistent coherent shared memory or
overlapping frames. Stale descriptors reject pixel mutation by comparing
candidate generation with current eligible generation. Real GPUI token tests
also exercise failed-newer preservation. Synchronization costs are reported;
serialized readback is a correctness oracle, not a performance workload.

No production shipping changes. BBTree's private async executor is not copied:
these bounded page addresses can be fetched in batches, but no measured miss
latency currently warrants adding runtime state. Shared cold metadata and
bounded decode are the first testable mechanisms. Solid/Ripple inform explicit
version authority and retained old output, not permission to discard dependency
closure or to acknowledge unpresented candidates.

Initial frozen2c4b9207 build failed E0308: wgpu30 pipeline layout expects optional group entries. Corrected to Some(&layout); no model or protocol change. Initial logs and empty source guard retained externally.

Corrected053f0fa8 public trace rejected a test assumption: a singular axis-aligned rectangle is accepted as empty, rather than producing the rounded-shape error seen in the earlier paint fixture. Preserve that failure; use an explicitly nonfinite transform for the failed-newer-request witness. This proves rejection preserves the prior eligible token; it does not claim a committed preparation failure.

3187587c public trace passed, then model extraction failed because semantic
snapshot bounds conservatively expand exact raster bounds (e.g. y3.99999976
for a y4 pixel edge). Do not round or weaken the pixel oracle. The corrected
adapter uses this fixture's explicit one-opaque-rect-per-node preorder contract,
validates exact translation and enclosure by semantic bounds, and retains the
exact sampled rectangle plus independent GPUI pixels. This is fixture-specific
association, not a general stable draw identity API. Original failure preserved.

9737af6b passes172 exact GPU frames/132 codec cases/Clippy, but ledger review
rejects its public structural coverage: EXTRA was incorrectly declared direct
despite an ordinary Rust conditional read, so insertion/removal were no-ops.
Correct to existing Sources::field, assert9->10->9 nodes plus owner reruns,
and compare every public candidate to a fresh full View reconstruction.
The original passing numerical cohort remains with this limitation.
Also preserve actual GPU readback bytes, explicitly charge all six full
metadata construction passes and the entire expanded CPU canonical mirror
materialization (previous changed-row count described wire differences only),
and validate generational handle rejection. No fixed workload or pixel gate
is weakened; public structural work is strengthened.
