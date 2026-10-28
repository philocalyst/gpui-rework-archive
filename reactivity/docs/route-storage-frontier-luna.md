# GPUI route-storage frontier

Research-only report for `/root/gpui-ce3/reactivity`, exact live source pin `89aeabd53942c3a4643bcb6fd978e6a24703f6d2` (2026-10-22 environment). No repo file was edited. I read the existing thin-owner census, route-density census, and corrected feasibility harness/reports. I wrote and ran only the isolated `Layout` probe listed at the end. There was no GPUI build, test run, linked dispatch comparison, Miri run, allocator usable-size trace, or RSS measurement.

## Recommendation

The strongest safe first slice is an adaptive cold route column in retained `Runtime::nodes`, with a route-present bit encoded in `Content`. This reduces the hot `Node` record from 40 to 24 bytes; it leaves `Handler` and the public route API unchanged. Store route owners in either a dense `Vec<Option<Handler>>` (16 bytes per node) or a sorted sparse `Vec<RouteSite>` where `RouteSite { node: u32, handler: Option<Handler> }` is 24 bytes per active route. Set a bounded high bit in the already packed `Content(u32)` to preserve O(1) presence checks in render, hit-sheet and accessibility scans. Since the current `MAX_NODES` is 100,000 and text/image payload encodings stay below roughly 1.6 million, a high bit is available; getters must mask it before decoding text/image indexes.

Compare actual vector request sizes/capacities when selecting the representation. With ideal exact capacity, sparse costs less than dense when `24H < 16N`, or handler density `H/N < 2/3`; include vector headers and spare capacity in the real threshold. Dense mode costs 16 bytes per row, matching the old handler payload, so a fully interactive cohort pays no per-row regression. Sparse mode costs 24 bytes per route and wins for low density. The entry key is the node slot index, not a code pointer or node identity. Sorted entries make lookup O(log H) only when a route is actually used; a dense mode gives O(1) for dense workloads.

This is a storage-policy experiment, not yet a claim of faster rendering. `Node` scans that ask only “has a route?” remain within the 24-byte hot record. Current source checks handler presence in `Node::focusable`, snapshot targeting, hit-sheet construction and accessibility action construction. Actual route access is cold in `runtime/turn.rs`; sparse lookup adds a binary search there. The current `Content` has explicit closed encodings, so reserving one high flag is maintainable and can be asserted at compile time.

The design loses if route density stays above the measured threshold, if side-vector slack makes its requested allocation larger, or if sparse binary search/maintenance materially increases activation or reconciliation work. It does not shrink `El` or `DraftNode` (still 176/152 bytes in the census), component-boundary records, or nested component route wrappers. It retains current `Handler` auto-traits and avoids the crate's `forbid(unsafe_code)` policy change. Bevy documents the same broad storage tradeoff: table/column storage favors contiguous iteration, sparse storage favors low-density membership and random lookup, with costs on both sides ([Bevy storage module](https://github.com/bevyengine/bevy/blob/main/crates/bevy_ecs/src/storage/mod.rs), [Bevy storage overview](https://github.com/bevyengine/bevy/blob/main/crates/bevy_ecs/README.md)). That precedent supports the tradeoff, not GPUI-specific speed claims.

## Exact source shape and costs

At the pinned source, `Handler` is `Box<dyn Route>` at `crates/gpui/src/element.rs:68`; its four calls are `admit`, `invoke`, `owner_scope`, and `property` (defaults on the latter two). `ComponentRoute<P,C>` nests a Handler and forwards through a component projection at `element.rs:274–320`. `El` stores `Option<Handler>` at `element.rs:383–389`, lowering moves it to `DraftNode` at `element.rs:1007–1014`, and reconciliation installs it on `Node` at `runtime.rs:623–630, 2044–2063`. The pinned layout assertions say `Node=40`, `DraftNode=152`, `El=176`, `Option<Handler>=16`; `Node`'s other fields occupy 24 bytes. `Content` is a `u32` with low four kind bits and a bounded text/image payload at `runtime.rs:551–609`; `MAX_NODES=100_000` at line 30. The relevant cold route access paths also include `runtime/turn.rs:313–354, 402` and dynamic inspector installation at `runtime/inspector.rs:626`.

The adaptive column's representation-specific burden is concentrated in reconciliation, activation and inspector writes. Reconciliation must transfer an old route by its old node index, compare old/new route presence, and build the next sorted column as nodes are emitted. A binary search per reused row is a worst-case O(N log H) rebuild; merge/index-assisted traversal or a dense old lookup during the cold rebuild should be compared before accepting that cost. Activation needs a take/restore operation for property routes, including restoration before quarantine on callback panic. `runtime/turn.rs` currently takes the route out of its node and restores it around the callback; a sparse entry can store `Option<Handler>` so taking does not shift later keys. Inspector writes need an ordered insert/update operation. Drop timing will move from `Node` field-drop order to the side column's drop order; test captured destructors that observe order and panic. Keep old-sheet quarantine semantics after a callback panic and pending component-parent forwarding intact.

The sparse capacity must be priced from actual `Vec::capacity`, not only `len`. Avoid computing savings by adding the `El`, `DraftNode`, and retained `Node` row deltas as simultaneous arrays: they overlap differently across description/reconciliation phases. Existing census artifacts report actual current route shapes but do not measure global allocator requests or usable classes; the 128 captured-usize control models 1,024 B baseline versus 2,048 B for the old head-header thin sketch, and the sample Workspace models 616→656 B of retained route-object requests. These are type/layout request models, not total memory results. See the checked-in census report and logs for their limits.

## Owning thin route: best complete allocation formulation

If a follow-up is justified, a candidate one-word owner still uses a tagged `NonNull<()>`, a static per-concrete-type operation table, and an allocation for non-ZST captures. The earlier proposal placed the table before `T`, which made the requested header allocation grow with over-alignment. Instead put the operation pointer **after** `T` and let the owner point at the operation-pointer slot:

```rust
// Sketch only. T:'static is required; allocation/drop stays private and unsafe.
let (layout, ops_offset) = Layout::new::<T>().extend(Layout::new::<&RouteOps>())?;
// allocate with `layout` exactly as returned (do not pad_to_align for a single record)
// write T at base and `&T::OPS` at base + ops_offset
// owner addresses base + ops_offset; each T-specific thunk knows ops_offset
```

Rust's `Layout::extend` aligns the following field and deliberately omits trailing padding; `pad_to_align` is required to mimic a C struct/array, not for a one-record allocation. This makes the requested overhead at most 15 bytes at 8-byte pointer alignment, regardless of `align_of::<T>()`: if `align(T) >= 8`, `size(T)` is already an 8-byte multiple and overhead is 8; if `align(T) < 8`, padding before the 8-byte pointer is at most 7, so overhead is 8–15. `Layout::extend` checks overflow and its result alignment is the max of the two fields. The allocation and deallocation must use the exact same unpadded `Layout`; a `#[repr(C)] struct { value: T, ops: &RouteOps }` has tail padding and does not retain this bound. The Rust `Layout` contract permits valid sizes that are not alignment multiples and explicitly distinguishes `extend` from `pad_to_align` ([Rust `Layout`](https://doc.rust-lang.org/std/alloc/struct.Layout.html)).

A captured owner then has one extra table-pointer load before dispatch, and a larger requested allocation by 8–15 bytes (before allocator-class rounding). That bound removes the *layout* penalty from high alignment, not allocator rounding: align-64/128 small objects may still land in costly allocator classes. The table contains the existing operations (`admit`, `invoke`, `owner_scope`, `property`, `drop`); preserve the private Route ABI and all error/forwarding branches. Keep the method dispatch on the cold route path. A single `NonNull<()>` with `PhantomData<Box<dyn Route>>` is the shape already shown in the corrected feasibility harness; it must retain the corrected `'static` bound and ordinary `Unpin` behavior. Never use table/function address equality as route identity.

Root found an important missing address proof in the original report: a handle at
the value's base cannot locate a tail table at a type-dependent offset before it
knows the type. The handle must instead address the tail slot, where the table
pointer is at a fixed offset of zero. Each monomorphized thunk can then subtract
its known `ops_offset::<T>()` to recover the value and allocation base. That
interior pointer must retain the original allocation's provenance. Drop must
recover the same base and unpadded Layout, install a deallocation guard before
calling T's destructor, and free through unwind. This address formulation has
not been implemented or soundness-tested; the standalone probe establishes only
the requested Layout arithmetic. The original base-pointing sketch is rejected.

For ZST routes, the table pointer can itself be the tagged handle: align the static table to at least two and preserve provenance with `map_addr`; construct aligned `NonNull::<T>::dangling()` for calls/drop and `forget(value)` when ownership transfers. This is required even when `T` has no data bytes: a ZST can still have Drop glue, including a panicking destructor. The static table is operation metadata, not type identity. A no-drop ZST route still needs a per-concrete-type call path under the existing open `IntoHandler` closure API. A single tagged pointer can instead be a monomorphized dispatcher function pointer invoked with an operation enum, avoiding a table *object*, but it still stores per-type executable metadata and adds ABI/conversion questions; it is not a metadata-free route. Do not use a function/code address as identity. The promoted associated-const table is the less surprising stable formulation, and deduplication/overlap is harmless if table addresses are never compared.

The standard-library `ThinBox` source is the best implementation reference for checked header layouts, ZST metadata promotion, forgetting transferred ZST values and a drop guard that deallocates through unwind ([Rust 1.97 ThinBox source, `new` and layout](https://github.com/rust-lang/rust/blob/1.97.1/library/alloc/src/boxed/thin.rs#L229-L309), [ZST metadata and drop guard](https://github.com/rust-lang/rust/blob/1.97.1/library/alloc/src/boxed/thin.rs#L310-L401)). `ThinBox` itself is nightly-only (`thin_box`, issue #92791) according to the [official API docs](https://doc.rust-lang.org/std/boxed/struct.ThinBox.html). The thin sketch remains a narrow unsafe crate-policy exception, not a way around `#![forbid(unsafe_code)]` in GPUI; the corrected control explicitly does not establish Miri soundness or integration safety.

### Thin-owner counters and losses

The row saving remains 8 bytes for every `Option<Handler>` in `El`, `DraftNode`, and `Node`, independent of handler presence. The static operation table keeps ordinary method-item ZST routes allocation-free, matching `Box::new`'s documented no-allocation behavior for ZSTs ([`Box::new`](https://doc.rust-lang.org/std/boxed/struct.Box.html)). For non-ZST routes the tail pointer adds 8–15 requested bytes per route. A captured one-usize method route still requests 16 bytes instead of 8 on the current x86_64 layout, so dense captured routes do not prove a payload win; at high alignment, the revised tail layout avoids the huge padding of the head-header version. Nested `ComponentRoute` has a payload that loses 8 bytes when its nested Handler thins, then gains a tail table pointer; in the sample its requested wrapper payload can remain neutral. Do not add row savings over three arrays without exact live phase/capacity accounting.

This representation adds an allocation read/branch (tagged ZST versus captured), more static op shims/code/rodata, custom allocation/deallocation, and tests around callback panic, destructor unwind, alignment, and route lifetime. It changes no public API or callback invocation ABI, but unsafe auto-trait/lifetime/variance/drop-check behavior must match current `Box<dyn Route>` exactly. No unsafe `Send`/`Sync` impl is warranted. Compare `Unpin`, unwind-safety markers, and the explicit `'static` constructor bound. Component property forwarding currently reaches into the nested object directly; route integration must route that through the wrapper while preserving callback order and the exact return/error behavior.

`Bevy::OwningPtr` is not a complete owner substitute: its docs say dropping drops the value but does not free the allocation; its ECS design has a `ComponentInfo` registry carrying type-specific operations and layouts ([Bevy pointer/storage docs](https://docs.rs/bevy/latest/bevy/ecs/ptr/index.html)). That requires a new registry/runtime owner in GPUI. An inline-dyn/small-box design avoids some allocations for small captures but still occupies route metadata plus inline payload on every handler slot, including absent routes; it does not solve the 16-byte `Option<Handler>` row. A callback slab adds a pool owner, stable indexes, layout/drop metadata, and transfers at description time. An explicit model action enum removes type erasure only by changing the open arbitrary-closure API. Each loses on a different current constraint; the sparse safe column is the only candidate here that improves Node row density without reworking those route semantics.

## Smallest Sol spike and gates

1. Add only a `HandlerSites` prototype to the retained runtime, with dense and sparse safe variants and a high-bit route-present flag in `Content`; keep `Handler` as `Box<dyn Route>` and leave `El`/`DraftNode` unchanged. Add compile-time assertions for `Node=24`, `Content` encoding bounds, `RouteSite=24`, and candidate side-vector requested sizes. No changes to public `.on_click`, Route methods, dispatch ABI, or source admission.
2. Change the exact access sites listed above, including property take/restore and inspector route writes. Preserve route transfer from old identity slots, component boundary forwarding, parent-scope validation, source admission quarantine and pending parent projection. Use Content's present bit for `focusable`/hit/accessibility scans; lookup the route column only in actual activation/admission/property paths.
3. Add meaningful targeted lifecycle tests before integration: unchanged route invocation and admission errors; component nesting/property proposal+reply; sparse insertion/removal and sorted lookup after node reordering; dense↔sparse conversion; route replacement and destructor counts/order; destructor panic and source quarantine; property callback take/restore; dynamic inspector route update; all-handler and no-handler controls. Then run the relevant existing GPUI checks requested by root. Do not treat the compile-time layout assertions as a memory win.
4. Gate adoption on current-HEAD examples with real counts and a capture/density histogram, exact `Vec` capacities and requested allocation bytes in build/reconcile peak phases, a dense versus sparse activation lookup measurement, and a scan/codegen control. Use the existing source-census caveat: the old `append_probe` modified Route's vtable and cannot support linked/timing claims. Keep its results separate from authoritative performance data. Select the adaptive threshold from actual capacities/allocator classes on supported allocators; require no regression for a dense all-route cohort.

Thin-owner spike should remain a separate branch only if the safe column leaves a material row floor. Its first experiment should test the tail header with align-1/2/8/16/64/128 captures, align-128 ZST Drop, ZST and captured destructor panic, allocation failure/overflow handling, lifetime compile-fail, and auto-trait assertions; then Miri when available and component/property/lifecycle integration tests. The existing corrected standalone passed ordinary Rust 1.97.1 execution but Miri is unavailable; it is not evidence of soundness.

## Isolated Layout probe

Temporary source: `/tmp/gpui-tail-layout.rs`. Exact command (using the workspace Rust 1.97.1 and pinned linker):

```sh
/nix/store/lynmg3kdpdz41r84nafwzi2n5nss50pq-rust-1.97.1-with-components-2026-07-16/bin/rustc \
  --edition=2024 \
  -C linker=/nix/store/m59w5gavjx8db0ay3m1yzbw02l54109b-clang-wrapper-21.1.8/bin/cc \
  /tmp/gpui-tail-layout.rs -o /tmp/gpui-tail-layout
/tmp/gpui-tail-layout
```

Observed Rust 1.97.1 x86_64 output:

```text
T=1 align=1 Head=16 Tail=16 TailOff=8 request=16 request_align=8 offset=8 overhead=15
T=16 align=16 Head=32 Tail=32 TailOff=16 request=24 request_align=16 offset=16 overhead=8
T=64 align=64 Head=128 Tail=128 TailOff=64 request=72 request_align=64 offset=64 overhead=8
T=128 align=128 Head=256 Tail=256 TailOff=128 request=136 request_align=128 offset=128 overhead=8
T=64 align=64 Head=128 Tail=128 TailOff=64 request=72 request_align=64 offset=64 overhead=8
T=128 align=128 Head=256 Tail=256 TailOff=128 request=136 request_align=128 offset=128 overhead=8
```

This compiles both `repr(C)` head/tail mirrors and measures the deliberately *unpadded* `Layout::extend(T, &Ops)` allocation request. It is not an allocator usable-size test and does not execute unsafe allocation/drop code. The first initial compile omitted a linker and failed because `cc` is absent; rerun with the command above succeeded. `rustc --version` was `rustc 1.97.1 (8bab26f4f 2026-07-14)`.

Primary references: [Rust Reference, Rust layout guarantees](https://doc.rust-lang.org/stable/reference/type-layout.html), [Rust `Layout::extend` and `pad_to_align`](https://doc.rust-lang.org/std/alloc/struct.Layout.html), [Rust pointer provenance and `map_addr`](https://doc.rust-lang.org/std/ptr/), [Rust `ThinBox` API stability](https://doc.rust-lang.org/std/boxed/struct.ThinBox.html), [Bevy table vs sparse-set tradeoff](https://github.com/bevyengine/bevy/blob/main/crates/bevy_ecs/README.md).

Root review corrected the tail-slot address formulation and the two ThinBox GitHub anchors to actual Rust file line numbers (229–309 and 310–401), verified against the installed 1.97.1 rust-src. The original report bytes are retained separately. The current std Layout documentation also confirms that extend omits trailing padding; its site now serves Rust 1.99.1, while the probe uses 1.97.1.
