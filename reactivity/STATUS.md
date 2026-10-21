# Implementation and evidence

The clean-room workspace runs real applications through one exclusively owned
runtime. Start at [the GPUI crate](crates/gpui/README.md). The design documents
describe the intended complete system; this page records what is connected now.

| Boundary | Integrated behavior | Remaining limit |
| --- | --- | --- |
| Ownership and sources | Borrowed View, inline Signal, typed owner-relative sources/actions, contained component projections and typed one-source Reader questions | One serial root owner; complete dependency/cohort graph remains |
| Public testing | Application::demo, borrowed semantic queries/visits, conjunctive name/description filters, actions, focus/keyboard, typed worker delivery, source JSON and explicit scene/pixel diagnostics | Virtual time and replay remain |
| Accessibility | Native AccessKit in ordinary desktop profiles, bounded exact acknowledged transitions, lazy active projection, revalidated actions; actual Linux AT-SPI client execution | Topology/missed/capped transitions use full projection; selection/IME, relationships, virtual-item realization and UIA/VoiceOver runtime coverage remain |
| Identity | Window-qualified, never-reused 16-byte target stamps; logical membership checks; keyed realized-row identity; no target allocation table or visited-key history | Cross-window list transfer and unrealized-row accessibility realization remain |
| Worker delivery | Static typed inbox/question chains, frozen batches, versioned one-source admission, one physical completion credit, borrowed cooperative cancellation, native wakes and exclusive cleanup | Multi-input Reader/cohort graph and demand parking remain; queue capacity is not a byte bound |
| Collections | Borrowed keyed uniform lists, f64 rebased offsets, viewport-only rows, native wheel routing and public query/scroll operations | Explicit uniform-height finite viewports; variable-height and nested measured viewports remain |
| Properties and inspector | Typed selectors and reflection catalog, sparse Set/Inherit style and semantic overrides, shared transform/hit/paint geometry | Native inspector UI, complete theme cascade and user-defined component schemas remain |
| Layout and text | Cephal, scoped Parley/HarfRust Unicode paragraphs, immutable bounded bundled fallback leases, optional typed caret geometry, lazy Swash masks and physical-density rasterization | Native selection/IME, grapheme editing, arbitrary font discovery and hostile-font transient budgets remain |
| Canvas | Canonical grouped display list, linear-light 4×4 sampling, exact per-pixel sample promotion, separable rectangle/glyph addresses, tile proofs, optional CPU image, exact scene-support damage, certified software-buffer repair, local CSR bins and disjoint parallel bands | Multiple damage islands, persistent GPU repair and complete effect/path/media library remain |
| GPU | Actual Rust-authored wgsl-rs shader, four-binding grouped packets, tile proofs, lazy R8 atlas, boundary corrections, SDR and linear HDR targets | Native HDR negotiation, other primitives and hardware/backend conformance remain |
| Native | Winit windows, software-first startup, owned background GPU preparation, checked handoff/recovery, DPI and suspend/recreate | Windows Auto deliberately stays software; shared-device multiwindow and guest/webview composition remain |
| Blank X11 | Exact zero-command certificate uses server fill; no retained client pixel backing; normal-buffer→solid releases backing after server completion | Server/compositor storage remains; other platforms use ordinary software buffers |
| Applications | Counter, Todo, Oklch/transform gallery, composed Workspace and 250K Library, including explicit worker search and restored domain inputs | Library sends play requests but has no audio/database integration; full Hummingbird port remains |

Mutable model/window state uses ordinary exclusive Rust borrows. The production
window engine contains no Rc, RefCell or Cell. Native observation callbacks use
FnMut, allowing plain captured state. Immutable text uses one-word ArcStr leases
between source and presented epochs; fonts, masks and in-flight backend resources have
explicit immutable resource leases. Some test-only read/drop counters still use
interior mutability; dependencies and OS callbacks have their own contracts.

Queries and tests read the acknowledged semantic sheet. A borrowed Part shares
target, parent, role, name/value, supported actions and canonical geometry;
semantic execution revalidates current owner authority. Explicit names and
descriptions occupy sparse cold columns; ordinary nodes carry no annotation
pointer. Candidate metadata and list positions become queryable only with their
acknowledged P. Semantic-only changes can publish at the same scene token without
painting, while an unresolved visual edit keeps the preceding coherent metadata.
Focus and normalized
keyboard operations use the production dispatcher, including stale-sheet and
owner-quarantine rules. [Native accessibility](crates/gpui/ACCESSIBILITY.md) shares
these identities, focus, geometry and action authority. It adds no GPUI-side
AccessKit tree mirror or historical ID map; the native adapter retains its own
required tree. Stock Linux adapter construction starts background work even
before activation, so lazy conversion is not a zero-cost native AT claim.

On the current 64-bit build, Node is 40 B, an actual text-site entry is 80 B,
Presented is 80 B and a frozen list-row entry is 24 B. Author Color is 16 B and
Style is 88 B. Resolved styles use an owner-owned default/dense/shared lane with
bounded exact discovery and an unrestricted dense fallback; its header adds 40 B
per owner. Unicode TextLayout is 56 B, eight bytes larger than its predecessor.
These are exact retained layouts, not whole-window memory figures; layout/font/scene
storage and native services remain separately owned.

## Current verification

[checks.json](evidence/checks.json) records twenty successful gates with exact commands,
exit status and elapsed time, run against source commit e012ac5aa3:

- Debug and release workspace suites: **424 passing cases/doctests each**.
- Strict workspace Clippy and first-party formatting: pass.
- Explicit parallel Canvas suite: **78 passing cases**, overlapping the workspace suite.
- Optimized Loom protocol suites: **6 existing cases, 3 historical question-credit cases and 9 production-mailbox cases**; finite proof scope in [TESTING](TESTING.md).
- Actual Vulkan conformance: **19 passing readback cases**, including all five author color layouts through SDR/HDR, 24 signed/fractional inverse-lattice clipping fixtures and numeric signed-zero preservation with tile proofs enabled and disabled.
- Actual X11 integration: **one script** covering five renderer policies, focus/keyboard/pointer input, presentation recovery, transforms, resize, suspend/recreate and solid/normal backing transitions.
- Actual X11 worker delivery: **one script** checking real wakes, committed-error repair and shutdown without a polling timer.
- Actual X11 Reader delivery: **one script** checking obsolete-credit retirement and latest-result acknowledgement without polling or unrelated input.
- Actual X11 250K Library: **one script** checking wheel/pointer routing, source/presentation separation, row target lifetimes, resize, suspend/resume and full server-pixel equality.
- Accessibility schema/action/transition suite: **20 passing cases** using the actual pinned Consumer, overlapping the accessible native tests rather than the headless workspace count.
- Actual Linux AT-SPI client: **one script** reading native names/content, focusing, editing, invoking and reactivating; activation and semantic-only name changes require no new frame.
- Actual absent-session-bus native presentation: **one script**.
- Combined X11+Wayland accessible and explicit minimal compilation, strict accessible all-target Clippy, and retained-layout example: pass.

The renderer is Mesa 26.1.4 llvmpipe/LLVM 21.1.8 on Linux/NixOS. It proves
backend execution and output, not discrete-GPU performance. The native test's
GPUI_SOLID_MEMORY records verify zero client SHM mappings for certified solid
frames and a 2,097,152-byte mapping for the normal 800×600 buffer. The solid helper
runs inside that native script; a filter matching zero tests is not accepted as
execution evidence.

Apple presenter sources and main-thread/worker-drop tests were cross-typechecked
for aarch64 macOS. The actual AccessKit/native integration was also cross-typechecked
for aarch64 macOS and x86-64 Windows MSVC. Actual AppKit execution, UIA/VoiceOver,
and visible CPU/GPU handoff remain required. Windows and Wayland runtime behavior need their native runners; added
CI workflows are not reported as completed remote results.

[Subsequent turn checks](evidence/turn-checks.json) pin source 067eebce12:
the borrowed source/delivery phase refactor passes the complete GPUI suite,
the real X11 worker script and warnings-denied all-target Clippy on Linux plus
the actual macOS/Windows desktop adapters under cross-compilation. The native
test gate is scoped to its Linux X11 caller. These supplemental checks do not
represent UIA, VoiceOver or other target OS runtime execution.

The combined Reader/accessibility source also passes warnings-denied all-target
desktop-adapter Clippy under [aarch64 macOS](evidence/reader-apple-clippy.txt) and
[Windows MSVC](evidence/reader-windows-clippy.txt) cross-compilation. This is
typechecking of the actual adapters, not execution on those operating systems.

The earlier [sealed question integration](evidence/question-integration-checks.json)
pins its five scoped checks to source c3ae3584d4; the complete report above also
includes the subsequent cancellation and sample-storage integration. The parallel
Canvas gate was paused during separate quiet benchmark captures; its elapsed
wall time includes that pause and is not a suite-speed measurement.

The later [output-conversion checks](evidence/output-cache-checks.json) pin source
b4598cb303: 79 release parallel Canvas cases/doctests, strict all-target accessible
native Clippy, all 19 Vulkan readbacks and the real Todo multi-renderer script
pass. [Warnings-denied desktop cross-checks](evidence/output-cache-platform-checks.json)
also pass for aarch64 macOS and Windows MSVC. These are actual adapter compilation,
not execution on those operating systems.

## Measurements and their boundaries

| Change | Evidence | Limit |
| --- | --- | --- |
| Preserved software repair | [Damage evidence](crates/gpui/RETAINED_DAMAGE.md): moving caret over 1,001 stable commands reduces median prepare+raster 21.64 ms→206.7 µs; no warm repair raster allocations | Full native upload remains; excludes event delivery/scanout. One conservative rectangle, O(commands) comparison, no GPU repair or competitor claim |
| Exact sample promotion | [Sample storage](crates/canvas/SAMPLE_STORAGE.md): moving-caret fixture full raster 21.53→6.06 ms; 48-label SDR preparation+raster 16.90→13.87 ms | Adds 4 KiB+32 B initialized worker scratch; no retained reduction; native upload/latency excluded |
| Exact output reuse | [General controls](crates/canvas/SAMPLE_STORAGE.md): the one-pixel cache further lowers 48-label HDR preparation+raster 17.30→14.64 ms and sheared translucent boxes 2.78→1.94 ms | SDR flat serial panels lose 1.65–1.77%; small stack-only cache, no retained reduction or native latency claim |
| Exact glyph addresses | [500-row controls](crates/canvas/evidence/glyph-axis/README.md): 48-label SDR preparation+raster 13.80→5.73 ms, HDR 14.70→6.68 ms | Adds 1,032 B transient address tables per worker; several non-text serial controls lose 2–3%; excludes native upload and predates Unicode integration |
| Current-owner style sharing | [Style evidence](crates/gpui/evidence/retained-styles.md): Node 128→40 B; repeated whole owners save about 16% requested retained bytes | Adds 40 B owner header; unique payload neutral; two-style coarse descriptions lose about 10%, first inspector densification 10–20% |
| One Unicode layout | [Text evidence](crates/canvas/TEXT.md): 1000-label owner mount 14.79→12.85 ms, requested peak 2.11→1.93 MB | Retains 8,304 B more, prepare loses 4.6%, empty native PSS adds 194 KiB; Linux text-only cut, no native IME/selection claim |
| Lazy fonts and scoped shaping | [Startup](crates/gpui/STARTUP.md): Gallery median 80.038→40.525 ms on default-reset Xvfb; 23.302 ms with -noreset | Display reset is an environmental cost; warm filesystem, fresh processes, present acknowledgement rather than scanout |
| CPU-first blank | [Memory CSV](crates/gpui/evidence-native-memory-auto-swash.csv): roughly 8.5 MiB PSS, one idle thread, no GPU probe on this device-less Linux host | Predates representation/solid changes; driver/compositor bytes are separate |
| Canonical retained runs | [Canvas](crates/canvas/README.md): 32K-glyph grouped fixture retained heap 4,456,500→1,269,876 B; peak 6,689,076→1,795,060 B | Unique-mask heap is neutral; Canvas header grows 208 B; flat traversal can lose |
| Grouped GPU packets | [GPU](crates/gpu/README.md): 32K fixture record bytes 3,072,096→1,104,096; explicit GPU buffer capacity 4,198,484→2,101,332 B | Frame time is neutral/slightly slower; fixture retains records hidden by a final opaque fill |
| Tile certificates | [GPU results](crates/gpu/tile-benchmark.csv): 32 opaque overlaps 182.17→1.18 ms on llvmpipe | Boundary-heavy case 23.44→26.12 ms loses; not a hardware-GPU comparison |
| Blank solid transport | [Mapping results](crates/gpui/evidence-native-solid.csv): normal buffer retains 2 MiB mapping; initial/returned solid retains zero | Client transport only, not whole application/server/compositor memory |
| Static delivery cleanup | [Borrow-guard evidence](crates/gpui/evidence/remote-guard.md): channel/staging 4→3 allocations and binding 1→0; headless Remote 24→16 B, Inbox 64→56 B | End-to-end timing is neutral; attached OS/wake allocations are not claimed zero |
| Keyed viewport | [List evidence](crates/gpui/VIRTUAL_LIST.md): 27 retained semantic nodes and 59,979 requested framework bytes at 100 through 250K identifiers; mount median 375–495 µs | Warm code/allocator, fresh owner caches, fixed-text fixture, no native submission; app IDs and reverse index are separate |
| Packed identities and geometry | [Sheet packing](crates/gpui/evidence/sheet-packing.md): bounded parent index and finite affine sentinel reduce Node 232→224 B and P 104→88 B; FieldId's checked nonzero encoding subsequently shrinks its option to 8 B | Exact admitted-domain representation; no coordinate quantization or new unsafe |
| Dense text storage | [Text-lane evidence](crates/gpui/evidence/text-lane.md): Node 216→136 B, plus 80 B per actual text site; 4,097-node sparse fixture saves 307,256 requested retained B | Adds one Vec header and one nonempty lane allocation; dense text headers are neutral; measured timing losses are retained |
| Native semantic projection | [Projection evidence](crates/gpui/ACCESSIBILITY.md): exactly reserved 10K-button output removes about 0.87 MB retained and 1.62 MB peak requested B versus geometric growth | Extra read pass; excludes adapter-owned tree, D-Bus and OS providers; changed P still projects the full tree |
| Thin text leases | [Paired evidence](crates/gpui/evidence/thin-text.md): P 88→80 B and text-site 80→72 B; 100K no-text fixture saves 800,000 requested retained B | Each unique nonempty payload requests 1–8 B more; no-text preparation loses about 10% and sparse edits about 6%; rejected flag packing did not fix it |
| Lossless author colors | [Color proof and measurements](crates/canvas/COLOR_PACKING.md): Color 20→16 B, Style 96→88 B, Node 136→128 B, preserving all admitted HDR/author bits | Some conversion/mount/raster phases lose; native first acknowledgement is flat and native RSS/PSS increased in the paired capture; Canvas working colors already occupied 16 B |
| Measurement routing | [Paired evidence](crates/gpui/evidence/layout-route.md): 10,001-node repeated-color mount removes 913 scratch allocations and 262,472 peak requested bytes | Retained storage is unchanged; individual trace phases lose and dense text searches are not a universal speedup |
| Sparse native semantics | [Transition evidence](crates/gpui/SPARSE_ACCESSIBILITY.md): 100K leaf projection+Consumer replacement about 77.7 ms→73.6 µs, peak about 34.8 MB→328 B; verified field hints remove the common P scan | Warm repeated replacement, not screen-reader latency; active 10K geometry preparation pays about 14.3% comparison tax; inactive observation skips it |
| Typed questions | [Sealed mailbox ledger](docs/question-sealed-staging.md): first declared u64 question requests 2 allocations/152 B headless, 2/200 B native; ordinary owners gain no fields | Each projection description pays two boxes/88 B; explicit Library worker reserves 256 KiB stack; complete Reader/cohort graph remains |
| Cooperative Library work | [Cancellation evidence](docs/question-cancellation.md): obsolete worker retirement/latest dispatch 8.434 ms→29.611 µs, stopping after 128 of 250K tracks | Current remaining scan loses 0.94%; source edit, first 128 tracks, latest execution and presentation excluded |

The measurement rows pin their own baselines. Dense text, thin leases, color
packing and row derivation were measured independently; their percentages are
not additive, and a combined native memory/performance improvement is not inferred.

No competitor victory, near-zero native memory floor, universal byte parity or
order-of-magnitude feature-equivalent simplification has been established.
Reports retain losing cases. The full Hummingbird source audit is
[pinned separately](docs/hummingbird-source-audit-luna.md). The keyed-list and
worker-delivery foundations are integrated; images, complete async admission,
media and richer input remain prerequisites for that port.
The [packed-dimension experiment](crates/gpui/evidence/dimensions.md) remains out
of production: its exact 8-byte node saving did not justify unresolved phase costs.

## Scope and line accounting

[line-counts.json](evidence/line-counts.json) counts physical Rust lines, including
comments/blanks and embedded tests. Examples/external tests and every vendor tree
are separate. The source b4598cb303 snapshot contains **27,838 first-party src lines** and
**20,407 external test/example lines** across production and experimental crates.
Src includes embedded tests; it is not a production SLOC claim. Complete Winit,
Cephal, Softbuffer and Wgpu-HAL sources total **131,279 Rust lines**, including
their tests/examples. Vendoring has not made those dependencies disappear.

[Baseline](evidence/baseline.json) pins the original 260,010 physical Rust lines
and inspector/transforms/testing branch deltas. Legacy remains a plumbing and
behavior reference; nothing was deleted under a false feature-equivalence claim.
[Provenance](vendor/PROVENANCE.md) records Winit/Cephal; [presenter patches](vendor/PRESENTER_PATCHES.md)
documents the additional complete archives and bounded platform ownership fixes.

Topology/layout, template, exact-translation, coverage and ownership labs remain
independent correctness/comparison tools. Their measurements are not automatically
production results. [PLAN](PLAN.md), [REVIEW](REVIEW.md) and [EXPERIMENTS](EXPERIMENTS.md)
retain the admission and deletion gates.
