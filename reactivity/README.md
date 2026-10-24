# GPUI clean-room implementation

The independent [gpui crate](crates/gpui/README.md) now runs real views, typed
state, Cephal layout, text, transformed input and live inspector properties.
Counter, Todo, the color/transform gallery, their composed Workspace and a
250,000-recording Library use the
same engine in native windows and public headless tests. The window owns its model
exclusively; queries borrow it and edits require an ordinary mutable borrow.
Borrowed keyed lists realize only the viewport, while typed bounded inboxes
deliver worker results through the same owner turn as ordinary input.
Ordinary desktop profiles include [native accessibility](crates/gpui/ACCESSIBILITY.md)
over the acknowledged semantic sheet and the same revalidated action dispatcher.
[Canvas](crates/canvas/README.md) supplies the reference renderer;
[GPU](crates/gpu/README.md) consumes its borrowed canonical scene with `wgsl-rs`.

```sh
cd reactivity
cargo run -p gpui --features x11 --example workbench -- --cpu
cargo run -p gpui --features x11 --example workbench -- --gpu
```

The workspace pins `nightly-2026-10-23`. GPUI's structural source admission uses
nightly traits; ordinary builds do not use `RUSTC_BOOTSTRAP`. The independently
usable lower-level crates retain their narrower compiler requirements.

This remains an implementation in progress. [STATUS.md](STATUS.md) distinguishes
integrated application behavior, measured experiments and outstanding gates.

Start with [DESIGN.md](DESIGN.md). [CONTRACT.md](CONTRACT.md) is the explicit
revision-2 amendment to the supplied model. The design retains shared immutable
structure, sparse typed instance differences and coherent leased presentation.

| Document | Decision |
| --- | --- |
| [DESIGN](DESIGN.md) | Representation, tree, identity, typed properties, layout and embedding |
| [CONTRACT](CONTRACT.md) | Public API corrections, source commit, epochs, input, style and admission |
| [REACTIVITY](REACTIVITY.md) | Minimal graph, typed sources, equality, dynamic dependencies, Readers and motion |
| [CONCURRENCY](CONCURRENCY.md) | Borrowed phases, owned pages, queues/wakes, scheduling, SIMD and leases |
| [GRAPHICS](GRAPHICS.md) | Coverage, fields/strips/compute/native paths, effects, damage, color and presentation |
| [FORMULATIONS](FORMULATIONS.md) | Derived identities that remove retained data, suffix updates and complete passes |
| [MEMORY](MEMORY.md) | Native/window/device floor, layouts, mappings, scratch and four memory ledgers |
| [TESTING](TESTING.md) | Production testing surface, replay/serialization, oracles and admission gates |
| [PLAN](PLAN.md) | Checkout/branch audit, build sequence, compatibility deletion and code budgets |
| [EXPERIMENTS](EXPERIMENTS.md) | Competing representations, measurements and unsafe admission |
| [REVIEW](REVIEW.md) | Adversarial findings and their dispositions |
| [STATUS](STATUS.md) | Executable scope, measured frontiers, limitations and commands |

[Research and source inputs](docs/README.md) include pinned primary references,
academic alternatives, dated reviews and the supplied original statutes.
[Vendor provenance](vendor/PROVENANCE.md) records complete Winit/Cephal archives;
[presenter patches](vendor/PRESENTER_PATCHES.md) records complete Softbuffer/HAL
archives and the local native ownership changes.
The same design packet is mirrored at `/root/designs/reactivity/rework`.

This standalone workspace is excluded from legacy GPUI. From the repository root:

```sh
cd reactivity
cargo test --workspace --features gpui_reactivity_core/layout
cargo clippy --workspace --all-targets --features gpui_reactivity_core/layout -- -D warnings
cargo test --release -p gpui_reactivity_ownership_lab --features loom --test loom_protocol
cargo check -p gpui_reactivity_host --features x11,wayland
```

Core/state default builds have no third-party dependencies. Layout/native hosting
are optional. The first-party libraries forbid unsafe; the allocation-counter
example is isolated instrumentation. Current experiments are independent oracles,
not all permanent production subsystems. [Core README](crates/core/README.md)
records the mutable-tree oracle's detailed behavior and memory bill.
