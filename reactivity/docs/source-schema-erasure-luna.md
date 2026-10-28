Research only. Read the follow-up erasure/root-dispatch corrections together. The private TAIT combination now compiles in a small isolated experiment, including instantiated recursion and stable-toolchain rejection controls; see [constructibility evidence](../evidence/schema-owner-tait/README.md). No production schema rewrite, memory/performance win or complete authority proof is established.

# Closing the hidden-child-schema erasure gap

Status: **proposed implementation formulation, unbuilt/uncompiled**. This deepens `source-schema-elimination.md`; it does not modify either worktree. It specifically addresses the fact that `ComponentEntry<P,C,S>` cannot be recovered by `Any` when callers know `P,C` but RPITIT hides `S`.

## Core correction

Do not downcast the child node to `ComponentEntry<P,C,S>`. Do not expose `S` in `Component::view`, `SourcePath`, or `QuestionInputs`. Give every typed schema node a zero-state generic wrapper `SchemaFor<M,S>` and make lookup return a *borrowed object-safe component interface* that erases the child model/schema operation, not the child schema allocation.

```rust
trait SchemaOps: Any {
    fn model_type_id(&self) -> TypeId;
    fn signal_any<'a>(&'a self, model: &'a dyn Any, id: FieldId)
        -> Result<&'a dyn ErasedSignal, BindError>;
    fn component(&self, id: FieldId) -> Option<&dyn ComponentOps>;
    fn contains(&self, id: FieldId) -> bool;
    fn scope_span(&self) -> u32;
    // If a path API needs it: `resolve_any(model, signal)` and other erased ops.
}

// Concrete, static dispatch for the normal typed runtime and QuestionInputs.
trait TypedSchema<M: 'static> {
    fn signal<'a>(&'a self, model: &'a M, id: FieldId)
        -> Result<&'a dyn ErasedSignal, BindError>;
    fn component(&self, id: FieldId) -> Option<&dyn ComponentOps>;
    fn validate(&self, model: &mut M) -> Result<(), BindError>;
    fn revision(&self, model: &M, id: FieldId) -> Result<Revision, BindError>;
    fn invalidates_owner(&self, id: FieldId) -> Result<bool, BindError>;
    fn write_text(&self, model: &mut M, id: FieldId, ...) -> ...;
    fn scan_into(&self, model: &M, output: &mut Vec<...>);
    fn as_ops(&self) -> &dyn SchemaOps; // explicit conversion; avoids trait upcasting reliance
}

struct SchemaFor<M, S> { inner: S, _model: PhantomData<fn(M)> }
struct ComponentNode<P, C, S, Dependency> {
    declaration: &'static Component<P, C>,
    child: SchemaFor<C, S>, // inline; no Box, no child header
    scope: ScopeRange,      // 8 bytes if start/end are stored; can be derived instead
    _dependency: PhantomData<Dependency>,
}
trait ComponentOps: Any {
    fn id(&self) -> FieldId;
    fn name(&self) -> &'static str;
    fn parent_type_id(&self) -> TypeId;
    fn child_type_id(&self) -> TypeId;
    fn start(&self) -> u32;
    fn end(&self) -> u32;
    fn project_read<'a>(&self, parent: &'a dyn Any) -> Result<&'a dyn Any, BindError>;
    fn project_write<'a>(&self, parent: &'a mut dyn Any) -> Result<&'a mut dyn Any, BindError>;
    fn child_ops(&self) -> &dyn SchemaOps;
}
```

`SchemaFor<M,S>` implements `TypedSchema<M>` by forwarding to `S: SchemaProduct<M>` and implements `SchemaOps` by downcasting the erased model to `M`, then forwarding to the same typed product. `ComponentNode<P,C,S>` implements `ComponentOps`; its `child_ops()` is just `&self.child` coerced to `&dyn SchemaOps`. The wrapper carries the hidden `S` inline, so that coercion is legal at the node’s concrete implementation without naming S anywhere else. The product visitor returns `&dyn ComponentOps` for the matching registered ID. This uses standard trait-object erasure over a borrowed inline value, not `Any` downcasting from a type whose S is unknown.

The object-safe traits above have no type-parameter methods. Fixed lifetime parameters are permitted on dyn-compatible methods; adding `fn find<C>(...)` or a generic visitor method to `SchemaOps`/`ComponentOps` would destroy dyn compatibility. The Reference’s dyn-compatibility rules disallow dispatchable methods with type parameters and RPIT/async return types ([Rust Reference: dyn compatibility](https://doc.rust-lang.org/reference/items/traits.html#dyn-compatibility)). Keep RPITIT on the statically called `View::source_schema() where Self: Sized`; it is the factory, not the mounted object interface. RPITIT is stable since Rust 1.75 ([announcement](https://blog.rust-lang.org/2023/12/28/Rust-1.75.0.html)).

## Exact call paths

### Child component lookup and projected path/handler routing

Replace `Sources::component_entry::<C>(id) -> &ComponentEntry<P,C>` (which currently scans then downcasts the concrete child schema type at `source.rs:827-842`) with:

```rust
let node: &dyn ComponentOps = parent_schema.component(component.id)
    .ok_or(BindError::UnknownComponent(component.id))?;
if node.parent_type_id() != TypeId::of::<P>()
   || node.child_type_id() != TypeId::of::<C>() {
    return Err(BindError::ReceiverMismatch);
}
let registered_child = node.project_read(parent as &dyn Any)?
    .downcast_ref::<C>().ok_or(BindError::ReceiverMismatch)?;
let candidate_child = (self.read)(parent);
if !std::ptr::eq(registered_child, candidate_child) {
    return Err(BindError::ComponentProjectionMismatch(self.id));
}
handler.owner_scope(candidate_child as &dyn Any, node.child_ops())
```

For a `ComponentRoute<P,C>`, `Route::owner_scope/admit` receive `&dyn SchemaOps` instead of `&dyn Any`. The route first checks root/parent schema `model_type_id`; it uses `component(id)` and the borrowed `ComponentOps` handle. It does not downcast to a node whose S is unknown. Recursing into the child handler supplies the concrete child receiver (`C` erased as Any) and `node.child_ops()`; a nested route repeats with the child’s `SchemaOps`. `admit_handler` performs the same registered-projection identity check before child admission. This preserves the current rule that two IDs with the same child type are not enough: their projected child references must agree. The route’s candidate projector is still the handler’s declared projector; the registry’s is still the schema declaration. Neither is compared by function address.

For mutable projection, the node implementation is typed as `P,C`, so it can preserve the current check exactly: call registered read, save its address as an opaque raw pointer, then call registered write and compare pointers, returning `&mut C` only on match. The parent `Any` is downcast to `P` before that. This retains the existing narrow pointer-equality use at `component.rs:50-57`; it introduces no raw offset, retained address, or unsafe operation. The generic root’s ordinary `TypedSchema<M>::validate` likewise calls typed `ComponentNode<P,C,S>` and validates child schema recursively.

For a nested `SourcePath`, each component segment resolves through `SchemaOps::component(id)`, checks its checked scope interval and projector, maps the global FieldId to local (`local = (field.local, field.scope - start)` as at `source.rs:598-606`), then descends through `child_ops()`. The leaf path resolves a typed Source by its registered FieldId and compares the projected signal with `ErasedSignal::same`; it must not rerun `View::source_schema()` or infer identity from revision, name, address, or value. `Source::borrow_registered` is the current authority (`source.rs:118-132`). If the normal runtime already has a qualified FieldId, the range walk can choose the child by range and need not reconstruct a component list from the path.

### `field()` and Questions

`field()`/`direct()` stay typed at declaration and only store the borrowed descriptor plus dependency mode. `Source::validate_registered` and `borrow_registered` change their registry parameter from concrete `&Sources<M>` to `&dyn TypedSchema<M>` (or `&MountedSources<M>` forwarding the same typed method); the source T remains known. `QuestionInputs<M>::resolve` in `reader/inputs.rs:54-85` continues to take a typed mounted registry and calls `signal(model,id)`, so its `Source<M,T>` path does not see SchemaOps/Any or a hidden child S. If `QuestionInputs` is later allowed a scoped `SourcePath`, it can call the same `TypedSchema<M>::signal` with a qualified root FieldId. Questions remain `Source`-version based; never rerun child schema construction when mounting a question and never use revision as the source key.

One stable outer `MountedSources<M>` wrapper stays concrete for existing `Handler::admit(receiver, sources: &dyn Any)`/`Route::admit` downcasts in `element.rs:270-300,350-378`: change those schema arguments to `&dyn SchemaOps`, or have the wrapper’s method pass `self` as that trait object. The *wrapper* is known at the boundary; the child schema type S is not. `MountedSources<M>` owns `Option<Box<dyn TypedSchema<M>>>` (one root box for nonempty typed schema, none for empty), implements the public typed source query methods, and implements `SchemaOps` by forwarding through `as_ops()`. It is not a map or per-child adapter collection. Legacy `Sources<M>` is placed behind a `SchemaFor<M, Legacy<M>>` adapter as one old representation; it continues to have old child/per-field allocations until migrated.

## What this actually buys, and runtime price

For the **new typed-product path**, there is no `Box<ComponentEntry>` and no child `Sources<C>` Vec header per declared component. The child `SchemaFor<C,S>` and its whole typed product live inline in the parent’s one root payload. Every declared field still costs one borrowed static reference (8 bytes on 64-bit) in the product; every component costs its descriptor ref plus optional 8-byte start/end and its inline child product. Direct/owner dependency can be a type marker. The only erased handle is borrowed `&dyn ComponentOps`/`&dyn SchemaOps` while routing; no per-child heap or retained map is introduced. An empty typed product can be ZST and mount to `None`.

The price is not zero. Current handler recursion (`ComponentRoute::owner_scope` at `element.rs:288-300`, then `Component::handler_scope` at `component.rs:83-99`) performs receiver and Sources downcasts, a Vec component search, then a concrete `ComponentEntry<P,C>` Any downcast and child projection check. The proposed cold routing path performs a schema component search and borrowed trait call, type-ID check, an Any parent downcast in the component projector, an Any child downcast to C, then child handler recursion. Depending on whether component lookup and projection are fused, this may be similar or add one type check/vcall; it is not claimed faster. Ordinary source reads/revisions and Question resolution remain in `TypedSchema<M>` and recurse with typed `&P`/`&C`; they do not pay an Any model downcast per nested component. The handler/source-path erased path is cold relative to normal field operations but must be measured. The existing root `Sources<M>` vector searches disappear only if the product’s component lookup is implemented directly over its typed children; implementation should preserve an O(number of statically declared sibling components) bound, not add a global HashMap.

Do not claim the old nested allocation ledger gone for legacy schemas. The defaulted `source_schema()` adapter wrapping `Self::sources()` preserves existing implementors; those schemas keep their Vecs/field boxes until ported. A typed schema with borrowed refs uses one root box and inline components. This is a migration win only for implementations that opt in.

## Rust limits / why not a generic method

A typed `fn component<C>(&self, id) -> &ComponentEntry<M,C,...>` is not object-safe and cannot be called through `Box<dyn TypedSchema<M>>`. RPITIT child types are anonymous associated types and are not nameable by generic external routing code; the language solution is not to guess S, but to keep S behind a borrowed `SchemaOps` object created by `SchemaFor<C,S>`. `SchemaFor`’s model parameter and inner S stay statically known inside the node. This uses the object-safe operations with fixed erased types. It does not add a generic method to the root trait.

## Specific falsifiers

1. A compiler fixture must demonstrate that `SchemaFor<C, C::source_schema() hidden type>` is inferred when passed through `component<P,C,S>` and that `&self.child as &dyn SchemaOps` is legal at the nested node. This must run at the actual project MSRV; manifest is 2024 edition but has no `rust-version`.
2. Object-safe fixture: assert `&dyn TypedSchema<M>` and `&dyn SchemaOps` compile with lifetime-only methods, and a negative compile fixture rejects generic `find<C>` on either interface.
3. Re-run projection adversaries: wrong registered component type, same C but different child field, read/write projector mismatch, component ID collision, aliased Source signal, wrong nested handler receiver, two same-C slots with distinct IDs/scopes, scope overflow/depth limit, direct-vs-owner dependency and source replacement.
4. Instrument schema allocations: one root allocation for nonempty typed schema; zero field/component allocations; no per-owner child headers; legacy default behavior explicitly counts as legacy allocations. Measure dynamic handler route checks/calls separately from typed signal lookup. Compare flat and deep products, code size, compile time, and long-HList stack/drop behavior before claiming a net win.

## Exact current local anchors and primary source

* Current hidden-type concrete downcast: [`Sources::component_entry`](</root/gpui-ce3/reactivity/crates/gpui/src/source.rs:827>); the component entry stores child `Sources<C>` and scope bounds at [`ComponentEntry`](</root/gpui-ce3/reactivity/crates/gpui/src/source.rs:590>).
* Callers depending on that exact `Sources<C>`: [`Component::handler_scope/admit_handler`](</root/gpui-ce3/reactivity/crates/gpui/src/component.rs:83>) and [`ComponentRoute`](</root/gpui-ce3/reactivity/crates/gpui/src/element.rs:288>); route trait object downcasts `Sources<M>` for field action at [`element.rs`](</root/gpui-ce3/reactivity/crates/gpui/src/element.rs:350>).
* Scope conversion and source authority: [`ComponentEntry::qualify/local`](</root/gpui-ce3/reactivity/crates/gpui/src/source.rs:597>), [`Source::borrow_registered`](</root/gpui-ce3/reactivity/crates/gpui/src/source.rs:118>), [`Sources::signal`](</root/gpui-ce3/reactivity/crates/gpui/src/source.rs:899>), [`QuestionInputs<Source>::resolve`](</root/gpui-ce3/reactivity/crates/gpui/src/reader/inputs.rs:54>).
* Rust: [Reference: dyn compatibility](https://doc.rust-lang.org/reference/items/traits.html#dyn-compatibility); [Reference: RPITIT anonymous associated types and captures](https://doc.rust-lang.org/reference/types/impl-trait.html#return-position-impl-trait-in-traits-and-trait-implementations); [Rust 1.75 stabilization](https://blog.rust-lang.org/2023/12/28/Rust-1.75.0.html).
