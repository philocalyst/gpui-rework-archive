# GPUI route density and capture census

## Result

The c717 route representation has a real dense-row cost: on this x86_64 build, `Node` is 40 B, `Option<Handler>` is 16 B, `El` is 176 B, and `DraftNode` is 152 B. The modeled thin-owner layouts are 32/8/168/144 B respectively. Those are compiled `size_of` results from the temporary probe on Rust 1.97.1, not portable Rust layout promises.

The allocation side is mixed. Ordinary method-item handlers are zero-sized and their `Box` values request no heap allocation. The sample Companion's component wrapper has the same modeled payload request under the thin-header formulation. In the real support Workspace, five `FieldAction` payloads add 40 requested bytes in the thin-header model; wrappers are byte-neutral and the two methods remain zero-sized. A synthetic dense set of 128 closures each capturing one `usize` doubles the modeled route-payload requests from 1,024 B to 2,048 B after adding an 8 B operation header to each route. Thus the thin handle gives every node row 8 B back in this candidate layout, but it does not remove captured-route allocations and can increase their requested payload bytes.

The report intentionally separates the row-layout delta from route payload requests. I did not add these into a “total memory saved” figure: vector capacities, allocator size classes/metadata, nested `El` storage, route-pool designs, and process-wide memory were not measured. The probe did not intercept the process-global allocator or report usable sizes. Its route allocation counts are the exact retained route-object graph and type-derived `Box` request model, not a global allocation trace.

## Pin and method

The source snapshot is `/root/gpui-ce3/reactivity` at commit `c717df64a9b492b445fa97647deb880fb21b9ef6`. I made a separate detached, sparse worktree at `/tmp/gpui-route-census-c717`, with only `reactivity` checked out. No shared checkout was edited. Probe changes were temporary and remain confined to that worktree.

The probe adds a default `Route::append_probe` method which reports concrete route type name, size, and alignment, and recursively visits nested `ComponentRoute` children. That extra vtable slot makes the resulting executables unsuitable for timing or linked-code comparisons. A `ThinHandlerLayout` and mirror `ThinNodeLayout`, `ThinElLayout`, `ThinDraftNodeLayout`, and `ThinComponentRouteLayout` are compile-time candidate layout mirrors only. The route request model takes the observed concrete payload size/alignment and, for each nonzero payload, computes `Layout::new::<&()>().extend(payload).pad_to_align()` for an 8-byte operation-pointer header. It models one allocation per nonzero route and none for a ZST route. It does not model a separate allocator's usable-size rounding.

The census checks:

- 128 handler-free buttons (`plain`),
- 128 captureless `MethodRoute` method items (`method`),
- 128 closures each capturing one `usize` (`captured`),
- the existing `contained_owner_spike` Companion fixture, and
- the existing support Workspace composed from Graphics and Todos, including an Add click (`route_census_workspace`).

The new controls use public `Win::new`, `inspect`, and `click` operations. The Workspace imports the existing files in `crates/gpui/examples/support/{workspace,graphics,todos}.rs`. No performance or allocator-usable-size measurement was run. `cargo check` and all five example runs completed on the isolated target directory `/tmp/gpui-route-census-target`; the full raw stdout/stderr is retained in the logs below.

## Measurements

| Case | Published nodes / capacity | Node handlers | Retained route graph | Baseline modeled route requests | Thin-header model | Notes |
|---|---:|---:|---|---:|---:|---|
| Plain 128 | 129 / 129 | 0 | 0 | 0 B | 0 B | `El` peak 129; draft cap 256 |
| Method 128 | 129 / 129 | 128 | 128 ZST method routes | 0 B | 0 B | Click invoked and incremented the model; method route objects already allocate nothing |
| Captured 128 | 129 / 129 | 128 | 128 `MethodRoute`, each payload 8/8 | 1,024 B | 2,048 B | Thin model adds one 8 B header per capture; click invoked |
| Companion | 3 / 3 | 1 | 2 objects: `ComponentRoute` 56/8 + ZST method | 56 B | 56 B | Draft overlap: 6 route objects, 3 nonzero, 168 B either way; old and draft coexist during description |
| Workspace | 32 / 32 | 7 | 14 objects: 7 component wrappers, 2 ZST methods, 5 field actions | 616 B | 656 B | Field actions contribute +40 B; draft overlap: 18 objects, 4 ZST, 728→768 B |

The Workspace row is not a toy callback-only tree. Its component wrappers are 3 `Workspace→Graphics` and 4 `Workspace→Todos`; their current 56 B payload becomes 48 B in the thin layout, but the header brings the modeled request back to 56 B. Its two `FieldAction<Graphics, f32, _>` payloads are 40 B each and become 48 B requests. Its three `FieldAction<Todos, Filter, _>` payloads are 48 B each and become 56 B requests. The retained runtime has seven node handler slots; nested wrapper routes account for the 14 route objects in the graph.

The candidate row-width effect is a separate per-capacity delta: a 40→32 B `Node` is 8 B less per `Node` slot; a 176→168 B `El` and 152→144 B `DraftNode` are also 8 B less per row. The plain fixture has no handler object to save, so it isolates that layout opportunity. The Workspace's 32-node capacity gives the same row-shape comparison, but no total memory conclusion is drawn from it.

`EL_PEAK` observed 129 for each 128-button control, 3 in Companion, and 32 in Workspace; it returned to zero after descriptions were flattened. This instrumentation counts live `El` values, not allocations.

## Implications and alternatives

`Box<dyn Route>` uses two words as a fat trait-object owner in these measured layouts. For a zero-sized method item, Rust's `Box::new` does not allocate; it still leaves a two-word route value in each handler slot. The official `Box` docs explicitly document no heap allocation for a zero-sized value in its allocation APIs ([Rust `Box`](https://doc.rust-lang.org/std/boxed/struct.Box.html)). The thin-owner proposal attacks that repeated slot representation but keeps a per-node owning route handle and, for a nonzero closure, needs an operation header alongside the captured value. The c717 route census says captured `FieldAction` routes are where that extra header can raise modeled request bytes. The Workspace evidence therefore argues against describing the proposal as a general allocator reduction.

A small inline erased route is the clearest library alternative for the frequent small-capture case. [`inline_dyn` 0.2.1](https://docs.rs/inline_dyn/0.2.1/inline_dyn/) stores a DST in configurable inline storage, with size/alignment requirements documented by its source; its implementation holds `Metadata<D>` plus `RawStorage<S,A>` and uses drop-in-place. Its stable construction macros and `try_or_box` fallback are visible in the [source](https://docs.rs/inline_dyn/0.2.1/src/inline_dyn/lib.rs.html). A candidate `InlineDyn<dyn Route, 8, 8>` could avoid a separate allocation for route payloads that fit, including one-word closures, while retaining a boxed fallback for larger/over-aligned captures. This preserves the open closure API more closely than an enum, but it still stores route metadata and inline bytes in every `El`/`DraftNode`/`Node` handler slot, including `None` slots, and drops/moves each route as part of those owners. Its exact `Option` and containing-row sizes have not been compiled here; it should be a layout/allocator control before any adoption.

[`SmallBox` 0.8.8](https://docs.rs/smallbox/0.8.8/smallbox/) also supports inline storage and heap fallback, but its concrete source shape includes both a `Space` field and a fat `NonNull<T>` plus marker ([source](https://docs.rs/smallbox/0.8.8/src/smallbox/smallbox.rs.html)); that makes it a poor first fit for preserving a 16 B optional handler field unless a target-specific layout check disproves the expected increase. Its stable `smallbox!` macro handles trait-object coercion; the crate's optional automatic coercion feature requires nightly. `tinybox` likewise stores a value inside the box itself only when it fits in pointer-sized inline capacity ([docs](https://docs.rs/tinybox/0.5.1/tinybox/)); its generic API is worth checking only if its actual representation fits this handler use.

[`enum_dispatch` 0.3.13](https://docs.rs/enum_dispatch/0.3.13/enum_dispatch/) eliminates per-object boxes when the implementor set is a closed enum. It is not a drop-in for `IntoHandler`: a closure expression has a unique anonymous concrete type and may capture different data, as the [Rust Reference](https://doc.rust-lang.org/reference/types/closure.html) describes. The sealed current API still accepts any `'static` closure satisfying `Fn(&mut M)`, `FieldAction` carries a generic update closure and source, and nested `ComponentRoute` wraps child handlers. A closed enum would require changing this API and listing/application-encoding its actions.

A complete owner-elimination design is therefore an explicit model action API, not a pointer trick: a model declares a compact `Action` value, `on_action(action)` stores that value in the existing row, and the model dispatches it. That removes the callback-specific type-erased owner when applications can express behavior as action values; it also changes arbitrary closure semantics and needs a deliberate way to carry per-row data such as Todo IDs and to route child-component actions through `Workspace`. It should be an additional opt-in API, not a silent replacement for `.on_click(closure)`.

A region-owned callback slab is another possible allocator formulation, but it is not free: it adds a retained pool owner, stable per-route indices or handles, route layout/alignment/drop records, and construction/failure-path work. `View::view(&self)` has no caller-provided construction arena; supplying one through TLS would impose hidden ownership/concurrency policy. An inline `El` staging representation followed by moving routes into a slab during flattening could avoid TLS but adds inline capacity to every builder row, a cold pool in the published owner, and custom move/drop logic for arbitrary captures. Without a real allocator trace showing the nonzero request cost matters, this trades one unmeasured cost for headers, branches, scratch, and more unsafe code.

Do not store captures in allocator padding or assume 8 B and 16 B requests share a portable allocator class. Rust's [`Layout`](https://doc.rust-lang.org/std/alloc/struct.Layout.html) defines the requested size and alignment contract for the allocator; no cross-allocator usable-size result was measured here.

## Probe artifacts

- Worktree HEAD: `c717df64a9b492b445fa97647deb880fb21b9ef6`.
- Tracked-only instrumentation patch: `/tmp/gpui-route-census.patch`, SHA-256 `b260d14feb1aaf6506d08d1b7dc2ce0dedd21a119432dd697086462f5f8a30ce`. The two new control examples are separately identified below because they were untracked in that patch.
- Raw logs and SHA-256:
  - `/tmp/gpui-route-census-logs/plain.log` — `4abca1ad36cd11056bad9072e617508f3213e6d810a932506c1471abb7fc64b1`
  - `/tmp/gpui-route-census-logs/method.log` — `eac97b1cb7d197d802f1fb928babd0b90618d7764fc8b74ed3b464d9d321ca59`
  - `/tmp/gpui-route-census-logs/captured.log` — `7396e88f54eaa87780562a7ac51b425a201139f66645f3b0108b5241ea334b0d`
  - `/tmp/gpui-route-census-logs/companion.log` — `d1c1c9577777a844a66379ccca66806d3607d939888297d506efafe87f497413`
  - `/tmp/gpui-route-census-logs/workspace.log` — `2e3feceab9b2b36a3119da3f4d2e076a96979af6c84bf88d15d8f45ffea45e4e`
- Added control examples: `/tmp/gpui-route-census-c717/reactivity/crates/gpui/examples/route_census_controls.rs`, SHA-256 `986a7680f8412f387251e9962e98fc38da12f9109de35a46ecd015f846ea45a8`; and `route_census_workspace.rs`, SHA-256 `a010d2cb19a769ad11e09ef9101657b91e567cca480192bc2854afcc7fea376b`.
- Modified probe sources: `element.rs` SHA-256 `44ab8d702728b0b6b01fd4d2639eb65263762a9866afb19cdf3701b441b4df72`, `runtime.rs` SHA-256 `e3b99491170e381240899761491f623a62d8b062599ca16227bb5f1706a38fd6`; the existing `contained_owner_spike.rs` probe caller SHA-256 `26fb0f0d8509bebe7758ed1e14d7c0979326b808d5d3619d0ad7559654452973`.

## Source pins

Local source links below refer to the c717 source snapshot and temporary probe overlay described above:

- [`Handler`, `Route`, and method/field route adapters`](<tmp/gpui-route-census-c717/reactivity/crates/gpui/src/element.rs>) (c717; route and probe implementations around lines 74–335, `MethodRoute` around 383, `El` around 436, `.on_click` around 645, `DraftNode` around 1064, `IntoHandler` around 1175).
- [`FieldAction`](<tmp/gpui-route-census-c717/reactivity/crates/gpui/src/source.rs>) (c717; route action layout/validation around lines 137–160).
- [`Node` and generic `Runtime<M>`](<tmp/gpui-route-census-c717/reactivity/crates/gpui/src/runtime.rs>) (c717; `Node` around 623, `Runtime<M>` around 899; route census and overlap output exist only in the temporary probe overlay).
- [`Workspace` fixture](<tmp/gpui-route-census-c717/reactivity/crates/gpui/examples/support/workspace.rs>), [`Graphics`](<tmp/gpui-route-census-c717/reactivity/crates/gpui/examples/support/graphics.rs>), and [`Todos`](<tmp/gpui-route-census-c717/reactivity/crates/gpui/examples/support/todos.rs>) (c717).
