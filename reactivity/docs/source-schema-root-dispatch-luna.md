Research only. Read the follow-up erasure/root-dispatch corrections together. The private TAIT combination now compiles in a small isolated experiment, including instantiated recursion and stable-toolchain rejection controls; see [constructibility evidence](../evidence/schema-owner-tait/README.md). No production schema rewrite, memory/performance win or complete authority proof is established.

# Typed source products with `Runtime<M>`: the unavoidable root dispatch

Status: **correction/precision addendum**, proposed and unbuilt. This supersedes any reading of the prior erasure-gap note that ordinary Source/Question resolution has zero dynamic dispatch. Since public `Win<M>`/`Runtime<M>` carries no schema type S, a nonempty product cannot be invoked statically from the runtime without changing the public/runtime type shape, rebuilding the schema, or introducing another dynamic registry. The practical compatible design pays one root dispatch per schema operation.

## Concrete erased-at-mount shape

```rust
trait SchemaProduct<M> { // static product implementation; generic over its concrete type
    fn signal<'a>(&self, model: &'a M, id: FieldId)
        -> Result<&'a dyn ErasedSignal, BindError>;
    fn component(&self, id: FieldId) -> Option<&dyn ComponentOps>;
    fn validate_shape(&self) -> Result<(), BindError>;
    fn validate_model(&self, model: &mut M) -> Result<(), BindError>;
    fn revision(&self, model: &M, id: FieldId) -> Result<Revision, BindError>;
    fn invalidates_owner(&self, id: FieldId) -> Result<bool, BindError>;
    fn write_text(&self, model: &mut M, id: FieldId, input: String, codec: TextCodec) -> ...;
    fn scan_into(&self, model: &M, out: &mut Vec<(FieldId, Revision)>);
}

// This fixed-M trait has no generic method. `S` is behind one vtable in Win<M>.
trait MountedSchema<M> {
    fn signal<'a>(&self, model: &'a M, id: FieldId)
        -> Result<&'a dyn ErasedSignal, BindError>;
    fn component(&self, id: FieldId) -> Option<&dyn ComponentOps>;
    fn validate_shape(&self) -> Result<(), BindError>;
    fn validate_model(&self, model: &mut M) -> Result<(), BindError>;
    fn revision(&self, model: &M, id: FieldId) -> Result<Revision, BindError>;
    fn invalidates_owner(&self, id: FieldId) -> Result<bool, BindError>;
    fn write_text(&self, model: &mut M, id: FieldId, input: String, codec: TextCodec) -> ...;
    fn scan_into(&self, model: &M, out: &mut Vec<(FieldId, Revision)>);
    fn as_ops(&self) -> &dyn SchemaOps;
}

struct SchemaFor<M, S> { product: S, _model: PhantomData<fn(M)> }
impl<M, S: SchemaProduct<M>> MountedSchema<M> for SchemaFor<M, S> {
    // Each entry delegates to `self.product` with a statically known S.
    // `as_ops` returns `self` through a borrowed object-safe interface.
}
struct MountedSources<M> { root: Option<Box<dyn MountedSchema<M>>> }
struct Runtime<M> { model: M, sources: MountedSources<M>, /* existing runtime state */ }
```

At mount, `M::source_schema()` is called once, the inferred product is wrapped as `SchemaFor<M,S>`, shape/duplicate validation runs, then a nonempty root is boxed once. `Runtime<M>` stores the box behind `dyn MountedSchema<M>` because S cannot appear in its type. Empty product takes `None` and allocates nothing. This keeps the public `Win<M>` shape and does not retain an extra adapter/map. A typed `ComponentNode<P,C,S>` embeds `SchemaFor<C,S>` inline and implements a borrowed object-safe `ComponentOps`; `child_ops()` returns that inline child wrapper as `&dyn SchemaOps`. Nested typed product calls know S; the erased route context does not.

## Exactly what dispatch remains

Every call made from code that only has `MountedSources<M>` crosses **one root vtable**: `signal`, `revision`, `validate`, `invalidates_owner`, `write_text`, `scan_into`, `resolve`, and component lookup. After the vtable reaches `SchemaFor<M,S>`, ordinary schema walking is statically dispatched/monomorphized through product S and each inline typed child. It has no per-field `dyn Field` vtable. A flat direct-field product lookup still executes its statically emitted ID comparisons/branches; a nested lookup dispatches once at root and then follows typed component-node code. It is not “fully static,” and no speed claim follows from deleting field boxes.

The existing typed `Source<M,T>` route does not require an object-safe generic `resolve<T>` method. Its signature remains:

```rust
impl<M, T: 'static> Source<M,T> {
    fn borrow_registered<'a>(
        &self, model: &'a M, sources: &MountedSources<M>,
    ) -> Result<&'a Signal<T>, BindError> {
        let selected: &'a Signal<T> = (self.read)(model);
        let registered: &'a dyn ErasedSignal = sources.signal(model, self.id)?;
        if registered.same(selected) { Ok(selected) }
        else { Err(BindError::ProjectionMismatch(self.id)) }
    }
}
```

`MountedSources::signal` makes one vtable call and returns `&dyn ErasedSignal`. `ErasedSignal::same` does the existing `Any::downcast_ref::<Signal<T>>()` and pointer identity check. T stays known at the Source/Question caller, not in the root schema trait. This is the same proof used today in `Source::borrow_registered` (`source.rs:118-132`), with the additional root vtable because storage moved behind an erased schema. A Question’s `QuestionInputs<M> for Source<M,V>::resolve` likewise calls `sources.signal(model,id)` once, compares with its typed read projection, then returns `&V`; its versions remain the selected Signal revision. `write_text` has one root vtable; inside the typed product it reaches `SourceCodec`, whose frozen codec function already uses `Any::downcast_ref::<Signal<T>>()`. Public `revision` has one root vtable and the concrete field node then calls the correct `Signal<T>::revision()`.

The cold handler route uses a separate borrowed erasure. `Route::owner_scope/admit` receives `&dyn SchemaOps`, with methods such as `component(id) -> Option<&dyn ComponentOps>` and erased `project_read/write(&dyn Any)`. It performs component-ID lookup, TypeId/model downcasts, checks projected child identity, and recurses with `node.child_ops()`. This adds a vcall/type checks over current concrete `ComponentEntry<P,C>` downcast; the prior artifact charges it. No component box/map is needed. Typed runtime queries still pay their one root vcall; no per-nested-child `Any` downcasts are necessary in `SchemaProduct<M>::signal`, because the generic ComponentNode knows P,C,S and calls the child product with `&C`.

## Why this root call cannot disappear under the stated type shape

A `dyn MountedSchema<M>` can have only non-generic methods; a generic method like `resolve<T>` is not dyn-dispatchable. `SchemaProduct<M>` may use concrete generic implementations, but Runtime must hold it without knowing S. Rust RPITIT hides S under an anonymous associated type; it does not expose a name that `Runtime<M>` can store. Therefore the erased root must call a non-generic operation, and the leaf returns erased signal data for callers that know T. This is one indirect call per public schema operation, not one call per field.

Alternatives each change a requirement or move the dispatch cost:

* `Runtime<M,S>` / `Win<M,S>` can retain S and statically call operations, but public type signatures, constructor return opacity, and all APIs that currently mention `Win<M>` need a type-parameter redesign; an opaque RPITIT return does not provide a nameable S to put into the existing `Runtime<M>` field. This is a broad public change.
* A named `View::Schema` associated type lets Runtime name S, but associated types cannot have defaults; every existing View implementation must name a product type. A trait method `source_schema() -> impl ...` avoids that source burden precisely by keeping S unnameable.
* Recalling `M::source_schema()` for each operation reconstructs/recurses the declaration tree, violates the “build once” mount semantics, and can rerun arbitrary user schema code. Caching a global `TypeId -> function` table merely replaces the root vtable with a global lookup/indirect function pointer and adds synchronization/lifetime policy.
* A type-erased closure/function-pointer table in `Runtime<M>` is still one indirect root operation; if it captures S it needs allocation or a fat object pointer. No safe function-pointer/data-pair trick removes this dispatch.

Rust’s dyn-compatibility rules prohibit dispatchable generic methods, and RPITIT is represented as an anonymous associated type; see [Reference: dyn compatibility](https://doc.rust-lang.org/reference/items/traits.html#dyn-compatibility), [Reference: RPITIT](https://doc.rust-lang.org/reference/types/impl-trait.html#return-position-impl-trait-in-traits-and-trait-implementations), [Rust 1.75 stabilization](https://blog.rust-lang.org/2023/12/28/Rust-1.75.0.html). The conclusion is design inference from these rules and the fixed `Runtime<M>` shape.

## Construction, validation and drop details

* `source_schema()` and nested `C::source_schema()` are constructed once during mount; do not call them from Source/Question lookup. Product construction contains only borrowed static descriptor refs, mode markers, and inline child products. If schema construction panics, normal Rust partial-value drop runs; no model has been mutated and no mounted root has been published. Root allocation failure also unwinds/drops the constructed product as usual.
* Run duplicate ID/name, nonlocal-ID, component ID/name, checked scope-range, and depth-shape validation before model projector validation. The current fluent API records structural errors at schema construction, then `validate` checks read/write projectors and aliasing (`source.rs:729-750,781-816,872-898`). Typed products can perform the same structural checks with an allocation-free pairwise traversal (O((F+C)^2) worst case) or a temporary scratch vector; don’t claim no allocation if choosing scratch. Preserve the same first-error order if callers/tests observe it.
* Projector validation remains a second phase under exclusive owner borrow. Root schema failure drops the one root box and mount fails; there is no partially installed per-child registry. A dishonest projector callback can panic or have side effects under the same contract as today; a schema redesign does not make arbitrary user callbacks transactional.
* Drop of a nonempty typed root calls the trait-object drop glue once, then drops its inline HList/tree. There are no per-field or per-component heap destructors; long HLists/nested products can still create recursive drop glue/stack depth. Existing component-depth 128 cap does not bound flat-field product depth. Add a many-field compile/drop-stack fixture before adoption.

## Revised cost statement

For a typed nonempty schema, the allocation target remains: one root box, zero field boxes, zero component boxes, zero child `Sources` Vec headers. Per owner still stores an 8-byte source-descriptor reference per declared field, component refs/ranges and the complete inline child product; the root object’s payload can be large. Schema scratch allocations remain if alias validation/scan implementations use Vec. Operation cost is: **one root vcall per schema API operation**, static generic field/component code after it for common typed lookups, plus `Any` checks/borrowed component vtable calls on handler/path routing. The former per-field vcall and allocation disappear only on typed products; legacy adapters retain legacy internals until ported. Measure actual code size, bytes, allocator counts and operation counts; do not infer latency improvement.

## Required gate

Add counters in the eventual benchmark/test harness (not this research): count root schema vtable entries separately from field-node calls; assert every nonempty Source lookup makes one root dispatch and zero per-field vtable calls, and every empty typed view makes none/uses the no-schema branch. Compare to current per-field vtable count and allocations. Also test generic `QuestionInputs` for same-typed fields, nested SourcePath projection mismatch, text codecs, inspector/style reads, duplicate shape failure, panic during schema construction and panic during schema drop. Reject or redesign if root vcall frequency becomes a hot-path bottleneck; with fixed `Runtime<M>` this is the honest ceiling short of changing public generic type shape.

## Relevant local anchors

[`Source::borrow_registered` and generic T check](</root/gpui-ce3/reactivity/crates/gpui/src/source.rs:118>); [`ErasedSignal::same`](</root/gpui-ce3/reactivity/crates/gpui/src/source.rs:228>); [`QuestionInputs<Source>::resolve`](</root/gpui-ce3/reactivity/crates/gpui/src/reader/inputs.rs:54>); [`Runtime<M>` has no schema type S](</root/gpui-ce3/reactivity/crates/gpui/src/runtime.rs:840>); [`View::sources`](</root/gpui-ce3/reactivity/crates/gpui/src/lib.rs:74>); [`component_entry` needs the hidden concrete child type today](</root/gpui-ce3/reactivity/crates/gpui/src/source.rs:827>).
