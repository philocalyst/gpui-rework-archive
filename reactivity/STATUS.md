# Implementation and evidence

The clean-room workspace runs real applications through one exclusively owned
runtime. Start at [the GPUI crate](crates/gpui/README.md). The design documents
describe the intended complete system; this page records what is connected now.

| Boundary | Integrated behavior | Remaining limit |
| --- | --- | --- |
| Ownership and sources | Borrowed View, inline Signal, typed owner-relative sources/actions, conservative and explicit direct updates, contained component projections | One serial root owner; complete Reader/dependency/cohort graph remains |
| Public testing | Application::demo, borrowed semantic queries/visits, conjunctive name/description filters, actions, focus/keyboard, typed worker delivery, source JSON and explicit scene/pixel diagnostics | Virtual time and replay remain |
| Accessibility | Native AccessKit in ordinary desktop profiles, acknowledged names/descriptions/list positions, lazy active projection, bounded revalidated actions; actual Linux AT-SPI client execution | Full projection on changed P; selection/IME, relationships, native virtual-item realization, UIA/VoiceOver runtime coverage remain |
| Identity | Window-qualified, never-reused 16-byte target stamps; logical membership checks; keyed realized-row identity; no target allocation table or visited-key history | Cross-window list transfer and unrealized-row accessibility realization remain |
| Worker delivery | Static typed bounded inbox chains, frozen fair batches, one owner barrier, native wakes, receiver-before-model cleanup through exclusive borrow guards | Complete Reader, input-version and cohort graph remains; queue capacity is not a byte bound |
| Collections | Borrowed keyed uniform lists, f64 rebased offsets, viewport-only rows, native wheel routing and public query/scroll operations | Explicit uniform-height finite viewports; variable-height and nested measured viewports remain |
| Properties and inspector | Typed selectors and reflection catalog, sparse Set/Inherit style and semantic overrides, shared transform/hit/paint geometry | Native inspector UI, complete theme cascade and user-defined component schemas remain |
| Layout and text | Cephal, borrowed Rustybuzz shaping sessions, lazy Swash masks, logical layout with physical-density rasterization | Selection, IME, grapheme editing and complete font/script fallback remain |
| Canvas | Canonical grouped display list, linear-light 4×4 sampling, conservative tile proofs, optional CPU image, direct native BGRX output, explicit disjoint parallel bands | Complete effect/path/media library and persistent damage replay remain |
| GPU | Actual Rust-authored wgsl-rs shader, four-binding grouped packets, tile proofs, lazy R8 atlas, boundary corrections, SDR and linear HDR targets | Native HDR negotiation, other primitives and hardware/backend conformance remain |
| Native | Winit windows, software-first startup, owned background GPU preparation, checked handoff/recovery, DPI and suspend/recreate | Windows Auto deliberately stays software; shared-device multiwindow and guest/webview composition remain |
| Blank X11 | Exact zero-command certificate uses server fill; no retained client pixel backing; normal-buffer→solid releases backing after server completion | Server/compositor storage remains; other platforms use ordinary software buffers |
| Applications | Counter, Todo, Oklch/transform gallery, composed Workspace and 250K Library; shared native/headless models | Library sends play requests but has no audio/database integration; full Hummingbird port remains |

Mutable model/window state uses ordinary exclusive Rust borrows. The production
window engine contains no Rc, RefCell or Cell. Native observation callbacks use
FnMut, allowing plain captured state. Immutable text uses Triomphe leases between
source and presented epochs; fonts, masks and in-flight backend resources have
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

## Current verification

[checks.json](evidence/checks.json) records seventeen successful gates with exact commands,
exit status and elapsed time, run against source commit 73bd525c9f:

- Debug and release workspace suites: **359 passing cases/doctests each**.
- Strict workspace Clippy and first-party formatting: pass.
- Explicit parallel Canvas suite: **61 passing cases**, overlapping the workspace suite.
- Optimized Loom protocol suite: **6 passing cases**; finite proof scope in [TESTING](TESTING.md).
- Actual Vulkan conformance: **17 passing readback cases**, including 24 signed/fractional inverse-lattice clipping fixtures with tile proofs enabled and disabled.
- Actual X11 integration: **one script** covering five renderer policies, focus/keyboard/pointer input, presentation recovery, transforms, resize, suspend/recreate and solid/normal backing transitions.
- Actual X11 worker delivery: **one script** checking real wakes, committed-error repair and shutdown without a polling timer.
- Actual X11 250K Library: **one script** checking wheel/pointer routing, source/presentation separation, row target lifetimes, resize, suspend/resume and full server-pixel equality.
- Accessibility schema/action suite: **12 passing cases** using the actual pinned Consumer, overlapping the accessible native tests rather than the headless workspace count.
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

## Measurements and their boundaries

| Change | Evidence | Limit |
| --- | --- | --- |
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

No competitor victory, near-zero native memory floor, universal byte parity or
order-of-magnitude feature-equivalent simplification has been established.
Reports retain losing cases. The full Hummingbird source audit is
[pinned separately](docs/hummingbird-source-audit-luna.md). The keyed-list and
worker-delivery foundations are integrated; images, complete async admission,
media and richer input remain prerequisites for that port.

## Scope and line accounting

[line-counts.json](evidence/line-counts.json) counts physical Rust lines, including
comments/blanks and embedded tests. Examples/external tests and every vendor tree
are separate. This snapshot contains **23,707 first-party src lines** and
**16,400 external test/example lines** across production and experimental crates.
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
