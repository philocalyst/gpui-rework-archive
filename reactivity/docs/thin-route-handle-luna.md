# Thin owning route handle: bounded research review

**Scope and pin.** Read-only source audit of GPUI cleanroom commit `1d5bc3061cce3beb3c4857102ed651da501b5cfd` in `/root/gpui-ce3`, using `git show <pin>:<path>` (not the later live `HEAD`, which is `312b8c5896d104bbae0e50da9213da497b70e06b`). No repository edits, builds, allocation measurements, timings, or generated assembly were performed. The conclusion is a prototype hypothesis, not a shipping recommendation.

## Finding

A one-word, owning `Handler` is implementable in principle without a new runtime owner or consumer macro: use one `NonNull<()>` handle, encode a static ZST operation-table pointer versus an allocation-base pointer with one alignment-guaranteed tag bit, and place an operation-table pointer before each non-ZST route value. Generic operation shims preserve the existing private `Route` methods. This can reduce each stored `Option<Handler>` by one pointer, including rows whose handler is `None`, while keeping captureless method items allocation-free.

The memory win is conditional. Every non-ZST captured route allocation grows by a header plus alignment padding. At 64-bit pointer width, the common low-alignment case adds 8–15 requested bytes, so the one-word row saving is canceled for dense captured routes and can be exceeded for small captures. Component wrapping happens to be a useful offsetting case: its nested handler shrinks the component-route payload by 8 bytes while its new outer allocation header adds 8, leaving that outer allocation at the same requested size. The component-boundary node itself also shrinks by 8 bytes. The likely favorable workload is therefore sparse routes, many empty handler slots, or nested component routing; the current source does not establish that distribution. Route storage density, allocator size classes, linked dispatch cost, and code/rodata need measurement before adoption.

## Pinned production shape and byte ledger

The exact source has `Handler(Box<dyn Route>)` at `reactivity/crates/gpui/src/element.rs:66–84`. `Route` has four operations: `admit`, `invoke`, `owner_scope`, and `property`; the last two have defaults. Handler forwards those operations at `element.rs:158–205`. `ComponentRoute` forwards through an inner Handler at `element.rs:230–280`; its property branch directly uses `self.handler.0.property` at lines 265 and 274, so changing the tuple field representation also requires routing those calls through the new owner wrapper. The handler is moved from `El` to `DraftNode` at `element.rs:335–345, 912–920, 962–969`, and then into retained `Node` at `runtime.rs:622–629, 2052`.

On the pinned 64-bit test target, existing tests assert `Handler = 16`, `Node = 40`, `Option<Node> = Node`, `El = 176`, and `DraftNode = 152`; the `Handler` assertion is at `element.rs:1290–1298`, the Node assertions at `runtime.rs:338–342` and `runtime.rs:472–482`, and the El/DraftNode assertions at `runtime.rs:472–482` (the element size ledger prints them at `element.rs:1591–1599`). `Component<(),()> = 40` is explicitly asserted at `component.rs:123–135`.

| Owner/payload | Pinned baseline | Candidate arithmetic on 64-bit | Consequence |
|---|---:|---:|---|
| `Handler` | 16 B | 8 B `NonNull<()>` | Requires the representation and niche to be asserted on each target. |
| `Option<Handler>` slot | 16 B | 8 B with a transparent one-word wrapper | Saves 8 B for every slot, present or absent. |
| `Node` | 40 B | 32 B if all other fields and padding remain as audited | The runtime node array gets 8 B narrower per node. |
| `El` | 176 B | 168 B on the pinned target if its one handler slot is the only changed field | One less word in each element, including handler-free leaves. |
| `DraftNode` | 152 B | 144 B on the pinned target on the same condition | One less word in every lowered row. |
| `ComponentBoundary` payload | 24 B (`Option<Handler>` + next pointer) | 16 B | The boxed boundary record saves 8 B. |
| `ComponentRoute<P,C>` concrete payload | 56 B (`Component=40` + nested `Handler=16`) | 48 B before new header | Header + payload is 56 B when alignment is 8, so this outer route allocation is byte-neutral in requested layout. |

These are layout projections, not candidate measurements. `Option<NonNull<T>>` is guaranteed to match `NonNull<T>` size/alignment; extending that guarantee to the private newtype should be done with a single-nonzero-field `repr(transparent)` design and compile-time assertions. Current Rust docs describe DST pointers as at least one thin pointer and currently twice pointer-width, while explicitly warning that the exact wide size is not a guarantee; the GPUI test is the target-local baseline.

For a non-ZST concrete route `T`, a straightforward allocation is:

```rust
#[repr(C)]
struct Header<T> {
    ops: &'static RouteOps,
    value: T,
}
```

The requested layout is `Layout::new::<Header<T>>()`, not `8 + size_of::<T>()` in general. If pointer size/alignment is 8 and `align_of::<T>() <= 8`, then the value offset is 8 and the header layout is `round_up(8 + size(T), 8)`: the added requested bytes range from 8 through 15. If `T` is over-aligned, the header must use `Layout::extend` (or an equivalent checked layout computation); the prefix and final padding can add at least `align_of::<T>()` bytes. Allocator class rounding may add more. A `T` whose `Header<T>` layout overflows must be handled through checked layout/allocation failure, not unchecked offset arithmetic.

If there are `N` route slots in one retained row collection and `H` non-ZST handlers, the idealized requested-byte delta for that owner is `-8*N + Σ(layout(Header<T_i>).size - layout(T_i).size)`, before allocator class rounding. ZST handlers add no header allocation. Do not add the savings for El, DraftNode, and Node as though all three arrays necessarily coexist; measure each phase’s live overlap. This formula explains why a lower row size alone does not prove lower total memory.

Concrete route shapes in the pinned source are mixed. `MethodRoute<M,F>` uses `PhantomData<fn(M)>` and is explicitly documented as zero-sized when `F` is a method item (`element.rs:283–305`); tests prove both a method item and a two-captureless-closure `PropertyRoute` are ZST values (`element.rs:1290–1324`). A zero-sized value may still have Drop glue. `FieldAction` contains a `Source` plus its update closure (`source.rs:54–58, 136–140`), and is not the ZST case. `ComponentRoute` is always non-ZST because it embeds `Component` and the nested Handler. `WindowAction` is an enum wrapper (`runtime/inspector.rs:46–49`). No source inventory says what fraction of mounted routes are ZST, captured, component-wrapped, or absent.

## Candidate representation and its constraints

A minimal conceptual representation is:

```rust
#[repr(C)]
struct RouteOps {
    admit: for<'a, 'b> unsafe fn(*const (), &'a dyn Any, &'b dyn Any) -> Result<Admission, BindError>,
    invoke: for<'a> unsafe fn(*const (), &'a mut dyn Any) -> Result<(), BindError>,
    owner_scope: for<'a, 'b> unsafe fn(*const (), &'a dyn Any, &'b dyn Any) -> Result<u32, BindError>,
    property: for<'a> unsafe fn(*const (), PropertyPhase<'a>) -> Result<(), BindError>,
    drop: unsafe fn(*mut ()),
}

#[repr(C)]
struct Header<T> {
    ops: &'static RouteOps,
    value: T,
}

#[repr(transparent)]
struct Handler {
    tagged: NonNull<()>,
    // Add zero-sized ownership/auto-trait markers only after checking parity.
}
```

For a non-ZST `T`, the handle points to `Header<T>` and its operation shims recover `value` at the `repr(C)` offset. For a ZST `T`, it points to an immutable promoted `RouteOps` table with a tag bit set; the shims operate on `NonNull::<T>::dangling()` and the drop shim runs `drop_in_place` so a zero-sized capture with a destructor still drops once. The table address must have guaranteed low-bit alignment (for example, `repr(align(2))`), and heap header addresses are already at least pointer-aligned. Tag and untag with `NonNull::map_addr` so provenance is preserved; never round-trip the address through an integer cast. The Rust docs identify `map_addr` as a strict-provenance operation and guarantee that `Option<NonNull<T>>` is pointer-sized.

Do not define a `static TABLE<T>` inside a generic function: Rust’s Reference says a static in generic scope is one shared static, not a separate item per monomorphization. A reference to a generic constant rvalue may be promoted (`&None::<T>` is the RFC example), but the precise route-table form should be compile-tested on the project toolchain. Table addresses must not serve as type identity: promoted constants may be deduplicated/overlap. Only the immutable function-pointer contents matter. Avoid unstable trait-object metadata APIs (`ptr::metadata`/`Pointee`) and fat-pointer transmute; both are not needed for a custom table, and the metadata APIs remain nightly-only.

For the tagged ZST arm, all shims must reconstruct an aligned dangling `T` pointer and make only valid zero-sized accesses. This is not permission to skip destructors. The constructor must also `mem::forget(value)` after transferring logical ownership into the static-table handle; otherwise a ZST route with Drop glue is dropped at constructor return and then dropped again when Handler dies. The standard library ThinBox ZST path does this explicitly. For captured routes, the table shim must use the exact `Header<T>` offset and the allocation must be deallocated with the exact header layout, including high-alignment padding. A typed `Box<Header<T>>` reconstruction in the per-type drop shim is safer than an improvised `dealloc`; if manually dropping and freeing, a cleanup guard is required so a panicking route destructor still frees the header and cannot be called twice.

Preserve ownership semantics and auto traits. Handler is move-only today and the route moves through El → DraftNode → Node without cloning. The current `Box<dyn Route>` is not Send/Sync because the object bound omits those auto traits; `NonNull` is also documented !Send/!Sync, but any explicit marker or unsafe impl needs review. Check `Unpin`, `UnwindSafe`, `RefUnwindSafe`, variance, and drop-check parity too: raw pointer wrappers can change auto-trait behavior even when their byte layout is correct. No unsafe `Send`/`Sync` implementation is warranted. Keep Handler’s identity as the installed node site, never compare code/table addresses to decide route identity.

The operations table must preserve all current branches exactly: admission errors, component projection, window action admission, property proposal/reply, default owner scope, and default property panic. In particular, property routing in ComponentRoute currently reaches into the inner trait object directly. Refactoring must not bypass the route’s `admit` or change callback timing.

## Alternatives and precedent

The standard library already has the closest design in `ThinBox<dyn Route>`: one pointer-sized owner, metadata in an allocation header for non-ZST values, and special static metadata storage for a ZST unsize. However, `std::boxed::ThinBox` is still nightly-only under `thin_box` (#92791), so it is not presently a stable replacement. Its implementation is the strongest design reference: checked `Layout::extend`, correct data/header offset computation, a ZST metadata path, and a drop guard that deallocates even if the value’s destructor unwinds. It also confirms that a thin owner relocates metadata; it does not make per-instance metadata disappear.

Bevy’s `Ptr`/`OwningPtr` is not a direct fit. Its `OwningPtr` represents ownership for destruction but explicitly does not free the pointed allocation, because it can refer into a Vec or stack object; its `drop_as<T>` caller must know the concrete type. Bevy puts type/layout/drop metadata in a separate `ComponentInfo` descriptor owned by its World/component registry. That is a valid system-level formulation but violates this task’s “no new runtime owner/header” constraint if copied into GPUI merely to make Handler one word. A closed enum is not a substitute for arbitrary user closure capture types. Keeping the safe `Box<dyn Route>` is currently the clear low-risk baseline.

## Costs and adversarial cases

- **Pointer tagging/provenance:** prove both arms keep the original allocation/static provenance; clear the tag before any dereference; don’t use address equality as a type key. The static table is immutable and must remain valid for the whole program.
- **Alignment/layout:** cover alignments 1, 2, 8, 16, and a larger power of two; verify both value offset and deallocation base/layout. Tagging is only sound if the tagged pointer’s source is guaranteed to have that low bit clear.
- **ZSTs:** test a method item, a zero-sized closure with a `Drop` capture, prove construction does not drop it, then prove repeated move/drop runs Drop exactly once, and test a panic from Drop. Current Box also has no heap allocation for ZST values, so the candidate’s ZST benefit is only the narrower owner slot, not fewer allocations.
- **Non-ZSTs:** test a small byte capture, pointer-sized capture, the FieldAction/PropertyRoute/WindowAction shapes, and nested ComponentRoute. Confirm each admitted/invoked/property callback receives identical inputs and errors.
- **Panic safety:** a destructor panic must run once and not leak its Header. Panic-abort builds are not a substitute for unwind testing where unwind is supported.
- **Lifecycle:** move the owner through Element flattening, DraftNode creation, validation rejection, Node replacement, and Element/ComponentBoundaries iterative drop. Confirm no aliasing or duplicate drop on failed lowering and old-node replacement.
- **Hot path:** current captured `Box<dyn Route>` carries data and vtable pointers together in the row. The thin captured path loads the vtable pointer from the allocation before loading an operation pointer; a tagged branch is added at dispatch. Admission is used during mount validation, so do not assume route dispatch is cold. Compare linked release `admit`, `invoke`, `property`, and Drop code plus `.text`/`.rodata`; source alone cannot say whether this is acceptable.

## Smallest next control

Only proceed in an isolated worktree after route-distribution instrumentation is available. A private Handler-only prototype should first prove: (1) `size_of::<Handler>()` and `Option<Handler>()` are 8 on the target, with Node/El/DraftNode projections; (2) ZST values allocate zero times and still drop exactly once; (3) a captured value allocates the computed `Header<T>` layout and is freed once under normal and unwind drops; (4) route behavior is differential-equal to the Box baseline for every Route variant and component nesting; (5) Miri rejects no tagged-pointer access under strict provenance. After that, count live owner sizes by route kind and active-handler density in representative apps, and inspect linked release dispatch code, table `.rodata`, and allocator request/size-class effects. Adopt only if the measured retained-byte win survives capture headers and the extra dispatch load/code cost is acceptable. No speedup or memory reduction is established by this report.

## Primary references

- GPUI pinned source: `1d5bc3061cce3beb3c4857102ed651da501b5cfd`, `reactivity/crates/gpui/src/element.rs`, `runtime.rs`, `component.rs`, `source.rs`, and `runtime/inspector.rs` (exact paths/lines above).
- Rust Reference, trait-object pointers carry data plus a vtable: https://doc.rust-lang.org/stable/reference/types/trait-object.html
- Rust Reference, type layout: DST pointer size is at least a thin pointer; exact two-word size is explicitly not guaranteed: https://doc.rust-lang.org/stable/reference/type-layout.html#pointers-and-references-layout
- `Option<NonNull<T>>` size/alignment guarantee and strict-provenance `map_addr`: https://doc.rust-lang.org/stable/core/ptr/struct.NonNull.html
- Strict provenance pointer APIs: https://doc.rust-lang.org/stable/std/ptr/
- Static items in generic scope are not per monomorphization: https://doc.rust-lang.org/stable/reference/items/static-items.html#statics--generics
- Generic rvalue promotion RFC (example `fn generic<T>() -> &'static Option<T> { &None::<T> }`): https://rust-lang.github.io/rfcs/1414-rvalue_static_promotion.html
- `Box::new` makes no allocation for a ZST: https://doc.rust-lang.org/stable/std/boxed/struct.Box.html#method.new
- Stable docs currently mark `ThinBox` nightly-only (`thin_box` #92791): https://doc.rust-lang.org/stable/std/boxed/struct.ThinBox.html
- Standard-library ThinBox implementation (header layout, static ZST metadata, unwind DropGuard): https://doc.rust-lang.org/stable/src/alloc/boxed/thin.rs.html
- `Pointee`/metadata extraction remains nightly-only (`ptr_metadata` #81513): https://doc.rust-lang.org/stable/core/ptr/trait.Pointee.html
- Bevy `OwningPtr` contract (drop ownership, no allocation free): https://docs.rs/bevy_ptr/latest/bevy_ptr/struct.OwningPtr.html and https://docs.rs/bevy_ptr/latest/src/bevy_ptr/lib.rs.html
- Bevy `ComponentInfo` registry-backed descriptor: https://docs.rs/bevy_ecs/latest/src/bevy_ecs/component/info.rs.html
