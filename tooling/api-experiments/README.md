# Native reflection and selector design evidence

The current design starts with ordinary Rust. Every `View`, including `RenderOnce`, converts to
an element without a derive. A typed `select` callback borrows that authored value before render;
`select_entity` lends an entity's model together with its native `Context`. A single optional
`#[gpui::reflect]` on an inline module adds field paths, native method handles, structural inspection,
and local trait-object views. The consumer guide is [element-queries.md](../../docs/element-queries.md).

## Selected architecture and experiments

| Area | Evidence | Decision |
| --- | --- | --- |
| Native callbacks and inference | `native-select-inference`, `value-query-consumer`, production `value_queries` | Let the callback choose a concrete receiver, or infer it from a field, role, view, or component target. Keep ordinary native methods and trait bounds. |
| Structural reflection | `module-reflection-frontier`, `value-shape-frontier`, `comptime-frontier`, `zero-macro-frontier` | Generate accessors from one ordinary module. Use safe borrows and exact Rust types, without field offsets or reconstructed trait-object vtables. |
| Compiler introspection | [compiler-reflection-frontier](compiler-reflection-frontier/README.md) | The nightly spike discovers field metadata and native trait vtables without user macros. This compiler still ICEs on the direct ADT probe; field `TypeId`s do not synthesize typed Rust field projections, and lifetime erasure, private fields, packed layouts, and inactive enum payloads need stronger compiler guarantees. Keep the experiment isolated and use compiler-checked native getters in production. |
| Lifetime-indexed paths | `borrowed-path-frontier`, production borrowed-path escape and alias probes | Separate path identity from its per-call borrow proof. Composition supports borrowed intermediate types without imposing a static lifetime on native paths. Erased `Any` subjects remain static. |
| Canonical immutable slots | `schema-slots-frontier`, `schema-slot-audit`, production schema publication/concurrency tests | One pointer identifies a Rust type. Metadata is attached once; existing opaque and cached child handles observe publication. Root-typed field, role, and schema builders reject mismatched receivers before erasure. Snapshot keys invalidate cached misses after publication. |
| Actual-type discovery | `cross-module-shape-frontier`, `schema-discovery-frontier`, `discovery-macro-audit`, production `value_shapes` | Let compiler-proven `Describe` implementations win; retain partial standard-container shapes for unknown children. Linked monomorphic factories cover unbounded generic discovery. Complete container chains prepare their children once, including imported nested aliases. Syntax only seeds proven factories; names never classify containers. |
| Methods and local roles | `module-shape-audit`, `method-overloads-frontier`, production privacy/unsafe/associated-type tests | Preserve native generic, borrowed, async, unsafe, and specialized method signatures. Use one handle per method name. Callable roles require valid Rust trait objects; direct callbacks and explicit native views cover the rest. |
| Stateful entity models | `reactive-view-query-frontier`, production `entity_queries` | Keep the model lease inside `Entity::update`; lend the model and context only for the callback. Type/class admission precedes positional counting. Favor repeatable assignments before the current render. |
| Prepared native dispatch | `frontier-dispatch`, `value-runtime-bench`, production reflection and selector benchmarks | Cache immutable schema adapters, then borrow each receiver through native coercions. A retained role borrow avoids repeated lookup; a prepared projection works across successive receivers. Warm allocation profiles are separate from timings. |
| Fast feedback and rendering | [element-api-testing.md](../../docs/element-api-testing.md), `testing-review-oct8.md`, production contract runner | Keep headless consumer tests, serial cfg-local compile rejection probes, and isolated experiments. The sibling visual report workflow complements the compile loop; source-fragment tests alone do not verify browser layout. |

Run the current public contracts with `python3 scripts/check-element-api.py`. Use
`--skip-positive --case NAME` for a focused diagnostic iteration. The benchmark methodology,
source fingerprints, allocations, and timing limits are in
[element-query-performance.md](../../docs/element-query-performance.md).

Each experiment README records its commands and limits. Some prototypes intentionally preserve
older APIs or frozen runtime copies; their passing tests do not certify the current GPUI build.
The previous capability/table design and its measurements are retained as
[historical evidence](legacy-design-evidence.md). Keyed capabilities, `select_mut`, and
`map_selected` remain available for specialized compatibility cases; native lending is the primary
consumer interface.
