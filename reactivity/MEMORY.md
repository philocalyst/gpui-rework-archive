# Memory from the first mapping to the last released image

The floor is a sequence of admitted capabilities, not one RSS number. A headless
source owner need not initialize Winit, a display connection, font discovery,
accessibility bridges, a GPU device or a worker pool. A visible native window
necessarily admits OS/compositor resources. Measure the increment at each step
instead of attributing all of it to a small Rust object.

The [platform research](docs/research-platform.md) pins source/contracts;
[CONCURRENCY.md](CONCURRENCY.md) specifies page ownership and release.
This is the selected accounting and experiment policy, not a measured claim of
near-zero native-window memory.

The current production cut implements software-first native startup, lazy font
rasterization and scoped borrowed shaping tables. It never loads a GPU driver in
explicit CPU mode; Auto also avoids probing on a device-less Linux host. The
canonical display list factors transform, clip and paint out of text placements,
and its GPU consumer uploads that grouped form directly. Each scene leases a
unique mask once, looking up its complete resource key before raster-cache access;
repeated placements perform no resource refcount operations. Mutable window state
has one exclusive owner, with no Rc/RefCell/Cell wrapper or target allocation table.

Certified zero-command solid frames on X11 go further: a checked server fill
needs no client transport pixels. Returning from a normal frame waits for actual
server completion before detaching/releasing its mapping. This removes a client
allocation, not the server's window or compositor backing. Other platforms retain
their normal CPU fallback. [Current scope and evidence](STATUS.md) distinguishes
these implemented savings from the more general policies below.

CPU membership has one lazy scratch owner. Recording-only Canvas is 488 B,
64 B below the earlier inline-scratch layout, with no scratch allocation. The
first CPU raster allocates an 80 B header plus its CSR bodies; active headers
therefore cost 16 B more. Bounds-only construction and containing-cache reuse
remove command reconstruction and repeated membership construction without a
second retained index. [Paired controls and losses](benchmarks/bin-miss/README.md)
separate this allocation ledger from native RSS and first-visible-window time.

## Four ledgers and one lifetime graph

| Ledger | Required quantities | Common hidden term |
| --- | --- | --- |
| Rust/application | Live payload, capacity/slack, allocator metadata/size classes, committed/reserved arenas, high-water scratch | Empty headers, sparse directories, stale capacity, queue payload backing |
| Process/OS | ELF file/load segments, virtual mappings, RSS/PSS, private dirty/shared clean, page faults, threads/stacks/fds | Libraries, TLS, font mmap, driver mappings, lazily committed stacks |
| CPU presentation | Scene/command/upload pages, swap/present CPU backing, cached layers/tiles, in-flight versions | A full retained image added to support damage |
| GPU/compositor/guest | Actual allocation/residency where observable, image/atlas/pipeline/staging heaps, import copies, compositor and web process attribution | Triple images, format promotion, hidden conversion and resource retirement |

Every reusable allocation has a creator, capacity, last-use boundary and release
owner. Count maximum concurrently retained versions, not just the current sheet.
Shared pages are reported once in a combined attribution plus each process's
RSS/PSS. Allocator calls do not count OS page faults, stack mappings or graphics
memory. Unobservable driver allocations are named unknowns, not zero.

## The capability ladder

Record incremental cold/warm bytes and first-use time for: source-only program;
empty headless app; native event loop/display connection; empty window; software
or GPU renderer; first font/text; IME/a11y/menu integration; one control; repeated
static screen; unique/dynamic screen; second/tenth window; embedded guest/webview;
hidden/minimized state; and complete teardown.

Native host features select X11/Wayland and decoration policy explicitly. Do not
compile or initialize Adwaita CSD just to obtain a minimal custom-framed window
when that capability is unused. Keep display-server compatibility requirements
separate from optional decoration. The complete Winit vendor remains source
material; only enabled target/backend code belongs in the final executable.
Vendoring alone has not rewritten its backend allocations or changed its ABI.

Compare a CPU software-buffer lane for tiny/low-motion windows with a native GPU
lane. A shared-memory CPU surface can avoid device/pipeline startup, but still
needs compositor-owned/released buffers and can lose badly on bandwidth/effects.
A GPU lane can reduce CPU raster work yet bring a large fixed device/driver cost.
Native retained composition may preserve pixels for motion at an extra surface
cost. Select by capabilities and measured complete work; neither GPU nor software
is forced into the source-only floor. Keep compatible devices/font/shaping
services shared across windows and start them on demand.

## Representation has to beat its indexes

The selected model shares immutable topology, defaults, recipes and eligible
unrounded layout solutions. An instance stores identity and independent changes.
Capability lanes are lazy. A rare capability must not require N pointers just to
say N-1 nodes lack it. Compare a sorted sparse page directory, per-page presence
bitmap plus packed values, and a dense lane at actual densities. Promote by
total capacity bytes with hysteresis, including the temporary overlap of both
representations and drop cost.

Every capability identifier pays namespace/generation at an external crossing.
Within a validated phase borrow, local u32 indexes/NonZero niches can omit that
repetition. They cannot escape to become process capabilities. A page/offset
format needs checked bounds, layout/alignment and pool identity. A 32-bit offset
also declares a maximum addressable region; do not truncate a pointer or assume
that a process stays below 4 GiB.

Use safe enum niches and per-kind lanes first. A tag can be amortized over a run
or supplied by the lane, eliminating repeated variant words without an unsafe
union. Explicit `Inherit/Set` presence, lifecycle and overflow states must still
be representable. NaN sentinels are admissible only for a private cache whose
finite input domain reserves them; they cannot erase a user-visible NaN value.
Pointer tags/untagged unions require strict-provenance/alignment/drop proofs and
a measured benefit larger than the resulting code/validation burden.

Intern by complete equality after hash filtering; bound tables and unique-case
overhead. A user-provided untrusted byte key must not inherit an unchecked
identity hasher merely because internal prehashed IDs use one. Share common
strings/styles but avoid an intern allocation for every one-use value. Keep
property metadata, route schemas and reflection code static/shared by type,
with no repeated vtable or descriptor object per instance. Measure binary and
monomorphization cost as well as heap savings.

## Bound scratch and history independently

Traversal scratch belongs to a phase and has an explicit high-water release
policy. The current wide spatial oracle retains 72 bytes per depth entry; a
30k-deep adversary is not cheap merely because it has one geometry record.
Use sparse space ancestry, bounded pages or a smaller stream stack in the chosen
representation, then compare full traversal/hit/damage work against the oracle.
Large temporary capacity is released after quiescence/pressure at a legal borrow
boundary, rather than pinning one pathological history forever.

Pools retain useful hot capacity under a byte cap and evict unleased cold pages.
Bound debug trace, snapshot output, undo/durable journal cache, parked/exit
subtrees, layout/shape caches, font atlases, pipeline caches, page queues and
per-window packet versions independently. Queue count alone is insufficient when
one message owns an arbitrary Vec. Compression changes byte cost, not admission
authority; enforce decoded limits and bounded decompression before acceptance.

Cache-hot mutable lanes remain directly readable. Share default spans and use
presence/bit packing or dictionary references for immutable pages. XOR/delta or
general compression is for cold snapshots/eviction/storage only when measured
decode latency and total footprint win. Never decompress a whole clean tree to
discover that nothing changed. A cache may be discarded only if its source and
rebuild path remain valid.

## Share physical backing, not dangling references

Read-only code/font/asset/template mappings can be physically shared. Serialized
templates use stable offsets, validated lengths and versioned schemas, with no
Rust references, TypeIds, closures or function addresses. Mutable per-instance
state stays in private pages to avoid dirtying shared defaults. An asset mapping
is leased while CPU/GPU/OS uses it. Sealing/read-only protection can enforce
immutability where the platform provides it; it does not replace lease ownership.

Evaluate decommit/discard for large reconstructible cold pages, while preserving
address/initialization guarantees and allocator ownership. Relocation/remap
requires no live interior references and offset-based handles. Huge pages can
improve TLB reach but waste resident memory for sparse data; use only measured
large, dense, long-lived regions. Pinning/locking pages and prefaulting trade
latency for residency, so they are explicit latency policies, never defaults.

For pixels, count width*height*bytes-per-pixel for each actual image, padding,
sample count, mip chain and in-flight generation. Reuse effect scratch with
nonoverlapping pass lifetimes; a driver fence and import release remain mandatory.
Sparse tiles save only if tile directories, partial upload and compositor
presentation do not reconstruct the same full image elsewhere. Report those
copies instead of hiding them outside the Rust allocator.

## What the tiny-ELF work teaches

[Nathan Otterness's 2021 primary account](https://nathanotterness.com/2021/10/tiny_elf_modernized.html)
systematically removes headers/code overhead from a Linux hello-world executable
and records revised minima and loader constraints. Its linked Brian Raiter
teensy-ELF tutorial is the historical reference; that original endpoint was
unavailable during this audit. The transferable method is to distinguish loader
requirements from conventional scaffolding and inspect actual mappings/instructions.
A sub-page executable does not imply sub-page RSS or a GUI memory floor.

Measure section GC, ThinLTO, codegen units, generics, unused native features,
dynamic/static linkage, relocation count and clean/dirty executable pages on the
real example. Demand-load optional services. Avoid changing unwind/panic/TLS/libc
contracts just to match a synthetic exit program. Keep a no-graphics minimal
binary as an attribution baseline and separate first-visible-frame measurements.

## Required evidence before an extreme-memory claim

Publish build/feature/target/compiler/upstream IDs; one allocation/capacity ledger;
ELF load segments and `/proc` mapping attribution; native/backend/GPU/display
details; warm and cold first-frame time/page faults; input-to-present p50/p99;
idle CPU/wakes; repeated open/close and device-loss reclamation; and high-water
bytes under stalled workers/guests/fences. Test one unique/dense case that defeats
sharing, one deep case, and multiwindow contention. Lower memory must not be
purchased through missing semantics, unbounded latency or premature reclamation.
