# Original design corpus: authority and implementation crosswalk

## Preservation and precedence

All **127 original files**, totaling **2,742,602 bytes**, from the user-designated Mac `Downloads/designs/reactivity` directory are preserved byte-for-byte at [`designs/reactivity`](../../../designs/reactivity/README.md). Every file was checked against its original byte count and SHA256. No normative text was rewritten. The attached archive SHA256 is `3fa775be54ab5120b5186453e771a851c7cb802201db1fcca5f8175ba169ce39`.

Read the [original README](../../../designs/reactivity/README.md) first. It explicitly gives the consolidated [final/00-model.md](../../../designs/reactivity/final/00-model.md) and its eleven statutes precedence over historical passes; §9 records deliberate conflict resolutions. [07-the-ladder.md](../../../designs/reactivity/07-the-ladder.md) remains the key public-surface decision record, and [11-consolidations.md](../../../designs/reactivity/11-consolidations.md), “Where 07 Leaks, and the Algebra That Closes It,” is the exact structural review the user quoted. The ordering must not be flattened into “the newest implementation wins.”

The organizing criterion remains **one semantic model, proofs at boundaries, no third language, nothing ambient**. This engineering brief describes implementation state and departures; it does not amend the original design by implication.

## What the current source does and does not establish

This crosswalk is a bounded collection-time review of the original README, constitution, ladder/review structure and known implementation. It is **not** an exhaustive semantic conformance audit of every paragraph in the 127-file corpus. All originals are included so that the remaining audit is reproducible, not replaced by summaries.

| Normative obligation | Collected implementation / current gap |
|---|---|
| One ordinary-Rust model with progressive storage prices | `View::view(&self) -> El<'_>`, `Signal<T>`, typed property feeds and explicit model mutation exist. The whole promised T/Signal/List/Entity/Reader ladder is not qualified as one complete surface. |
| Source/Sink/Cell is one sealed feed algebra across features | Current `Source<M,T>` is an owner-relative field handle with explicit registration; the shared name does **not** demonstrate the complete generic Source/Sink/Cell algebra described by 11 and final/03. Treat this as an explicit surface gap, not spelling-equivalence. |
| No ambient context and proofs at boundaries | Window ownership, explicit resource scopes and typed publication receipts provide real boundaries. The broader cross-entity/async/native capability surface is incomplete; a resource context currently budgets only registered optional roots. |
| Stable Rust greenfield substrate | The collected normative-source implementation still uses nightly SourceValue traits. Host stable adaptations have qualified controls but lack transparent arbitrary struct/enum compatibility. This is a material implementation/design mismatch. |
| Pure borrowed view plus coherent typed changes | Borrowed views and damage/publication transactions exist. The constitution's complete `changed`/`Changed`, recursive delta and Handoff reaction model must not be inferred from the current damage journal alone. |
| One retained pipeline rather than feature-specific languages | Common facets, closure, solver facts and Canvas binding are composed in the selected source. The actual target consumer and general unchanged-command reuse remain missing; full presentation work is still too broad. |
| Identity, readiness and lifetime compose across all verbs | Current site/resource/source identities and leases are explicit. They do not qualify every mixed Reader/Signal/Entity/sequence/readiness combination required by the source algebra. |
| Complete cost and quality gates | Historical graphs, real host tests and codegen facts are preserved. There is no current unified realistic speedup graph, no total application-memory bound, and no blanket native GPU-completion/pixel claim. |

## How all documents enter the handoff

- `final/`: constitution and eleven statutes; primary conformance authority and completion-gate source.
- Numbered passes `01`–`19`: rationale, evolving public API, structural consolidation and explicit historical decisions. Apply the README's precedence rules rather than cherry-picking convenient spellings.
- `runtime/`, `style/`, performance/migration/PR plans and gap register: implementation mechanisms, cost laws, phased adoption and missing-gate backlog.
- `examples/` and `final/examples/`: original authoring expectations and comparison material, not proof that current code compiles those examples.
- `00-research/`: preserved research/evidence record; temporal claims are historical and require revalidation before new adoption.
- `approaches/`: preserved alternatives and syntax sketches; inclusion is not adoption or compilation evidence.

## Complete original-file index

The companion `ORIGINAL-DESIGNS-MANIFEST.json` records all byte counts and SHA256 hashes. The following index includes every file, including non-Markdown examples, rather than only the ladder excerpts.

| Original relative path | Title / role | Bytes |
|---|---|---:|
| [00-research/01-reactivity-implementations.md](../../../designs/reactivity/00-research/01-reactivity-implementations.md) | Fine-Grained Reactivity in Rust: Source-Level Survey for GPUI | 74,419 |
| [00-research/02-view-tree-architectures.md](../../../designs/reactivity/00-research/02-view-tree-architectures.md) | View-Tree / Declarative UI Architectures: A Comparative Study for GPUI's Fine-Grained-Reactivity Redesign | 104,993 |
| [00-research/03-gpui-internals.md](../../../designs/reactivity/00-research/03-gpui-internals.md) | GPUI-CE Architectural Map: Data Flow, State Ownership, Reactivity | 129,674 |
| [00-research/04-rust-frontier.md](../../../designs/reactivity/00-research/04-rust-frontier.md) | Frontier Rust Language Features for a Compile-Time-Verified Reactive GUI | 93,876 |
| [00-research/05-papers-crossdomain.md](../../../designs/reactivity/00-research/05-papers-crossdomain.md) | Academic Papers & Cross-Domain Systems for a Compile-Time-Verified Fine-Grained Reactive GPUI | 70,280 |
| [00-research/06-competitive-update.md](../../../designs/reactivity/00-research/06-competitive-update.md) | 06 — Competitive Update: Retention, Lists, and the 2026 Bar | 8,234 |
| [00-research/07-async-and-interaction-ux.md](../../../designs/reactivity/00-research/07-async-and-interaction-ux.md) | 07 — Async and Interaction UX: Removing Transport Ceremony | 13,228 |
| [00-research/08-placement-motion-rendering-tooling.md](../../../designs/reactivity/00-research/08-placement-motion-rendering-tooling.md) | 08 — Placement, Motion, Custom Rendering, and Tooling | 13,414 |
| [00-research/09-render-frontends-and-media.md](../../../designs/reactivity/00-research/09-render-frontends-and-media.md) | Renderer Frontends and Media Pipeline Audit | 6,908 |
| [00-research/10-cross-cutting-higher-tier.md](../../../designs/reactivity/00-research/10-cross-cutting-higher-tier.md) | 10 — Higher-Tier Cross-Cutting: What 06 Still Misses | 50,496 |
| [00-research/10-elegance-and-fast-paths.md](../../../designs/reactivity/00-research/10-elegance-and-fast-paths.md) | 10 — Elegance and Fast Paths: Closing the 05 Gap Map | 49,232 |
| [00-research/11-history-and-competitive.md](../../../designs/reactivity/00-research/11-history-and-competitive.md) | 11 — History systems and competitive DX (research snapshot) | 6,571 |
| [00-research/12-color-spaces.md](../../../designs/reactivity/00-research/12-color-spaces.md) | 12 — GPUI color and color-space audit | 10,337 |
| [00-research/13-iced-slint-bevy-gpui-deep.md](../../../designs/reactivity/00-research/13-iced-slint-bevy-gpui-deep.md) | 13 — Iced, Slint, Bevy, GPUI: types, demos, internals | 20,839 |
| [00-research/14-frontier-datastructures.md](../../../designs/reactivity/00-research/14-frontier-datastructures.md) | 14 — Frontier data-structure research (Round 2 sources) | 21,333 |
| [01-problem.md](../../../designs/reactivity/01-problem.md) | 01 — The Problem: What GPUI's Update Model Costs Today | 9,269 |
| [02-principles.md](../../../designs/reactivity/02-principles.md) | 02 — Principles and Honest Limits | 8,969 |
| [03-hybrid-plan.md](../../../designs/reactivity/03-hybrid-plan.md) | 03 — The Retained Reactive GPUI Plan | 124,056 |
| [04-less-is-more.md](../../../designs/reactivity/04-less-is-more.md) | 04 — One View, Two Registers, One Retained Machine | 166,039 |
| [05-one-register.md](../../../designs/reactivity/05-one-register.md) | 05 — One Register: Values, References, Functions | 92,960 |
| [06-cross-cutting.md](../../../designs/reactivity/06-cross-cutting.md) | 06 — Cross-Cutting Surfaces: Projections, Session Indexes, Protocols | 28,572 |
| [07-the-ladder.md](../../../designs/reactivity/07-the-ladder.md) | 07 — One Rust Surface | 152,054 |
| [08-history.md](../../../designs/reactivity/08-history.md) | 08 — History: The Model Records, The UI Tags | 44,220 |
| [09-text.md](../../../designs/reactivity/09-text.md) | 09 — Text: an inline formatting context, not a styled string | 28,012 |
| [10-from-cx.md](../../../designs/reactivity/10-from-cx.md) | 10 — From `cx`: expressiveness, hard ports, references, types | 46,424 |
| [11-consolidations.md](../../../designs/reactivity/11-consolidations.md) | 11 — Consolidations: Where 07 Leaks, and the Algebra That Closes It | 33,590 |
| [12-example-review.md](../../../designs/reactivity/12-example-review.md) | 12 — Example Review: Ceremony the Sketches Reveal | 21,301 |
| [13-composition.md](../../../designs/reactivity/13-composition.md) | 13 — The Composition Pass: Sources in Front, Machinery in Back | 22,021 |
| [14-el-and-wires.md](../../../designs/reactivity/14-el-and-wires.md) | 14 — Retiring `el(…)`, One Children Rule, and Wiring as a Question | 18,309 |
| [15-io-and-deltas.md](../../../designs/reactivity/15-io-and-deltas.md) | 15 — Inputs, Outputs, and Typed Deltas: the Wiring Surface Disappears | 14,139 |
| [16-changed.md](../../../designs/reactivity/16-changed.md) | 16 — `changed`: the Component Reacts to Itself | 9,475 |
| [17-function-shaped.md](../../../designs/reactivity/17-function-shaped.md) | 17 — The Function-Shaped Component: Outputs Are Return Types | 10,945 |
| [18-state-is-the-protocol.md](../../../designs/reactivity/18-state-is-the-protocol.md) | 18 — State Is the Protocol | 9,598 |
| [19-ports-are-contracts.md](../../../designs/reactivity/19-ports-are-contracts.md) | 19 — Ports Are Contracts: the Sealed Algebra and the Platform Bar | 32,396 |
| [README.md](../../../designs/reactivity/README.md) | GPUI Retained Reactivity Design | 9,986 |
| [approaches/A-signals-on-gpui/README.md](../../../designs/reactivity/approaches/A-signals-on-gpui/README.md) | Approach A — Signals on Today's GPUI | 4,179 |
| [approaches/A-signals-on-gpui/examples/counter.rs](../../../designs/reactivity/approaches/A-signals-on-gpui/examples/counter.rs) | Source/example asset | 2,431 |
| [approaches/A-signals-on-gpui/examples/task_board.rs](../../../designs/reactivity/approaches/A-signals-on-gpui/examples/task_board.rs) | Source/example asset | 8,259 |
| [approaches/B-branded-world/README.md](../../../designs/reactivity/approaches/B-branded-world/README.md) | Approach B — A Public Branded UI World | 4,348 |
| [approaches/B-branded-world/examples/counter.rs](../../../designs/reactivity/approaches/B-branded-world/examples/counter.rs) | Source/example asset | 3,161 |
| [approaches/B-branded-world/examples/editor_pane.rs](../../../designs/reactivity/approaches/B-branded-world/examples/editor_pane.rs) | Source/example asset | 7,979 |
| [approaches/C-attribute-graph/README.md](../../../designs/reactivity/approaches/C-attribute-graph/README.md) | Approach C — Retained Attribute Graph plus Universal MVCC | 3,839 |
| [approaches/C-attribute-graph/examples/counter.rs](../../../designs/reactivity/approaches/C-attribute-graph/examples/counter.rs) | Source/example asset | 2,623 |
| [approaches/C-attribute-graph/examples/data_table.rs](../../../designs/reactivity/approaches/C-attribute-graph/examples/data_table.rs) | Source/example asset | 6,889 |
| [approaches/D-compiled-ui/README.md](../../../designs/reactivity/approaches/D-compiled-ui/README.md) | Approach D — Compiler-Owned UI Syntax | 3,710 |
| [approaches/D-compiled-ui/examples/counter.rs](../../../designs/reactivity/approaches/D-compiled-ui/examples/counter.rs) | Source/example asset | 3,686 |
| [approaches/D-compiled-ui/examples/dashboard.rs](../../../designs/reactivity/approaches/D-compiled-ui/examples/dashboard.rs) | Source/example asset | 6,794 |
| [comparison.md](../../../designs/reactivity/comparison.md) | Comparison and Final Recommendation | 10,631 |
| [examples.md](../../../designs/reactivity/examples.md) | Typed Incremental API Examples | 30,685 |
| [examples/README.md](../../../designs/reactivity/examples/README.md) | Migrated examples | 25,402 |
| [examples/animation.rs](../../../designs/reactivity/examples/animation.rs) | Source/example asset | 3,876 |
| [examples/app.rs](../../../designs/reactivity/examples/app.rs) | Source/example asset | 2,071 |
| [examples/async_search.rs](../../../designs/reactivity/examples/async_search.rs) | Source/example asset | 4,023 |
| [examples/blur.rs](../../../designs/reactivity/examples/blur.rs) | Source/example asset | 8,321 |
| [examples/creating_components.rs](../../../designs/reactivity/examples/creating_components.rs) | Source/example asset | 3,994 |
| [examples/derived_observe.rs](../../../designs/reactivity/examples/derived_observe.rs) | Source/example asset | 10,121 |
| [examples/docking.rs](../../../designs/reactivity/examples/docking.rs) | Source/example asset | 2,982 |
| [examples/editor_subscriptions.rs](../../../designs/reactivity/examples/editor_subscriptions.rs) | Source/example asset | 13,478 |
| [examples/example_input.rs](../../../designs/reactivity/examples/example_input.rs) | Source/example asset | 2,739 |
| [examples/haptic.rs](../../../designs/reactivity/examples/haptic.rs) | Source/example asset | 3,569 |
| [examples/hello_world.rs](../../../designs/reactivity/examples/hello_world.rs) | Source/example asset | 2,197 |
| [examples/identity.rs](../../../designs/reactivity/examples/identity.rs) | Source/example asset | 6,703 |
| [examples/image.rs](../../../designs/reactivity/examples/image.rs) | Source/example asset | 5,788 |
| [examples/image_slice.rs](../../../designs/reactivity/examples/image_slice.rs) | Source/example asset | 2,000 |
| [examples/inbox.rs](../../../designs/reactivity/examples/inbox.rs) | Source/example asset | 26,238 |
| [examples/interactive.rs](../../../designs/reactivity/examples/interactive.rs) | Source/example asset | 4,877 |
| [examples/pointer_follow.rs](../../../designs/reactivity/examples/pointer_follow.rs) | Source/example asset | 2,281 |
| [examples/presenter.rs](../../../designs/reactivity/examples/presenter.rs) | Source/example asset | 8,988 |
| [examples/reach.rs](../../../designs/reactivity/examples/reach.rs) | Source/example asset | 8,263 |
| [examples/reactive_compare.rs](../../../designs/reactivity/examples/reactive_compare.rs) | Source/example asset | 12,239 |
| [examples/text.rs](../../../designs/reactivity/examples/text.rs) | Source/example asset | 7,169 |
| [examples/transition.rs](../../../designs/reactivity/examples/transition.rs) | Source/example asset | 1,291 |
| [examples/typeahead.rs](../../../designs/reactivity/examples/typeahead.rs) | Source/example asset | 8,893 |
| [examples/uniform_list.rs](../../../designs/reactivity/examples/uniform_list.rs) | Source/example asset | 1,694 |
| [examples/workbench.rs](../../../designs/reactivity/examples/workbench.rs) | Source/example asset | 36,607 |
| [final/00-model.md](../../../designs/reactivity/final/00-model.md) | 00 — The Model | 27,288 |
| [final/01-state.md](../../../designs/reactivity/final/01-state.md) | 01 — State and Data | 21,987 |
| [final/02-elements.md](../../../designs/reactivity/final/02-elements.md) | 02 — Elements | 20,637 |
| [final/03-ports.md](../../../designs/reactivity/final/03-ports.md) | 03 — Ports | 17,851 |
| [final/04-reactions.md](../../../designs/reactivity/final/04-reactions.md) | 04 — Reactions | 22,186 |
| [final/05-async.md](../../../designs/reactivity/final/05-async.md) | 05 — Async and the Cohort State Machine | 25,418 |
| [final/06-text.md](../../../designs/reactivity/final/06-text.md) | 06 — Text and the Editor Kernel | 16,841 |
| [final/07-platform.md](../../../designs/reactivity/final/07-platform.md) | 07 — Platform | 21,877 |
| [final/08-runtime.md](../../../designs/reactivity/final/08-runtime.md) | 08 — Runtime | 28,541 |
| [final/09-boundaries.md](../../../designs/reactivity/final/09-boundaries.md) | 09 — Boundaries | 15,524 |
| [final/10-quality.md](../../../designs/reactivity/final/10-quality.md) | 10 — Quality: Gates, Testing, and Diagnostics | 37,801 |
| [final/11-roadmap.md](../../../designs/reactivity/final/11-roadmap.md) | 11 — Roadmap | 18,246 |
| [final/examples/README.md](../../../designs/reactivity/final/examples/README.md) | `final/` examples — ports and reactivity, in full | 3,912 |
| [final/examples/commands.rs](../../../designs/reactivity/final/examples/commands.rs) | Source/example asset | 5,241 |
| [final/examples/plugin_item.rs](../../../designs/reactivity/final/examples/plugin_item.rs) | Source/example asset | 9,020 |
| [final/examples/ports_gallery.rs](../../../designs/reactivity/final/examples/ports_gallery.rs) | Source/example asset | 9,210 |
| [final/examples/progressive.rs](../../../designs/reactivity/final/examples/progressive.rs) | Source/example asset | 7,005 |
| [final/examples/reactions.rs](../../../designs/reactivity/final/examples/reactions.rs) | Source/example asset | 12,043 |
| [gap-register.md](../../../designs/reactivity/gap-register.md) | Gap Register — Structural & API Lacks vs Zed/GPUI, Slint, and Iced | 13,060 |
| [migration.md](../../../designs/reactivity/migration.md) | Migration and Delivery Plan | 28,352 |
| [performance.md](../../../designs/reactivity/performance.md) | Performance Contract and Competitive Gates | 38,538 |
| [pr-plan.md](../../../designs/reactivity/pr-plan.md) | The PR Plan: Migrating the GPUI Codebase Itself | 33,322 |
| [runtime/collections.md](../../../designs/reactivity/runtime/collections.md) | Collections, Virtualization, and Text Ranges | 13,622 |
| [runtime/color.md](../../../designs/reactivity/runtime/color.md) | Color: extended-linear working light, open display boundary | 19,368 |
| [runtime/datastructures-2.md](../../../designs/reactivity/runtime/datastructures-2.md) | Data-structure findings, Round 2 — the tree, chained techniques, and the external frontier | 24,034 |
| [runtime/datastructures.md](../../../designs/reactivity/runtime/datastructures.md) | Data-structure findings for the GPUI-fork reactivity runtime | 28,581 |
| [runtime/ds-lab/Cargo.lock](../../../designs/reactivity/runtime/ds-lab/Cargo.lock) | Source/example asset | 150 |
| [runtime/ds-lab/Cargo.toml](../../../designs/reactivity/runtime/ds-lab/Cargo.toml) | Source/example asset | 207 |
| [runtime/ds-lab/runlog.txt](../../../designs/reactivity/runtime/ds-lab/runlog.txt) | Source/example asset | 42,858 |
| [runtime/ds-lab/src/bin/frontier.rs](../../../designs/reactivity/runtime/ds-lab/src/bin/frontier.rs) | Source/example asset | 11,422 |
| [runtime/ds-lab/src/bin/list.rs](../../../designs/reactivity/runtime/ds-lab/src/bin/list.rs) | Source/example asset | 10,407 |
| [runtime/ds-lab/src/bin/nodes2.rs](../../../designs/reactivity/runtime/ds-lab/src/bin/nodes2.rs) | Source/example asset | 11,660 |
| [runtime/ds-lab/src/bin/order.rs](../../../designs/reactivity/runtime/ds-lab/src/bin/order.rs) | Source/example asset | 8,138 |
| [runtime/ds-lab/src/bin/readset.rs](../../../designs/reactivity/runtime/ds-lab/src/bin/readset.rs) | Source/example asset | 6,765 |
| [runtime/ds-lab/src/bin/routing.rs](../../../designs/reactivity/runtime/ds-lab/src/bin/routing.rs) | Source/example asset | 7,262 |
| [runtime/ds-lab/src/bin/share.rs](../../../designs/reactivity/runtime/ds-lab/src/bin/share.rs) | Source/example asset | 13,108 |
| [runtime/ds-lab/src/bin/signal.rs](../../../designs/reactivity/runtime/ds-lab/src/bin/signal.rs) | Source/example asset | 7,212 |
| [runtime/ds-lab/src/bin/slots.rs](../../../designs/reactivity/runtime/ds-lab/src/bin/slots.rs) | Source/example asset | 9,209 |
| [runtime/ds-lab/src/bin/soa.rs](../../../designs/reactivity/runtime/ds-lab/src/bin/soa.rs) | Source/example asset | 8,272 |
| [runtime/ds-lab/src/bin/spatial.rs](../../../designs/reactivity/runtime/ds-lab/src/bin/spatial.rs) | Source/example asset | 8,703 |
| [runtime/ds-lab/src/bin/store.rs](../../../designs/reactivity/runtime/ds-lab/src/bin/store.rs) | Source/example asset | 11,440 |
| [runtime/ds-lab/src/bin/subscribers.rs](../../../designs/reactivity/runtime/ds-lab/src/bin/subscribers.rs) | Source/example asset | 10,396 |
| [runtime/ds-lab/src/bin/tape.rs](../../../designs/reactivity/runtime/ds-lab/src/bin/tape.rs) | Source/example asset | 7,069 |
| [runtime/ds-lab/src/bin/text.rs](../../../designs/reactivity/runtime/ds-lab/src/bin/text.rs) | Source/example asset | 8,912 |
| [runtime/ds-lab/src/bin/tree2.rs](../../../designs/reactivity/runtime/ds-lab/src/bin/tree2.rs) | Source/example asset | 41,164 |
| [runtime/ds-lab/src/lib.rs](../../../designs/reactivity/runtime/ds-lab/src/lib.rs) | Source/example asset | 2,342 |
| [runtime/fastpath.md](../../../designs/reactivity/runtime/fastpath.md) | Fast-Path Proposals: Reaching and Beating zgui Without Complicating the Simple Path | 38,073 |
| [runtime/media.md](../../../designs/reactivity/runtime/media.md) | Typed Media and Renderer Frontend Contract | 19,762 |
| [runtime/memory.md](../../../designs/reactivity/runtime/memory.md) | Memory: Minimal Footprint and Zero Steady-State Allocation | 12,665 |
| [runtime/scheduler.md](../../../designs/reactivity/runtime/scheduler.md) | Runtime Scheduler | 24,277 |
| [runtime/shader-renderer-migration.md](../../../designs/reactivity/runtime/shader-renderer-migration.md) | Shader & Renderer Unification — Migration to Real Parity | 18,150 |
| [style/README.md](../../../designs/reactivity/style/README.md) | Retained Reactive Style System | 12,287 |
