# First unified-representation comparison: executable, not integrated

Frozen source **a5d1888902** implements packed preorder and stable paged-slot
models, a bounded lossless block codec, a COW address directory, damage repair,
and a real Vulkan consumer of the compressed bytes. **172 frames have exact
GPU pixels and exact decoded words**, including16 frames from ordinary GPUI
public APIs across both layouts.132 codec cases include20 incompressible raw
escapes. Strict Clippy passes. Four one-word GPU mutants fail: root span384
pixel bytes, omitted old damage44, stale authority672, codec width8 canonical
bytes (that last mutant preserves pixels, so pixel-only validation misses it).

The unified architecture requested by the user is **still not implemented in
production**. No production files or application APIs change. This first pair
makes its remaining full scans, CPU mirrors, staging copies and version growth
visible. It supplies counterexamples and the next architectural choice, not a
ZGX performance result. This machine uses llvmpipe software Vulkan.

## The two representations

Both encode32-record blocks,12 u32 fields per record, with independent column
base/bit-width/offset headers. Values roundtrip bit-for-bit; one field reads at
most two packed data words, plus header/directory loads. Raw escape bounds
incompressible cost at1540 bytes for1536 raw record bytes. Two32-way directory
levels bound lookup for32768 slots. There is no global entropy stream to decode.

Packed: identity resolves to preorder rank; subtree is `[rank, rank+span)` in
the **logical** record stream. Compression turns physical addressing into a
block-directory lookup. Insertion shifts later ranks and topology references.
Paged: identity resolves to a stable slot and checked generation. Subtree start
is directly addressed, but members follow paint-order links across pages;
subtree length alone does not make those members a physical pointer range.

## Structural work, not timings

Same1024-node repeated scene; bytes include the64-byte descriptor.

| Change | Packed moved logical bytes | Paged moved logical bytes | Packed upload | Paged upload |
| --- | ---: | ---: | ---: | ---: |
| Leaf paint | 0 | 0 | 884 | 884 |
| Insert at first group's front | 49,056 | 0 | 15,248 | 1,416 |
| Remove next leaf | 48,960 | 0 | 14,624 | 940 |
| Move leaf across groups | 720 | 0 | 1,336 | 1,488 |

The moved-byte count is a logical relocation measure, **not measured Python
memcpy traffic**. Both prototypes actually materialize the complete CPU record
mirror and run six full metadata-construction passes. A leaf paint visits one
node in the geometry producer, then still materializes1024 records/49152 wire
bytes, scans6144 metadata entries, and compares2048 old/new damage entries.
These costs are not erased by the changed-row count of one/48 bytes. Python
object/container/allocator memory and cache misses are not measured; the
12-byte-per-live-identity ledger is a wire representation size, not HashMap
allocation. Adapter identity history is additional metadata, retained throughout
the trace. No total CPU memory saving follows from compressed-wire sizes.

Initial1024-record compressed pages plus directories occupy14528 bytes versus
49152 canonical bytes, but the CPU mirror remains. After12 updates the packed
arena retains66700 bytes and paged26364 bytes; live-directory payloads are15188
and15136. The GPU allocates each trace's full arena high-water size up front.
No page reclamation is implemented. A repeated update log grows without bound.
The nine-node public fixture needs904 live compressed/directory bytes versus
432 canonical bytes: fixed page/header costs lose for tiny trees.

## Ordinary public update, through actual GPU mutation

`Panel::COLOR` is an unchanged `Source<Panel, Color>` bound to `.bg(&color)`.
`Win::set(COLOR, WHITE)` reads one source and performs one exact update, with
zero owner reruns/descriptions/layout/paint passes. The named target identity
survives. The diagnostic adapter copies nine acknowledged snapshot nodes and
nine prepared rectangle draws; its fixture-specific checked preorder associates
identities with draws. This full-snapshot adapter is **not** a direct production
subtree export. The model visits54 metadata entries, materializes432 canonical
wire bytes and compares18 damage entries; the actual GPUI dependency-closure
node count is not exposed by its counters and is reported unknown.

One logical record changes48 bytes. It re-encodes a648-byte block, copies256
bytes of directory pages, and publishes64 bytes: **968 bytes in four actual
queue writes**, one command submission. Old/new support yields128 damaged
pixels; the GPU loops over9 records per damaged pixel,1152 record visits. This
is a verified shader loop bound, not a hardware cache counter. Full GPU decode
and two mapped readbacks are independent correctness instrumentation.

The branch-controlling EXTRA uses the existing `Sources::field` declaration;
public insertion/removal really change9→10→9 nodes, rerun the owner, and match
fresh full View reconstructions. Height change propagates layout to later
siblings. All public candidates match independently reconstructed CPU pixels.
An invalidated candidate uploads972 bytes but changes no retained pixels; the
next eligible descriptor restores the last visible output coherently. Disabling
that authority check changes672 pixel bytes. A rejected nonfinite transform
preserves the prior eligible token. That witness is a rejected newer request,
not a proven committed-preparation-failure path.

## Publication and lifetime boundary

Pages/directories are immutable append-only allocations; old bytes survive all
later publications. The descriptor contains an eligible version, root address,
logical count, layout and damage. Descriptor publication is fixed-size; building,
copying and decoding its reachable payload are separate work. wgpu uses portable
staging `queue.write_buffer`; it is **not a persistently mapped coherent shared
CPU/GPU structure**. Each frame has one submit and two completion waits for
readback. This serializes resource use; concurrent in-flight root leases, fence-
based page reuse, text/image/font resource retirement and backend-specific flush
requirements remain unimplemented. Resource fields are reserved/zero in these
rect-only models. Generation reuse is checked for model node handles.

## What this reveals

Neither extreme is sufficient. Packed spans lose locality of mutation on early
structural edits. Stable slots avoid relocation but lose physical subtree scans,
retain tombstones, and can upload more for a small cross-group move. Compression
wins on large repeated wire records but loses on tiny trees and adds bounded
loads. Constant descriptor size does not remove any of those costs.

The next executable hypothesis is an incrementally maintained ordered chunk
sequence with stable node handles, dirty-block journals and fence-owned COW
pages. Compare it against these two exact oracles. Test whether leaf updates
avoid the current full scans and whether page split/merge/reclamation costs
outweigh its scan locality. Separately challenge retained damage summaries and
resource leases. Only then test latency-hiding batches at independently ready
page reads; importing an async executor now would not solve the measured scans.

## Research connection and reproduction

BBTree's [inline columns](https://github.com/XiangpengHao/bbtree/blob/1b0201087102f81189da0c4cd5054a91c8d97d62/design/04-inline-key.md),
[prefix invariants](https://github.com/XiangpengHao/bbtree/blob/1b0201087102f81189da0c4cd5054a91c8d97d62/design/05-fence-key.md)
and offset-based file pages motivate compact hot data with explicit relocation
rules. Its [batch executor](https://github.com/XiangpengHao/bbtree/blob/1c72bd27994ed0a38694b029618e80115e22644f/design/12-batch-api.md)
overlaps dependent misses across independent operations; the documented
level-by-level variant is faster in its measured cases. Neither proves display
cache-hit improvements. Ripple's pinned compiled update grouping suggests
identity-preserving direct field writes; its async version checks and
[Solid's fetch-high/block-low article](https://www.solidjs.com/blog/async-solid-fetch-high-block-low)
inform separate prepared/eligible/visible states. They do not remove layout,
clip, ordering or old-damage dependencies. Exact local source hashes are in
`raw/research.json`.

Run `python3 verify.py` to rederive every actual GPU readback, independent codec,
paint order/subtree counts, damage coverage, upload ledger, four mutant witnesses,
source guards and executable/shader identities. `raw/run.py` records reproduction
commands and compiler environment. Preserved failures: wgpu layout type mismatch;
singular-rectangle rejection assumption; semantic bounds mistaken for exact
raster bounds; and the first apparently passing public structural fixture that
did no structural work. None is overwritten or counted as corrected coverage.
