Research only. Read the follow-up erasure/root-dispatch corrections together. The private TAIT combination now compiles in a small isolated experiment, including instantiated recursion and stable-toolchain rejection controls; see [constructibility evidence](../evidence/schema-owner-tait/README.md). No production schema rewrite, memory/performance win or complete authority proof is established.

# Private generic TAIT for inline mounted schemas

Status: bleeding-edge formulation only; **not compiled**. No GPUI files/builds changed. This investigates whether a private generic type-alias `impl Trait` (TAIT) can let `Runtime<M>` store the typed schema inline without exposing S in `Win<M>` and without a root trait object.

## Proposed shape

```rust
#![feature(type_alias_impl_trait)]

trait SourceSchema<M> {
    fn validate_shape(&self) -> Result<(), BindError>;
    fn validate_model(&self, model: &mut M) -> Result<(), BindError>;
    fn signal<'a>(&'a self, model: &'a M, id: FieldId)
        -> Result<&'a dyn ErasedSignal, BindError>;
    fn revision(&self, model: &M, id: FieldId) -> Result<Revision, BindError>;
    fn invalidates_owner(&self, id: FieldId) -> Result<bool, BindError>;
    fn write_text(&self, model: &mut M, id: FieldId, input: String, codec: TextCodec) -> ...;
    fn scan_into(&self, model: &M, out: &mut Vec<(FieldId, Revision)>);
    fn component(&self, id: FieldId) -> Option<&dyn ComponentOps>;
    fn as_ops(&self) -> &dyn SchemaOps; // cold erased handler/path interface
}

// `MountedRoot<M, S>` is just a nominal wrapper (plus ZST PhantomData).
// S is inferred from M::source_schema(), not named by the user.
struct MountedRoot<M, S> { schema: S, _model: PhantomData<fn(M)> }
impl<M, S: SourceSchema<M>> SourceSchema<M> for MountedRoot<M, S> { /* forward */ }

type MountedSchema<M: View> = impl SourceSchema<M>;

#[define_opaque(MountedSchema)]
fn build_schema<M: View>() -> MountedSchema<M> {
    MountedRoot { schema: M::source_schema(), _model: PhantomData }
}

struct Runtime<M: View> {
    model: M,
    schema: MountedSchema<M>, // inline opaque concrete type; no schema Box
    // existing fields
}
```

A child node uses `ComponentNode<P,C,S> { declaration: &'static Component<P,C>, child: MountedChild<C,S>, scope: ..., dependency: ... }`, with `S` inferred from `C::source_schema()` and stored inline. `MountedChild<C,S>` can be a nominal wrapper implementing the child schema trait; no type alias is needed at this layer. Parent RPITIT still hides the whole product from users. Only the top-level TAIT is needed to name that returned product inside `Runtime<M>`.

`Runtime<M>` methods see an opaque *concrete* type bounded by `SourceSchema<M>`, so calls like `self.schema.signal(...)` are statically dispatched through the schema implementation. They do not use `Box<dyn SourceSchema<M>>`; the generic methods on the schema trait are also available if needed because no trait object is used for the root. A leaf lookup reaches `Source<M,T>`-specialized code and returns `&dyn ErasedSignal`; the caller’s existing `Source<M,T>::borrow_registered` downcasts with its known T and verifies projected `Signal<T>` identity. Question resolution is similarly statically dispatched through the root schema, then performs the same typed signal downcast. This avoids the root vcall identified in the previous note.

The generic TAIT definition follows the exact rule highlighted by [E0792](https://doc.rust-lang.org/error_codes/E0792.html): define the alias in a fully generic function `build_schema<M: View>() -> MountedSchema<M>`, not in a specialized `M = SomeView` item. The likely hidden type is `MountedRoot<M, <M as View>::source_schema opaque type>`. That is a nominal generic wrapper around the anonymous associated type, with M captured as a normal generic parameter. The Rust unstable book explicitly permits a TAIT in struct fields and requires `#[define_opaque]` on the item that constrains it ([TAIT Unstable Book, tracking issue #63063](https://doc.rust-lang.org/nightly/unstable-book/language-features/type-alias-impl-trait.html)). RPITIT is already the interface’s user-facing factory. The TAIT is private and internal: it lets this crate use the opaque return in a field without making a public associated type or `Win<M,S>`.

**Constructibility confidence:** the generic capture and field-storage pieces are documented; I found no primary-source rule forbidding a generic TAIT’s hidden type from being a nominal wrapper whose `S` is an RPITIT associated opaque projection. But the exact composition (`#[define_opaque]` generic TAIT + `<M as View>::source_schema()` opaque associated return + generic Runtime field) is not shown by the docs or a checked compiler fixture here. Treat a tiny nightly compile spike as mandatory before investing in migration. It could fail due to current opaque-type normalization/defining-use restrictions even though each feature separately supports the pieces.

## Why this is different from the boxed-root plan

The boxed-root design adapts to the current `Runtime<M>` by putting S behind `Box<dyn Schema<M>>`; this gives one root vcall per operation and one extra schema allocation. The private TAIT makes the field `MountedSchema<M>` itself. It removes that root vcall and schema allocation while leaving the public `Win<M>` generic shape untouched. Runtime already stores `Option<Box<Runtime<M>>>` in `Win<M>` (`runtime.rs:907-910`), so the schema’s nonempty inline product shares the existing Runtime allocation; it does not create another root block.

On the typed path, expected added inline size is one 8-byte reference per source declaration, plus component descriptor references and optional 8-byte scope ranges; child product contents are recursively embedded. Type-level owner/direct modes can be ZST. The source declarations themselves remain in shared static storage. A typed empty product is ZST and adds no bytes/allocations to Runtime. This does **not** apply to old View implementations if the new `source_schema()` default wraps `Self::sources()` for compatibility: even an empty legacy `Sources<M>` contains its three Vec headers/error/counters, although its Vecs allocate nothing. Legacy models retain the old per-field/component allocations until they opt into a typed product. A fully migrated typed schema removes field boxes, component boxes, per-level child `Sources` headers, and `owner_fields` Vec storage if dependency mode is encoded in the product.

The one Runtime allocation may cross an allocator size class when the inline source tree grows. A very large product also increases Runtime’s contiguous allocation size. This is a size/caching trade, not an unqualified win; compare `size_of::<Runtime<M>>()`, requested allocation bytes, and allocator usable sizes on supported targets.

## Real recursive-schema limitation

TAIT does not make an infinitely recursive by-value product legal. If `Node::source_schema()` contains a component whose child schema is `Node::source_schema()` again, its hidden type equation is essentially:

```text
NodeSchema = Product<..., ComponentNode<Node, NodeSchema>>
```

That is an opaque recursive type/infinite-size by-value cycle, rejected like the Reference’s recursive opaque `impl Trait` example (E0720) and its recursive nominal-type size rule (E0072). Rust’s E0720 states an opaque type must expand to a concrete type with no recursive `impl Trait` expansion ([E0720](https://doc.rust-lang.org/error_codes/E0720.html)); recursive nominal layouts need a pointer indirection ([E0072](https://doc.rust-lang.org/error_codes/E0072.html)). The shipping Sources builder currently calls `C::sources()` while registering a component and detects/bounds recursive schema construction at runtime with `ComponentDepthLimit` at depth 128 (`source.rs:804-809`). A direct inline RPITIT product cannot preserve that runtime behavior for a self-recursive component type: it becomes a compile-time opaque recursion before the 128 check can run.

Therefore this representation is fully box-free only for an acyclic *type-level* component schema graph. To preserve a recursive component model, mark recursive/dynamic edges and erase/box at that edge, or keep the legacy dynamic schema for that owner. The former reintroduces at least one indirection/allocation per recursive schema edge/instance unless a better finite runtime representation is devised. Do not claim that all component boxes are deleted until recursive View graphs are either excluded by an explicit supported contract or handled with a measured bounded-erasure strategy. Existing current code’s depth-limit error is evidence this behavior was intentionally anticipated, even if no focused self-recursion test was found in the local source.

## Object-erased cold routes still remain

The TAIT removes root erasure for methods reached through `Runtime<M>` where M is known. It does not make a `Handler` trait object generic over child product S. `ComponentRoute` and possible `SourcePath` are runtime-erased, so their cold route still needs `SchemaOps` / borrowed `ComponentOps`: schema operation receives `&dyn Any` model, performs type checks, finds component ID, compares registered and candidate projected child references, then passes child receiver and `child.as_ops()` recursively. The child product remains inline; only the borrowed callback boundary is erased. No child box, side map, raw offsets, or stored pointer is needed in the acyclic case. The component downcast/vcall costs described in `source-schema-erasure-gap.md` still apply there. Runtime field reads/revisions and `QuestionInputs<M>` do not take that route.

For `.field()`/Questions, typed API signatures remain `Source<M,T>::borrow_registered(model: &M, schema: &impl SourceSchema<M>)` or `QuestionInputs<M>::resolve(model, &impl SourceSchema<M>, ...)`. Since Runtime knows the opaque TAIT type, generic/static dispatch is direct. `signal` returns erased `ErasedSignal`; typed callers verify `Signal<T>` using Any as in current `Source::borrow_registered` (`source.rs:118-132`) and `ErasedSignal::same` (`source.rs:228-236`). No generic method needs to be added to a trait object. Text/style codecs continue to receive the type-erased Signal and use the stored T-specific codec callback.

## Stable 1.97 and compatibility cost

The current pinned production toolchain is stable 1.97. `type_alias_impl_trait` remains listed in the official Unstable Book under feature gate `#![feature(type_alias_impl_trait)]` and tracking issue rust-lang/rust#63063; `#[define_opaque]` is part of that unstable workflow. This is not available on stable 1.97. Adopting it means pinning nightly for crate builds, CI, rustfmt/clippy/rustdoc and developer tooling, with future nightly regression risk. A prebuilt nightly-compiled crate might be consumable from a stable application if no unstable syntax/feature leaks into public metadata, but that needs a separate downstream compatibility fixture; source builds of this crate would require nightly.

No stable equivalent preserves all three constraints (public `Win<M>` unchanged, opaque schema field inline, no root dynamic dispatch):

* Stable RPITIT can return an opaque value but cannot be named as a struct field/type alias; the Reference limits `impl Trait` to argument/return positions outside unstable TAIT ([Reference](https://doc.rust-lang.org/reference/types/impl-trait.html#limitations)).
* A stable associated type (`type Schema`) can name S, but it is required in each View implementation and has no stable default; old Views would need broad source edits. It also exposes a product type to users unless hidden by an unstable opaque alias.
* `Runtime<M,S>`/`Win<M,S>` carries S directly but changes public types and constructors’ inference/signatures.
* A trait object, captured callback, global registry, or indirect function table restores compatibility but returns one root dispatch, allocation, map lookup or synchronization cost.

## Falsifiable gates for a nightly spike

1. Minimal language spike: generic `MountedSchema<M>` alias, `#[define_opaque] build_schema<M: View>()`, hidden return constructed as `MountedRoot<M,_>{ schema: M::source_schema() }`, and a generic `Runtime<M>` field. Compile with the pinned/nightly candidate. Verify that the associated opaque projection is accepted as the hidden type for every M and that `Runtime<M>::schema.signal(...)` generates static dispatch (inspect LLVM/MIR later; this task did not build).
2. Compile two unrelated downstream View impls whose `source_schema` returns different hidden product shapes; instantiate `Win<M>` for each. This tests whether generic TAIT captures the per-impl RPITIT output instead of accidentally requiring one concrete schema for every M.
3. Empty typed schema is `size_of::<MountedSchema<EmptyView>>() == 0` (if product design says ZST), with zero schema allocs. Nonempty typed schema adds only inline product bytes inside existing Runtime box; zero new schema box. Compare requested/usable Runtime allocation sizes and field/component allocation counts.
4. Self-recursive View schema compile fixture. Expect compile rejection/E0720; decide whether recursive schema graphs are unsupported or retain edge erasure/legacy fallback. Test mixed legacy child inside typed parent too; its inner `Sources<C>` allocations persist by design.
5. Run duplicate-name/id, projection mismatch, alias, scope overflow/depth, component route, Questions, codecs, inspector, and panic/drop tests. Structural duplicate validation on typed products must keep errors and first-error order. Product construction panic must drop partial inline children; mount failure must drop the whole typed Runtime/schema before publication.
6. Compile time, code-size, `Runtime<M>` inline size, and stress fixtures with hundreds of fields/nested components. TAIT enables every schema operation to monomorphize over S, which can grow generic code and trait solver work. Reject if compile/developer/toolchain cost outweighs saved boxes and one root dispatch.

## Primary sources and local behavior

* [Unstable Book: `type_alias_impl_trait` and `#[define_opaque]`](https://doc.rust-lang.org/nightly/unstable-book/language-features/type-alias-impl-trait.html), tracking issue [rust-lang/rust#63063](https://github.com/rust-lang/rust/issues/63063).
* [E0792: generic TAIT must be defined fully generically](https://doc.rust-lang.org/error_codes/E0792.html); [E0720: recursive opaque type](https://doc.rust-lang.org/error_codes/E0720.html); [E0072: recursive type needs indirection](https://doc.rust-lang.org/error_codes/E0072.html).
* [Rust Reference: RPITIT anonymous associated type and current stable limitations](https://doc.rust-lang.org/reference/types/impl-trait.html).
* Local: [`Win<M>` already owns `Box<Runtime<M>>`](</root/gpui-ce3/reactivity/crates/gpui/src/runtime.rs:907>); [`Runtime<M>` stores Sources inline](</root/gpui-ce3/reactivity/crates/gpui/src/runtime.rs:842>); [`View::sources`](</root/gpui-ce3/reactivity/crates/gpui/src/lib.rs:74>); [`register_component` runtime recursion/depth guard](</root/gpui-ce3/reactivity/crates/gpui/src/source.rs:773>); [`Source::borrow_registered`/Any T verification](</root/gpui-ce3/reactivity/crates/gpui/src/source.rs:118>).
