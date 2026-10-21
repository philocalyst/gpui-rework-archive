# Implementation and evidence

The clean-room workspace runs real applications through one exclusively owned
runtime. Start at [the GPUI crate](crates/gpui/README.md). The design documents
describe the intended complete system; this page records what is connected now.

| Boundary | Integrated behavior | Remaining limit |
| --- | --- | --- |
| Ownership and sources | Borrowed View, inline Signal, typed owner-relative sources/actions, conservative and explicit direct updates, contained component projections | One serial root owner; complete Reader/dependency/cohort graph remains |
| Public testing | Application::demo, borrowed role/text/bounds queries, unique target resolution, root reads, input, focus, keyboard, source JSON and explicit scene/pixel diagnostics | Virtual time, worker delivery, replay and native accessibility bridges remain |
| Identity | Window-qualified, never-reused 16-byte target stamps; logical membership checks; no target allocation table | Keyed virtual collections are a separate integration gate |
| Properties and inspector | Typed selectors and reflection catalog, sparse Set/Inherit overrides, shared transform/hit/paint geometry | Native inspector UI, complete theme cascade and user-defined component schemas remain |
| Layout and text | Cephal, borrowed Rustybuzz shaping sessions, lazy Swash masks, logical layout with physical-density rasterization | Selection, IME, grapheme editing and complete font/script fallback remain |
| Canvas | Canonical grouped display list, linear-light 4×4 sampling, conservative tile proofs, optional CPU image, direct native BGRX output, explicit disjoint parallel bands | Complete effect/path/media library and persistent damage replay remain |
| GPU | Actual Rust-authored wgsl-rs shader, four-binding grouped packets, tile proofs, lazy R8 atlas, boundary corrections, SDR and linear HDR targets | Native HDR negotiation, other primitives and hardware/backend conformance remain |
| Native | Winit windows, software-first startup, owned background GPU preparation, checked handoff/recovery, DPI and suspend/recreate | Windows Auto deliberately stays software; shared-device multiwindow and guest/webview composition remain |
| Blank X11 | Exact zero-command certificate uses server fill; no retained client pixel backing; normal-buffer→solid releases backing after server completion | Server/compositor storage remains; other platforms use ordinary software buffers |
| Applications | Counter, Todo, Oklch/transform gallery, and Workspace containing the unmodified Todo and gallery views; shared native/headless models | Limited real ports, not a feature-complete GPUI replacement or a Hummingbird port |

Mutable model/window state uses ordinary exclusive Rust borrows. The production
window engine contains no Rc, RefCell or Cell. Native observation callbacks use
FnMut, allowing plain captured state. Immutable text uses Triomphe leases between
source and presented epochs; fonts, masks and in-flight backend resources have
explicit immutable resource leases. Some test-only read/drop counters still use
interior mutability; dependencies and OS callbacks have their own contracts.

Queries and tests read the acknowledged semantic sheet. Focus and normalized
keyboard operations use the production dispatcher, including stale-sheet and
owner-quarantine rules. Accessibility must share those identities, focus,
geometry and action authority. Native assistive-technology exposure remains
an implementation gate.

## Current verification

[checks.json](evidence/checks.json) records ten successful gates with exact commands,
exit status and elapsed time, run against source commit c4dec85223:

- Debug and release workspace suites: **283 passing cases/doctests each**.
- Strict workspace Clippy and first-party formatting: pass.
- Explicit parallel Canvas suite: **59 passing cases**, overlapping the workspace suite.
- Optimized Loom protocol suite: **6 passing cases**; finite proof scope in [TESTING](TESTING.md).
- Actual Vulkan conformance: **16 passing readback cases**.
- Actual X11 integration: **one script** covering five renderer policies, focus/keyboard/pointer input, presentation recovery, transforms, resize, suspend/recreate and solid/normal backing transitions.
- Combined X11+Wayland compilation and retained-layout example: pass.

The renderer is Mesa 26.1.4 llvmpipe/LLVM 21.1.8 on Linux/NixOS. It proves
backend execution and output, not discrete-GPU performance. The native test's
GPUI_SOLID_MEMORY records verify zero client SHM mappings for certified solid
frames and a 2,097,152-byte mapping for the normal 800×600 buffer. The solid helper
runs inside that native script; a filter matching zero tests is not accepted as
execution evidence.

Apple presenter sources and main-thread/worker-drop tests were cross-typechecked
for aarch64 macOS. Actual AppKit execution and visible CPU/GPU handoff remain
required. Windows and Wayland runtime behavior need their native runners; added
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

No competitor victory, near-zero native memory floor, universal byte parity or
order-of-magnitude feature-equivalent simplification has been established.
Reports retain losing cases. The full Hummingbird source audit is
[pinned separately](docs/hummingbird-source-audit-luna.md); virtualization, background
results, images and richer input remain prerequisites for that port.

## Scope and line accounting

[line-counts.json](evidence/line-counts.json) counts physical Rust lines, including
comments/blanks and embedded tests. Examples/external tests and every vendor tree
are separate. This snapshot contains **17,864 first-party src lines** and
**12,943 external test/example lines** across production and experimental crates.
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
