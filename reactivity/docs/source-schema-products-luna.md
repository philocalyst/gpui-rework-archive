Research only. Read the follow-up erasure/root-dispatch corrections together. The private TAIT combination now compiles in a small isolated experiment, including instantiated recursion and stable-toolchain rejection controls; see [constructibility evidence](../evidence/schema-owner-tait/README.md). No production schema rewrite, memory/performance win or complete authority proof is established.

# Sources schema allocation: typed product, erased once

Status: **proposed formulation only**. Read-only inspection; no code/build/test/timing was done. Audited against `/root/gpui-ce3/reactivity` current `source.rs`, `lib.rs`, `component.rs`, `element.rs`, `reader/inputs.rs`, and `runtime.rs`. Static Sol worktree was observed as modified at `a6ac3ea81f`; this report does not depend on its edits or recommend overlapping them.

## Finding

The cleanest all-safe way to remove per-field boxes without changing the source model’s authority is a *typed product of borrowed descriptors*, recursively composed through child component schema values, then erased at most once at the mounted-owner boundary. The child RPITIT type does not have to be named: pass `C::source_schema()` to a generic constructor whose `S` parameter is inferred, and store that `S` inline in `ComponentNode<P,C,S>`. The parent’s own RPITIT return hides the resulting nested product type. This is exactly the place RPITIT helps: it hides the product from users while retaining its concrete type for monomorphized implementation code. Rust documents that each RPITIT is an anonymous associated type and that a return-position `impl Trait` is an unboxed concrete type selected by the implementation ([Reference: `impl Trait`](https://doc.rust-lang.org/reference/types/impl-trait.html), [Rust 1.75 announcement](https://blog.rust-lang.org/2023/12/28/Rust-1.75.0.html)).

There is a real API boundary cost: keep legacy `View::sources() -> Sources<Self>` and add a second defaulted `View::source_schema() -> impl Schema<Self>`, whose default wraps `Self::sources()` in a legacy adapter. New implementations override `source_schema`; existing implementations continue to compile and keep old behavior. Runtime mounts either schema through a stable `MountedSources<M>` facade so existing `Any` downcasts in handler admission need not know an RPITIT’s hidden type. The facade stores `Option<Box<dyn Schema<M>>>`: `None` for an empty schema, one box/allocation for a nonempty typed root, and no child boxes. This avoids an associated-type migration (associated types have no default implementation in the Reference) and avoids trying to specialize on whether a view overrides `sources` ([Reference: associated types](https://doc.rust-lang.org/reference/items/associated-items.html)).

## Concrete API shape

```rust
pub trait View {
    fn view(&self) -> El<'_>;

    // Compatibility entry point, unchanged.
    fn sources() -> Sources<Self> where Self: Sized { Sources::new() }

    // New entry point. Old implementations flow through the adapter.
    fn source_schema() -> impl Schema<Self> where Self: Sized {
        Legacy(Self::sources())
    }
}

struct Nil; // ZST, `is_empty() == true`
struct Cons<H, T> { head: H, tail: T }
struct FieldRef<M, T, Dep> { source: &'static Source<M, T>, _dep: PhantomData<Dep> }
struct ComponentNode<P, C, S, Dep> {
    declaration: &'static Component<P, C>,
    child: S,                    // the unnameable C::source_schema() type
    scope: ScopeRange,           // or derive the range during traversal
    _dep: PhantomData<Dep>,
}

fn component<P, C: View, S: Schema<C>, Dep>(
    declaration: &'static Component<P, C>, child: S,
) -> ComponentNode<P, C, S, Dep> { ... }

impl View for Parent {
    fn source_schema() -> impl Schema<Self> {
        schema::empty()
            .field::<OwnerDependency>(&PARENT_VALUE)
            .component::<ParentDependency>(&CHILD, Child::source_schema())
            .direct_component::<DirectOnly>(&OTHER_CHILD, OtherChild::source_schema())
    }
}
```

`S` is inferred at each call; it is not named in the parent or child source code. The product may use a type-level HList or nested tuples. `Schema<M>` needs an object-safe mounted surface for `validate`, `resolve`, `signal`, `revision`, `invalidates_owner`, `write_text`, `scan`, and child lookup; each implementation is generic over its concrete product, so those operations recurse into typed leaf implementations rather than allocating/dispatching through one `Box<dyn Field>` per descriptor. A `ComponentNode` implements the component lookup interface and exposes its child schema as a borrowed `&dyn Schema<C>` only at the handler boundary; it does not box the child. The root wrapper can retain a concrete `MountedSources<M>` type for `Route::admit`/`owner_scope` downcasts currently expecting `Sources<M>` in `element.rs`.

The source and component declaration values must be borrowed from `'static` storage. `static` declarations are unambiguous; `&Source::new(...)` is also a candidate because the Source contains only immutable scalar/function-pointer data and no destructor/interior mutability, which meets the Reference’s constant-promotion description, but that spelling should be compile-tested before promising it. The reference’s address is storage only: field identity remains `FieldId` plus name and validated projector behavior; never use the address as identity ([Reference: constant promotion](https://doc.rust-lang.org/reference/destructors.html#constant-promotion)).

```rust
static VALUE: Source<Model, String> = Source::new(...);
static CHILD: Component<Parent, Child> = Component::new(...);
// field(&VALUE), component(&CHILD, Child::source_schema())
```

A legacy adapter can report runtime emptiness before allocating the root box. A typed `Nil` schema is statically empty/ZST; the mounted facade uses no heap for it. A nonempty typed schema costs one root Box payload and the inline product. This formulation shares descriptor payload across owners but still stores one pointer per field in each owner’s product; it does **not** provide a process-shared mounted schema tree.

## Why the hidden child type works—and where it stops

For generic code, define `fn child<P,C,S: Schema<C>>(decl: &'static Component<P,C>, schema: S) -> ComponentNode<P,C,S>`. At the call `child(&CHILD, C::source_schema())`, type inference chooses the RPITIT hidden type for `S`; no caller names the opaque associated type. The returned parent method then hides the whole nested product behind its own `impl Schema<Parent>`. This is normal generic inference over the anonymous associated type, not dynamic dispatch.

Runtime-sized heterogeneous child collections are the boundary. A `Vec` can hold repeated children of the same `C` because each `C::source_schema()` has one hidden type, but a collection whose elements have different concrete schema/product types requires an enum, a trait-object boundary, or a homogeneous erased representation. The current declaration API creates a fixed schema tree in `View::sources()`; do not silently promise dynamic heterogeneous schema lists without adding one of those representations. Repeated same-C slots still need distinct local component IDs, unique names, deterministic preorder scope ranges, and per-slot parent/direct dependency mode.

## Safe contiguous erased alternative

A lower-risk intermediate is `Vec<&'static dyn Field<M>>` where each static `Source<M,T>` implements `Field<M>`, replacing `Vec<Box<dyn Field<M>>>`. It changes per direct-field storage from a pointer in the vector plus a separately allocated Source payload to a 16-byte fat reference in one vector allocation. It removes N field allocations and avoids copying the 40-byte Source payload per owner, but retains per-field virtual calls and still needs an allocated vector. Existing `component` entries can remain separately boxed as a migration step; then this is not “erase once” and child source vectors remain. A fully flattened safe vector of arbitrary child-composed `Source<M,T>` values is not available just by storing a function pointer: a root projector is a composition of runtime-captured child and field projectors, and a generic typed `fn(&M)->&Signal<T>` cannot close over those two function pointers. Boxing a closure per row reintroduces allocation; transmuting function-pointer/data pairs or raw offsets violates the safe/no-raw-offset constraint. A typed product carries the composition in its generic types and inline values instead.

There is also a ZST marker formulation: each field marker `F` supplies `const SOURCE: Source<M,T>` and projection methods, so a schema product can be ZST and pull declarations from associated constants. It needs a named marker type per field (or generated code); stable const generics cannot parameterize a type by a function pointer or `&str` because the allowed const-parameter types are integer types, `char`, and `bool` ([Reference: const generic parameter types](https://doc.rust-lang.org/reference/items/generics.html#const-generics)). That is less ergonomic than static references and should be treated as an opt-in extreme, not the default macro-free API.

## Exact responsibilities that must survive

* The current `Source` is 40 bytes on 64-bit targets: `FieldId` (8), `&'static str` (16), and read/write function pointers (8 each), as defined in `source.rs:36-48`; component declarations have the analogous 40-byte shape in `component.rs:18-23,30-42`. Current direct `Sources::direct` allocates `Box::new(source)` for each field and stores the fat pointer in a `Vec`; `field` also appends an owner dependency ID (`source.rs:711-753`). Component registration builds the child schema at every parent schema construction, assigns a checked preorder half-open scope range, tracks maximum depth, then boxes a `ComponentEntry` (`source.rs:773-825`).
* Preserve schema errors for nonlocal declaration IDs, duplicate component IDs, duplicate IDs/names across direct fields and component names, checked scope overflow and the 128-component-depth bound (`source.rs:729-750,781-816`). With a type product these checks move to mount-time traversal (or a construction-time accumulated error value); they cannot disappear because the current fluent builder is infallible and records errors for later validation.
* Preserve exclusive read/write projector agreement at mount and before mutation, signal alias rejection across direct and nested fields, stable identity by matching projected `Signal<T>` rather than equal value or declaration address, scoped IDs, direct-vs-owner invalidation, and child handler receiver/projection checks (`source.rs:537-563,624-646,872-898`; `component.rs:50-57`; `element.rs:270-300,350-378`). `FieldId` currently reserves scope `u32::MAX` and uses checked half-open allocation; retain this exactly (`source.rs:9-33`).
* Keep typed `Source<M,T>` at the leaf. `FieldAction` checks registration against the mounted source and rechecks projection before exposing `&mut T`; Reader `QuestionInputs` resolves a typed `Source` by revision; text/style freezes and typed text writes use per-T `SourceCodec` function tables. The generic product must route those existing operations without erasing a field’s T into an unchecked payload (`source.rs:110-151,259-390`; `reader/inputs.rs:34-85`). Inspector/text/style metadata and `direct` semantics are currently part of the schema behavior, not optional optimization details.
* `scan()` currently returns an exact-size iterator after allocating a `Vec` with capacity `len`; `check_aliases` also collects projections and checks every pair O(F²) (`source.rs:872-898,1008-1028`). Replacing per-field boxes will not by itself remove those operation-time allocations or quadratic validation. Do not count them as schema allocation savings.

## Ledger (64-bit, allocator overhead excluded)

For F direct descriptors registered as `field`, current representation has at least `40F` bytes of separately allocated `Source` payload, `8F` bytes of Vec box pointers, `8F` bytes of owner IDs, allocator metadata for F field boxes, and vector capacity slack. For `direct`, omit the owner-ID vector term. Nested components add one `Box<ComponentEntry>` each (fat-pointer slot plus entry payload), with each embedded child `Sources` owning its own Vec headers and descendant allocations. `Sources::new()` has three Vec headers plus error/counters even when empty; those empty Vecs do not allocate.

Typed borrowed HList estimate for F direct fields and C components: `8F` bytes of descriptor references; each component contributes an 8-byte declaration reference plus scope range (typically 8 bytes) unless ranges are recomputed; owner/direct and parent/direct mode can be zero-sized type markers; the tail/product links add no separate pointer if represented inline; no per-field/per-child heap. Then add one root allocation sized to the concrete schema product, unless empty, plus the runtime `Option<Box<dyn Schema<M>>>` facade (normally two words on 64-bit targets for the data pointer and vtable metadata, with None using a niche; confirm the target layout rather than depending on it). A tuple/HList does not make the inline tree process-shared. A `Vec<&dyn Field<M>>` alternative uses `16F` bytes of field handles plus vector capacity and one vector allocation, with component allocations unchanged.

These are representation arithmetic only, not measured Rust layouts. Exact `BindError`/enum padding, root facade layout, allocator size classes, codegen and cache effects need target measurement. No speed or total-memory win is claimed from the formulas alone.

## Cost and risk ledger

* **Deleted:** one allocation and one erased-field payload per field; one allocation and one boxed child schema entry per declared component; the separate `owner_fields` storage if dependency mode is carried in the typed node; the three vector headers at each typed subtree; recursive `Sources<C>` materialization as a heap-owning object.
* **Added/retained:** at most one nonempty root schema allocation; one 8-byte static-descriptor reference per source per owner; one component declaration ref and either scope range fields or repeated traversal; the same runtime signal scan/alias-check scratch allocations; borrowed trait-object coercions at dynamic routing boundaries; code generated for schema operations specialized over each view’s product type.
* **Compile/code size:** generic leaf-specialized validation, lookup, serialization, revision and scan code can multiply across model/product types. It trades per-field vtable calls for monomorphized traversal; whether that reduces latency or total working set is unknown. Long HLists increase trait/type-check recursion and drop glue; balanced products or a bounded arity builder may be needed, but array chunks cannot hold heterogeneous leaves without erasure. Measure build wall time, object text size, runtime schema bytes, and schema-operation counters before adopting broadly.
* **Stack/drop:** no per-child heap means concrete product construction moves inline values and drops typed nested fields. The existing 128 component depth limit is helpful, but a long direct-field HList is a separate depth axis. Add a compile fixture with hundreds of mixed declarations and nested components, plus drop-stack/depth boundary tests; consider balanced products.
* **Legacy integration:** add `source_schema` with a default Legacy wrapper; mount into a stable `MountedSources` facade; route `FieldAction`, component handler admission, Reader input resolution, inspector, text/style resolution, runtime scope lookup, and tests through it. Keep legacy builder and public Source API through transition. The alternative is breaking `View` overrides or changing public API so `View::source_schema()->impl ...` replaces `sources`; do not present that as source-compatible.

## Falsifying gates before adoption

1. Compile tests prove `C::source_schema()` can be stored as an inferred generic child `S` and nested in a parent RPITIT return on the project MSRV/edition; `source_schema` default wrapper must preserve all old `sources()` implementations. Project manifest is edition 2024; it does not currently declare `rust-version`.
2. Run existing source/component/Reader/text/style/inspector/remote tests unchanged through the facade; add adversarial duplicate IDs/names, nested same-child repeated slots, local-vs-scoped IDs, mismatched read/write projections, projector aliasing, direct-vs-owner invalidation, child handler wrong-receiver, and scope-end overflow/depth-limit cases.
3. Assert schema allocation counts: empty typed schema = 0; nonempty typed schema = exactly one root allocation; N fields and C nested slots = no additional schema allocations. Separately count scratch allocations in `scan`/alias validation so they are not mistaken for schema allocations.
4. Compare `size_of` and allocation bytes for realistic flat and nested models, total text size, and compile time against current Vec<Box> schema and safe borrowed-trait-object vector. Reject if monomorphized operation code or inline product footprint erases the allocation/cache benefit.

## Source references

* Local exact behavior: [`source.rs` (field descriptors, boxed schema builders and validation)](/root/gpui-ce3/reactivity/crates/gpui/src/source.rs:36), [`lib.rs` (View compatibility point)](/root/gpui-ce3/reactivity/crates/gpui/src/lib.rs:72), [`component.rs` (typed child projections)](/root/gpui-ce3/reactivity/crates/gpui/src/component.rs:18), [`element.rs` (handler schema downcasts)](/root/gpui-ce3/reactivity/crates/gpui/src/element.rs:270), [`reader/inputs.rs` (Source-driven typed readers)](/root/gpui-ce3/reactivity/crates/gpui/src/reader/inputs.rs:25).
* Rust language: [RPIT and RPITIT in the Reference](https://doc.rust-lang.org/reference/types/impl-trait.html); [Rust 1.75 stabilization](https://blog.rust-lang.org/2023/12/28/Rust-1.75.0.html); [associated-type default restriction](https://doc.rust-lang.org/reference/items/associated-items.html); [const-generic type restrictions](https://doc.rust-lang.org/reference/items/generics.html#const-generics); [constant-promotion rule](https://doc.rust-lang.org/reference/destructors.html#constant-promotion).
* Contrast, not an implementation dependency: Bevy’s `QueryData` docs explain reusable/composable query products, but its custom query interface has unsafe fetch/access obligations and its named custom-product ergonomics use a derive macro; that does not meet this feature’s safe/macro-free constraints as-is ([Bevy source docs on `QueryData`](https://github.com/bevyengine/bevy/blob/main/crates/bevy_ecs/src/query/fetch.rs), current docs [0.20.0](https://docs.rs/bevy/latest/bevy/ecs/query/derive.QueryData.html)).
